{%- from 'macros.jinja2' import user, home %}

include:
  - brew

tig:
  pkg:
    - installed
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/tig.zsh
    - contents: |
        alias t="tig"
        alias tl="tig log"
        alias tb="tig blame"
        alias tg="tig grep"
        alias ts="tig status"
        alias tsh="tig stash"
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - pkg: tig
      - file: {{ home }}/.zshrc.d
