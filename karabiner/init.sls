{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '10.2.0' %}

karabiner_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'https://pqrs.org/osx/karabiner/files/Karabiner-{{ version }}.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/Karabiner-{{ version }}.dmg

karabiner_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount Karabiner-{{ version }}.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/Karabiner-{{ version }}/
    - require:
      - cmd: karabiner_download

karabiner_install:
  cmd:
    - run
    - cwd: /Volumes/Karabiner-{{ version }}/
    - name: sudo installer -verbose -pkg Karabiner.pkg -target /
    - user: {{ user }}
    - unless: test -d /Applications/Karabiner.app
    - require:
      - cmd: karabiner_mount

karabiner_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Karabiner-{{ version }}/
    - user: {{ user }}
    - onlyif: test -d /Volumes/Karabiner-{{ version }}/
    - require:
      - cmd: karabiner_install
