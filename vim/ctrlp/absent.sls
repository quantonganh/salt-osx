{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

vim_ctrlp:
  file:
    - absent
    - names:
      - {{ home }}/.vimrc.d/ctrlp.vim
      - {{ home }}/.vim/bundle/ctrlp.vim
