{%- from 'macros.jinja2' import user, home %}

include:
  - brew
  - zsh

zsh-syntax-highlighting:
  pkg:
    - installed
    - version: latest
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/syntax-highlighting.zsh
    - contents: |
        ZSH_HIGHLIGHT_STYLES[path]=none
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - pkg: zsh-syntax-highlighting
      - file: {{ home }}/.zshrc.d
