{%- set home = salt['user.info'](user)['home'] %}
{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}
{%- set version = '2.1.5' %}

vlc_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'http://get.videolan.org/vlc/2.1.5/macosx/vlc-{{ version }}.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/vlc-{{ version }}.dmg

vlc_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount vlc-{{ version }}.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/vlc-{{ version }}/
    - require:
      - cmd: vlc_download

vlc_install:
  cmd:
    - run
    - cwd: /Volumes/vlc-{{ version }}/
    - name: cp -r VLC.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/VLC.app
    - require:
      - cmd: vlc_mount

vlc_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/vlc-{{ version }}/
    - user: {{ user }}
    - onlyif: test -d /Volumes/vlc-{{ version }}/
    - require:
      - cmd: vlc_install
