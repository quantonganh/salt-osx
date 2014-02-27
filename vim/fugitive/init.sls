include:
  - vim.pathogen

git://github.com/tpope/vim-fugitive.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/vim-fugitive
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/vim-fugitive
