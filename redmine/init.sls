redmine_hostname:
  module:
    - run
    - name: hosts.add_host
    - ip: {{ pillar['redmine']['address'] }}
    - alias: {{ pillar['redmine']['hostname'] }}
