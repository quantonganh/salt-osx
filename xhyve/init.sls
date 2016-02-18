{%- from "macros.jinja2" import user, home with context %}

include:
  - brew

xhyve:
  pkg:
    - installed
    - require:
      - cmd: brew_update
  file:
    - directory
    - name: {{ home }}/xhyve
    - user: {{ user }}
    - group: staff
    - mode: 755
