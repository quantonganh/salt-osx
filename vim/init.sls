{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['pillar.get']('master:file_roots:base')[0] %}

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
  cmd:
    - wait
    - name: cp {{ home }}/.vimrc {{ file_roots }}/vim/rc.jinja2
    - user: {{ user }}
    - watch:
      - file: vimrc
