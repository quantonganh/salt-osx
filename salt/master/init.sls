salt-master:
  file:
    - managed
    - name: /etc/salt/master
    - template: jinja
    - source: salt://salt/master/config.jinja2
    - user: root
    - group: wheel
    - mode: 644
  module:
    - run
    - name: service.restart
    - job_label: com.saltstack.master
    - watch:
      - file: salt-master

sysctl-maxfiles:
  module:
    - run
    - name: sysctl.persist
    - m_name: kern.maxfiles
    - value: 16384
    - config: /etc/sysctl.conf
