{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set plugins = salt['pillar.get']('vagrant:plugins', []) %}

include:
  - vagrant

{%- if plugins %}
vagrant_plugins:
  cmd:
    - run
    - name: vagrant plugin install {{ plugins | join(' ') }}
    - user: {{ user }}
    - require:
      - cmd: vagrant
{%- endif %}
