{%- from "macros.jinja2" import user as user %}

include:
  - brew

zsh-completions:
  pkg:
    - installed
    - require:
      - cmd: brew
  file:
    - append
    - name: {{ user.home }}/.zshrc
    - text: |
        fpath=(/usr/local/share/zsh-completions $fpath)
    - require:
      - pkg: zsh-completions

zcompdump:
  file:
    - absent
    - name: {{ user.home }}/.zcompdump
    - require:
      - file: zsh-completions
  cmd:
    - run
    - name: |
        autoload -Uz compinit
        compinit
    - require:
      - file: zcompdump
