{%- set home = salt['user.info'](user)['home'] %}
{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}
{%- set version = '6.19.0.442' %}

skype_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'http://download.skype.com/macosx/Skype_{{ version }}.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/Skype_{{ version }}.dmg

skype_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount Skype_{{ version }}.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/Skype/
    - require:
      - cmd: skype_download

skype_install:
  cmd:
    - run
    - cwd: /Volumes/Skype/
    - name: cp -r Skype.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/Skype.app
    - require:
      - cmd: skype_mount

skype_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Skype/
    - onlyif: test -d /Volumes/Skype/
    - require:
      - cmd: skype_install
