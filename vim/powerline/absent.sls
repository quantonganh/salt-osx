{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['pillar.get']('master:file_roots:base')[0] %}

{{ home }}/.vim/bundle/powerline:
  file:
    - absent

vim_powerline_config:
  file:
    - blockreplace
    - name: {{ home }}/.vimrc
    - marker_start: '" powerline'
    - marker_end: '" end of powerline'
    - content: ''
    - backup: '.powerline'
