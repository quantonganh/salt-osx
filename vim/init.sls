{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

{{ home }}/.vimrc:
  file:
    - managed
    - user: {{ user }}
    - group: staff
    - mode: 644
    - template: jinja
    - source: salt://vim/vimrc.jinja2
    - backup: minion
