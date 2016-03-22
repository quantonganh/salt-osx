{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

git://github.com/tpope/vim-surround.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/vim-surround
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/vim-surround
