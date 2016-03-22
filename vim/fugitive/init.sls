{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

git://github.com/tpope/vim-fugitive.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/vim-fugitive
    - user: {{ user }}
    - unless: test -d {{ home }}/{{ user }}/.vim/bundle/vim-fugitive
