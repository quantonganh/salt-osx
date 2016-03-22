{%- from "macros.jinja2" import user, home with context %}

include:
  - brew

zsh-completions:
  pkg:
    - installed
    - require:
      - cmd: brew
  file:
    - append
    - name: {{ home }}/.zshrc
    - text: |
        fpath=(/usr/local/share/zsh-completions $fpath)
    - require:
      - pkg: zsh-completions

zcompdump:
  file:
    - absent
    - name: {{ home }}/.zcompdump
    - require:
      - file: zsh-completions
  cmd:
    - run
    - name: |
        autoload -Uz compinit
        compinit
    - require:
      - file: zcompdump
