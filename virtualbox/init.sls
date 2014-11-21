{%- set home = salt['user.info'](user)['home'] %}
{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}
{%- set version = '4.3.14-95030' %}

virtualbox_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'http://download.virtualbox.org/virtualbox/4.3.14/VirtualBox-{{ version }}-OSX.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/VirtualBox-{{ version }}-OSX.dmg

virtualbox_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount VirtualBox-{{ version }}-OSX.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/VirtualBox
    - require:
      - cmd: virtualbox_download

virtualbox_install:
  cmd:
    - run
    - cwd: /Volumes/VirtualBox
    - name: sudo installer -verbose -pkg VirtualBox.pkg -target /
    - user: {{ user }}
    - unless: test -d /Applications/VirtualBox.app
    - require:
      - cmd: virtualbox_mount

virtualbox_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/VirtualBox
    - user: {{ user }}
    - onlyif: test -d /Volumes/VirtualBox
    - require:
      - cmd: virtualbox_install
