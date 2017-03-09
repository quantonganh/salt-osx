{%- from 'macros.jinja2' import home %}

prezto:
  file:
    - absent
    - names:
      - {{ home }}/.zprezto
      - {{ home }}/.zpreztorc

{%- for zfile in ('zlogin', 'zlogout', 'zprofile', 'zshenv', 'zshrc') if salt['file.file_exists'](home ~ '/.' ~ zfile) -%}
  {%- set full_pathname = home ~ '/.' ~ zfile -%}
  {%- if salt['cmd.run']('test -L ' ~ full_pathname) and salt['file.readlink'](full_pathname) == home ~ '/.zprezto/runcoms/' ~ zfile %}
{{ full_pathname }}:
  file:
    - absent
  {%- endif -%}
{%- endfor %}
