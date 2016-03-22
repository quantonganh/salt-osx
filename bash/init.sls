{%- from "macros.jinja2" import user, home with context %}

{{ home }}/.bashrc:
  file:
    - managed
    - template: jinja
    - source: salt://bash/rc.jinja2
    - user: {{ user }}
    - group: staff
    - mode: 644

{{ home }}/.bash_profile:
  file:
    - managed
    - template: jinja
    - source: salt://bash/profile.jinja2
    - user: {{ user }}
    - group: staff
    - mode: 644
