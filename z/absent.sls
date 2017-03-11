{%- from "macros.jinja2" import home with context %}

z:
  pkg:
    - removed
  file:
    - absent
    - name: {{ home }}/.zshrc.d/z.zsh
    - require:
      - pkg: z
