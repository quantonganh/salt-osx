{%- from 'macros.jinja2' import user, home %}

include:
  - brew
  - zsh

autojump:
  pkg:
    - installed
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/autojump.zsh
    - user: {{ user }}
    - group: staff
    - mode: 644
    - contents: |
        [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
    - require:
      - pkg: autojump
      - file: {{ home }}/.zshrc.d
