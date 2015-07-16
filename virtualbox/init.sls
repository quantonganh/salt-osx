{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set main_version = '4.3.30' %}
{%- set sub_version = '101610' %}
{%- set version = main_version + '-' + sub_version %}

virtualbox_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'http://download.virtualbox.org/virtualbox/{{ main_version }}/VirtualBox-{{ version }}-OSX.dmg'
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

virtualbox_shutdown_runningvms:
  cmd:
    - run
    - name: VBoxManage list runningvms | awk -F '[{}]' '{ print $2 }' | xargs -L1 -I {} VBoxManage controlvm {} poweroff
    - user: {{ user }}
    - onlyif: VBoxManage -v

virtualbox_kill_processes:
  cmd:
    - run
    - name: |
        pkill VBoxXPCOMIPCD
        pkill VBoxSVC
    - require:
      - cmd: virtualbox_shutdown_runningvms

{%- if salt['cmd.run']('VBoxManage -v') not in ('', main_version + 'r' + sub_version) %}
virtualbox_install:
  cmd:
    - run
    - cwd: /Volumes/VirtualBox
    - name: sudo installer -verbose -pkg VirtualBox.pkg -target /
    - user: {{ user }}
    - require:
      - cmd: virtualbox_mount
      - cmd: virtualbox_kill_processes
{%- endif %}

virtualbox_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/VirtualBox
    - user: {{ user }}
    - onlyif: test -d /Volumes/VirtualBox
{%- if salt['cmd.run']('VBoxManage -v') not in ('', main_version + 'r' + sub_version) %}
    - require:
      - cmd: virtualbox_install
{%- endif %}
