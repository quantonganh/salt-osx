include:
  - apache

{% from "apache/map.jinja" import apache with context %}

redmine_hostname:
  module:
    - run
    - name: hosts.add_host
    - ip: {{ pillar['redmine']['address'] }}
    - alias: {{ pillar['redmine']['hostname'] }}

{{ apache.conf }}/redmine.conf:
  file:
    - managed
    - user: root
    - group: wheel
    - mode: 644
    - template: jinja
    - source: salt://redmine/apache.jinja2
    - require:
      - module: redmine_hostname
    - watch_in:
      - module: apache


