{%- from "macros.jinja2" import user with context %}

include:
  - vim.pathogen

vim_yankstack:
  git:
    - latest
    - name: https://github.com/maxbrunsfeld/vim-yankstack
    - target: {{ user.home }}/.vim/bundle/vim-yankstack
    - user: {{ user.owner }}
    - unless: test -d {{ user.home }}/.vim/bundle/vim-yankstack
  file:
    - accumulated
    - name: plugins
    - filename: {{ user.home }}/.vimrc
    - require_in:
      - git: vim_yankstack
      - file: vimrc
    - text: |
        " yankstack
        set macmeta
        " end of yankstack
