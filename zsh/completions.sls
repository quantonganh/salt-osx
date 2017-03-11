{%- from "macros.jinja2" import user, home with context %}

include:
  - brew
  - zsh

zsh-completions:
  pkg:
    - latest
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/completions.zsh
    - contents: |
        fpath=(/usr/local/share/zsh-completions $fpath)
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - pkg: zsh-completions
      - file: {{ home }}/.zshrc.d

zcompdump:
  file:
    - absent
    - name: {{ home }}/.zcompdump
    - require:
      - file: zsh-completions
  cmd:
    - run
    - user: {{ user }}
    - shell: /bin/zsh
    - name: |
        autoload -Uz compinit
        compinit
    - require:
      - file: zcompdump
