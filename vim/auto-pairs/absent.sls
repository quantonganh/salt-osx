{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

{{ home }}/.vim/bundle/auto-pairs:
  file:
    - absent
