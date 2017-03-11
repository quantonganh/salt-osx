{%- from 'macros.jinja2' import home %}

tig:
  pkg:
    - removed
  file:
    - absent
    - name: {{ home }}/.zshrc.d/tig.zsh
    - require:
      - pkg: tig
