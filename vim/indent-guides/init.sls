{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

git://github.com/nathanaelkane/vim-indent-guides.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/vim-indent-guides
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/vim-indent-guides
