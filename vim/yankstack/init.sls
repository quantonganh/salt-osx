{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

vim_yankstack:
  git:
    - latest
    - name: https://github.com/maxbrunsfeld/vim-yankstack
    - target: {{ home }}/.vim/bundle/vim-yankstack
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/vim-yankstack
  file:
    - accumulated
    - name: plugins
    - filename: {{ home }}/.vimrc
    - require_in:
      - git: vim_yankstack
      - file: vimrc
    - text: |
        " yankstack
        set macmeta
        " end of yankstack
