{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '1.5.10' %}

adium_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'http://downloads.sourceforge.net/project/adium/Adium_{{ version }}.dmg'
    - user: {{ user }}
    - unless: test -f /Users/{{ user }}/Downloads/Adium_{{ version }}.dmg

adium_mount:
  cmd:
    - run
    - cwd: /Users/{{ user }}/Downloads
    - name: hdiutil mount Adium_{{ version }}.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/Adium\ {{ version }}/
    - require:
      - cmd: adium_download

adium_install:
  cmd:
    - run
    - cwd: /Volumes/Adium {{ version }}/
    - name: mv Adium.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/Adium.app
    - require:
      - cmd: adium_mount

adium_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Adium\ {{ version }}/
    - user: {{ user }}
    - onlyif: test -d /Volumes/Adium\ {{ version }}/
    - require:
      - cmd: adium_install
