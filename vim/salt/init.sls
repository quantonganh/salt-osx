{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

https://github.com/saltstack/salt-vim.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/salt-vim
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/salt-vim

salt-vimrc:
  cmd:
    - run
    - name: echo '\nset nocompatible\nfiletype plugin indent on' >> {{ home }}/.vimrc
    - user: {{ user }}
    - unless: egrep 'set nocompatible|filetype plugin indent on' {{ home }}/.vimrc
    - require:
      - git: https://github.com/saltstack/salt-vim.git
