{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set main_version = '5.0.0' %}
{%- set sub_version = '101573' %}

include:
  - brew.cask

virtualbox:
  cmd:
    - run
    - name: brew-cask install virtualbox
    - user: {{ user }}
    - unless: brew-cask list | grep virtualbox
    - onlyif: VBoxManage -v != {{ main_version }} + 'r' + {{ sub_version }}
    - require:
      - cmd: brew-cask
{%- if salt['cmd.run']('VBoxManage -v') not in ('', main_version + 'r' + sub_version) %}
      - cmd: virtualbox_kill_processes

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
{%- endif %}
