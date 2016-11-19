{%- from "macros.jinja2" import user, home with context %}

include:
  - brew

xhyve:
  pkg:
    - installed
    - require:
      - cmd: brew{% if salt['pillar.get']('brew:update', False) %}_update{% endif %}
  file:
    - directory
    - name: {{ home }}/xhyve
    - user: {{ user }}
    - group: staff
    - mode: 755
