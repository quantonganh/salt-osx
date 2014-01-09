include:
  - apache

shinken_hostname:
  module:
    - run
    - name: hosts.add_host
    - ip: {{ pillar['shinken']['address'] }}
    - alias: {{ pillar['shinken']['hostname'] }}

/etc/apache2/other/shinken.conf:
  file:
    - managed
    - template: jinja
    - source: salt://shinken/apache.jinja2
    - user: root
    - group: wheel
    - mode: 644
    - require:
      - module: shinken_hostname
    - watch_in:
      - module: apache
