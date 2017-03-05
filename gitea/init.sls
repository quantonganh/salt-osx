{%- from "macros.jinja2" import user with context -%}
{%- set username = salt['pillar.get']('gitea:db:username', 'gitea') %}

include:
  - brew
  - nginx

gitea:
  pkg:
    - installed
    - taps:
      - go-gitea/gitea
    - require:
      - cmd: brew
  postgres_user:
    - present
    - name: {{ username }}
    - password: {{ salt['pillar.get']('gitea:db:password') }}
    - user: {{ user }}
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('gitea:db:name', 'gitea') }}
    - owner: {{ username }}
    - user: {{ user }}
    - require:
      - postgres_user: gitea
  service:
    - running
    - name: io.gitea.web
    - watch:
      - file: /Library/LaunchAgents/io.gitea.web.plist

/usr/local/etc/nginx/servers/gitea.conf:
  file:
    - managed
    - source: salt://gitea/nginx.jinja2
    - template: jinja
    - user: {{ user }}
    - group: admin
    - mode: 644
    - watch_in:
      - service: nginx

/Library/LaunchAgents/io.gitea.web.plist:
  file:
    - managed
    - source: salt://gitea/launchd.jinja2
    - template: jinja
    - user: root
    - group: wheel
    - mode: 644
    - context:
        username: {{ user }}
        groupname: {{ user }}
