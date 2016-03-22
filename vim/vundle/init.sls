{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.requirements

https://github.com/gmarik/vundle.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/vundle
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/vundle
    - require:
      - file: {{ home }}/.vim/bundle

vundle-vimrc:
  cmd:
    - run
    - name: echo "\nfiletype off\n\nset rtp+=~/.vim/bundle/vundle/\ncall vundle#rc()\n\nBundle 'gmarik/vundle'" >> {{ home }}/.vimrc
    - user: {{ user }}
    - unless: egrep 'filetype off|vundle' {{ home }}/.vimrc
    - require:
      - git: https://github.com/gmarik/vundle.git
