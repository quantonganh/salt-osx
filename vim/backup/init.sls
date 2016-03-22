{%- from "macros.jinja2" import user, home with context %}

{{ home }}/.vim/backup:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode
