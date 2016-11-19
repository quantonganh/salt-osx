{%- from "macros.jinja2" import user, home with context %}

include:
  - brew
  - zsh

direnv:
  pkg:
    - installed
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/direnv.zsh
    - contents: |
        eval "$(direnv hook zsh)"
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - pkg: direnv
      - file: {{ home }}/.zshrc.d
