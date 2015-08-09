{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '1.6.6' %}

soundflower_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount Soundflower-{{ version }}b.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/Soundflower-{{ version }}/

soundflower_install:
  cmd:
    - run
    - cwd: /Volumes/Soundflower-{{ version }}/
    - name: sudo installer -verbose -pkg Soundflower.pkg -target / -allowUntrusted
    - user: {{ user }}
    - unless: test -d /Applications/Soundflower.app
    - require:
      - cmd: soundflower_mount

soundflower_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Soundflower-{{ version }}/
    - user: {{ user }}
    - onlyif: test -d /Volumes/Soundflower-{{ version }}/
    - require:
      - cmd: soundflower_install
