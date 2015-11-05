{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}

include:
  - vagrant

vagrant_plugins:
  cmd:
    - run
    - name: vagrant plugin install {% for plugin in salt['pillar.get']('vagrant:plugins', []) %}{{ plugin }}{% if not loop.last %} {% endif %}{% endfor %}
    - user: {{ user }}
    - require:
      - cmd: vagrant
