salt_hostname:
  module:
    - run
    - name: hosts.add_host
    - ip: {{ pillar['salt']['address'] }}
    - alias: {{ pillar['salt']['hostname'] }}

salt-minion:
  file:
    - managed
    - name: /etc/salt/minion
    - template: jinja
    - source: salt://salt/minion/config.jinja2
    - user: root
    - group: wheel
    - mode: 644
    - require:
      - module: salt_hostname
  module:
    - run
    - name: service.restart
    - job_label: com.saltstack.minion
    - watch:
      - file: salt-minion
