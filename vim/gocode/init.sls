{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - vim.pathogen
  - vim.go

vim_gocode:
  git:
    - latest
    - name: https://github.com/Blackrush/vim-gocode.git
    - target: {{ home }}/.vim/bundle/vim-gocode
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/vim-gocode
    - require:
      - file: vim_go
