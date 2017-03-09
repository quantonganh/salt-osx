{%- from 'macros.jinja2' import home %}

zim:
  file:
    - absent
    - names:
      - {{ home }}/.zim
      - {{ home }}/.zimrc
