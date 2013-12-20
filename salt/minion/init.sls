/etc/salt/minion:
  file:
    - managed
    - template: jinja
    - source: salt://salt/minion/config.jinja2
    - user: root
    - group: wheel
    - mode: 644
