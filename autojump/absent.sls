{%- from "macros.jinja2" import home with context %}

autojump:
  pkg:
    - removed
  file:
    - absent
    - name: {{ home }}/.zshrc.d/autojump.zsh
    - require:
      - pkg: autojump
