{%- from "macros.jinja2" import user with context -%}

include:
  - brew
  - java
  - nginx

jenkins:
  pkg:
    - installed
    - require:
      - cmd: brew
  cmd:
    - wait
    - name: ln -sfv /usr/local/opt/jenkins/*.plist ~/Library/LaunchAgents
    - watch:
      - pkg: jenkins
  service:
    - running
    - watch:
      - cmd: jenkins
  host:
    - present
    - name: {{ salt['pillar.get']('jenkins:hostname', 'jenkins.local') }}
    - ip: 127.0.0.1
  file:
    - managed
    - name: /usr/local/etc/nginx/servers/jenkins.conf
    - source: salt://jenkins/nginx.jinja2
    - template: jinja
    - user: {{ user }}
    - group: admin
    - mode: 644
    - require:
      - host: jenkins
    - watch_in:
      - service: nginx
