include:
  - vim

{{ pillar['home'] }}/{{ pillar['user'] }}/.vim/autoload:
  file:
    - directory
    - user: {{ pillar['user'] }}
    - group: staff
    - mode: 755

pathogen.vim:
  cmd:
    - run
    - name: curl -Sso ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
    - user: {{ pillar['user'] }}
    - unless: test -f {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/autoload/pathogen.vim
    - require:
      - file: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/autoload

pathogen-vimrc:
  cmd:
    - run
    - name: echo 'execute pathogen#infect()' >> {{ pillar['home'] }}/{{ pillar['user'] }}/.vimrc
    - user: {{ pillar['user'] }}
    - unless: grep pathogen {{ pillar['home'] }}/{{ pillar['user'] }}/.vimrc
    - require:
      - cmd: pathogen.vim
