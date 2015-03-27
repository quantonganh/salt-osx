{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}

include:
  - vagrant

vbox_snapshot_install:
  cmd:
    - run
    - name: vagrant plugin install vagrant-vbox-snapshot
    - user: {{ user }}
    - require:
      - cmd: vagrant_install
