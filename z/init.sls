{%- from "macros.jinja2" import user, home with context %}

include:
  - brew
  - zsh

z:
  pkg:
    - installed
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/z.zsh
    - user: {{ user }}
    - group: staff
    - mode: 644
    - contents: |
        . `brew --prefix`/etc/profile.d/z.sh
    - require:
      - pkg: z
      - file: {{ home }}/.zshrc.d
