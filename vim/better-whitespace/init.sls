{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - vim.pathogen

https://github.com/ntpeters/vim-better-whitespace.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/better-whitespace
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/better-whitespace
