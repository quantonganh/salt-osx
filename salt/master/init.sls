salt-master:
  file:
    - managed
    - name: /etc/salt/master
    - template: jinja
    - source: salt://salt/master/config.jinja2
    - user: root
    - group: wheel
    - mode: 644
