{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "macros.jinja2" import user, home with context %}

include:
  - vim

vim-plug:
  cmd:
    - run
    - name: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    - user: {{ user }}
    - unless: test -f {{ home }}/.vim/autoload/plug.vim
    - watch_in:
      - file: vimrc
