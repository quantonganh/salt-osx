include:
  - vim.pathogen

https://github.com/davidhalter/jedi-vim.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/jedi-vim
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/jedi-vim

jedi-submodule:
  module:
    - run
    - cwd: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/jedi-vim
    - name: git.submodule
    - user: {{ pillar['user'] }}
    - require:
      - git: https://github.com/davidhalter/jedi-vim.git
