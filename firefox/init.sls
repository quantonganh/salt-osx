{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '31.0' %}

firefox_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'https://download-installer.cdn.mozilla.net/pub/firefox/releases/31.0/mac/en-US/Firefox%20{{ version }}.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/Firefox\ {{ version }}.dmg

firefox_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount Firefox\ {{ version }}.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/Firefox\ {{ version }}
    - require:
      - cmd: firefox_download

firefox_install:
  cmd:
    - run
    - cwd: /Volumes/Firefox/
    - name: cp -r Firefox.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/Firefox.app
    - require:
      - cmd: firefox_mount

firefox_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Firefox/
    - user: {{ user }}
    - onlyif: test -d /Volumes/Firefox/
    - require:
      - cmd: firefox_install
