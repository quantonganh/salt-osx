{%- from "macros.jinja2" import user, home with context %}

include:
  - zsh

zplug:
  git:
    - latest
    - name: https://github.com/b4b4r07/zplug
    - target: {{ home }}/.zplug
    - user: {{ user }}
    - unless: test -d {{ home }}/.zplug
  file:
    - managed
    - name: {{ home }}/.zshrc.d/zplug.zsh
    - source: salt://zplug/config.jinja2
    - template: jinja
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - git: zplug
      - file: {{ home }}/.zshrc.d
