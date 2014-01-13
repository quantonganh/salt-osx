include:
  - vim.pathogen

https://github.com/saltstack/salt-vim.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/salt-vim
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/salt-vim

salt-vimrc:
  cmd:
    - run
    - name: echo '\nset nocompatible\nfiletype plugin indent on' >> {{ pillar['home'] }}/{{ pillar['user'] }}/.vimrc
    - user: {{ pillar['user'] }}
    - unless: egrep 'set nocompatible|filetype plugin indent on' {{ pillar['home'] }}/{{ pillar['user'] }}/.vimrc
    - require:
      - git: https://github.com/saltstack/salt-vim.git
