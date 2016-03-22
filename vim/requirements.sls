{%- from "macros.jinja2" import user, home with context %}

{{ home }}/.vim/bundle:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755
