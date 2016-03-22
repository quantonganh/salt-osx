{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

vimrc:
  file:
    - managed
    - name: {{ home }}/.vimrc
    - user: {{ user }}
    - group: staff
    - mode: 644
    - template: jinja
    - source: salt://vim/rc.jinja2
    - backup: minion

{{ home }}/.vimrc.d:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755
