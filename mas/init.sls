{%- from "macros.jinja2" import user with context %}
{%- set apps = salt['pillar.get']('mas:apps', {}) %}

include:
  - brew

mas:
  pkg:
    - installed
    - require:
      - cmd: brew

{%- if apps %}
  {%- for id, app in apps.iteritems() %}
mas_{{ app|replace(' ', '_')|lower }}:
  cmd:
    - run
    - user: {{ user }}
    - name: mas install {{ id }}
    - unless: test -d /Applications/{{ app }}.app
    - require:
      - pkg: mas
  {%- endfor %}
{%- endif %}
