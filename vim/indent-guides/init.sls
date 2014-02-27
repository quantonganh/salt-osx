include:
  - vim.pathogen

git://github.com/nathanaelkane/vim-indent-guides.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/vim-indent-guides
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/vim-indent-guides
