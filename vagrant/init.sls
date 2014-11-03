{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '1.6.5' %}

vagrant_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'https://dl.bintray.com/mitchellh/vagrant/vagrant_{{ version }}.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/vagrant_{{ version }}.dmg

vagrant_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount vagrant_{{ version }}.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/Vagrant
    - require:
      - cmd: vagrant_download

vagrant_install:
  cmd:
    - run
    - cwd: /Volumes/Vagrant
    - name: sudo installer -verbose -pkg Vagrant.pkg -target /
    - user: {{ user }}
    - unless: test -d /Applications/Vagrant.app
    - require:
      - cmd: vagrant_mount

vagrant_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Vagrant
    - user: {{ user }}
    - onlyif: test -d /Volumes/Vagrant
    - require:
      - cmd: vagrant_install
