{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - vim.pathogen
  - vim.auto-pairs.absent

vim_delimitMate:
  git:
    - latest
    - name: https://github.com/Raimondi/delimitMate.git
    - target: {{ home }}/.vim/bundle/delimitMate
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/delimitMate
