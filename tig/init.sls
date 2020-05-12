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

tigrc:
  file:
    - managed
    - name: {{ home }}/.tigrc
    - contents: |
        bind generic X !git cherry-pick -x %(commit)
        bind generic C !git cherry-pick %(commit)
        bind main B !git rebase -i %(commit)^
        bind main ! !git revert %(commit)
        bind generic E !git format-patch -1 %(commit)
        bind generic 0 !git checkout %(commit)
        bind generic 9 !git checkout %(commit)~
        bind generic A !git commit --amend -s
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - pkg: tig
