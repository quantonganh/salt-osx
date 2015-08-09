{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '0.4.3' %}

keepassx_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'http://www.keepassx.org/releases/KeePassX-{{ version }}.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/KeePassX-{{ version }}.dmg

keepassx_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount KeePassX-{{ version }}.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/KeePassX-{{ version }}/
    - require:
      - cmd: keepassx_download

keepassx_install:
  cmd:
    - run
    - cwd: /Volumes/KeePassX-{{ version }}/
    - name: mv KeePassX.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/KeePassX.app
    - require:
      - cmd: keepassx_mount

keepassx_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/KeePassX-{{ version }}/
    - user: {{ user }}
    - onlyif: test -d /Volumes/KeePassX-{{ version }}/
    - require:
      - cmd: keepassx_install
