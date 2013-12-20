{% from "apache/map.jinja" import apache with context %}

{#-% set apache = salt['grains.filter_by']({
    'MacOS': {
        'conf': '/etc/apache2/other',
    },
    'Debian': {
        'conf': '/etc/apache2/conf.d',
    },
    'RedHat': {
        'conf': '/etc/httpd/conf.d',
    },
}) %-#}

{{ apache.conf }}/redmine.conf:
  file:
    - managed
    - user: root
    - group: wheel
    - mode: 644
    - template: jinja
    - source: salt://apache/redmine.conf.jinja2
