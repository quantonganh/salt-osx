{%- from "macros.jinja2" import user, home with context %}

include:
  - prezto

zsh:
  file:
    - managed
    - name: {{ home }}/.zprezto/runcoms/zshrc
    - source: salt://zsh/config
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - git: prezto

{{ home }}/.zshrc.d:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755

{{ home }}/.zshrc.d/math.zsh:
  file:
    - managed
    - source: salt://zsh/math.zsh
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - file: {{ home }}/.zshrc.d
