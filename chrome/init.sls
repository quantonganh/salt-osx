{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

chrome_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/googlechrome.dmg

chrome_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount googlechrome.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/googlechrome
    - require:
      - cmd: chrome_download

chrome_install:
  cmd:
    - run
    - cwd: /Volumes/Google Chrome/
    - name: cp -r Google\ Chrome.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/Google\ Chrome.app
    - require:
      - cmd: chrome_mount

chrome_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Google\ Chrome/
    - user: {{ user }}
    - onlyif: test -d /Volumes/googlechrome
    - require:
      - cmd: chrome_install
