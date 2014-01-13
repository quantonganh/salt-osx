include:
  - vim.requirements

https://github.com/gmarik/vundle.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/vundle
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/vundle
    - require:
      - file: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle

vundle-vimrc:
  cmd:
    - run
    - name: echo "\nfiletype off\n\nset rtp+=~/.vim/bundle/vundle/\ncall vundle#rc()\n\nBundle 'gmarik/vundle'" >> {{ pillar['home'] }}/{{ pillar['user'] }}/.vimrc
    - user: {{ pillar['user'] }}
    - unless: egrep 'filetype off|vundle' {{ pillar['home'] }}/{{ pillar['user'] }}/.vimrc
    - require: 
      - git: https://github.com/gmarik/vundle.git
