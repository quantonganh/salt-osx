{%- set home = salt['user.info'](user)['home'] %}
{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}

{{ home }}/.tmux.conf:
  file:
    - managed
    - user: {{ user }}
    - group: staff
    - mode: 644
    - template: jinja
    - source: salt://tmux/config.jinja2
