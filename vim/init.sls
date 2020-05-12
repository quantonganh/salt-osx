{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['config.get']('file_roots:base')[0] %}

vimrc:
  file:
    - managed
    - name: {{ home }}/.vimrc
    - user: {{ user }}
    - group: staff
    - mode: 644
    - source: salt://vim/rc
    - backup: minion

{{ home }}/.vimrc.d:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755

{%- for rcfile in salt['file.find'](file_roots + '/vim/rc.d', name='*.vim', type='f', print='name') %}
{{ home }}/.vimrc.d/{{ rcfile }}:
  file:
    - managed
    - user: {{ user }}
    - group: staff
    - mode: 644
    - source: salt://vim/rc.d/{{ rcfile }}
    - require:
      - file: {{ home }}/.vimrc.d
{%- endfor %}
