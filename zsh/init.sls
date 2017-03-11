{%- from "macros.jinja2" import user, home with context %}

{{ home }}/.zshrc.d:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755

{{ home }}/.zshrc:
  file:
    - managed
    - source: salt://zsh/rc
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - file: {{ home }}/.zshrc.d

{{ home }}/.zshrc.d/math.zsh:
  file:
    - managed
    - source: salt://zsh/math.zsh
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - file: {{ home }}/.zshrc.d
