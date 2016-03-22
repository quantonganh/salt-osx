{%- from "macros.jinja2" import user, home with context %}

include:
  - vim

{{ home }}/.vim/autoload:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755

pathogen.vim:
  cmd:
    - run
    - name: curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
    - user: {{ user }}
    - unless: test -f {{ home }}/.vim/autoload/pathogen.vim
    - require:
      - file: {{ home }}/.vim/autoload

pathogen-vimrc:
  cmd:
    - run
    - name: echo 'execute pathogen#infect()' >> {{ home }}/.vimrc
    - user: {{ user }}
    - unless: grep pathogen {{ home }}/.vimrc
    - require:
      - cmd: pathogen.vim
