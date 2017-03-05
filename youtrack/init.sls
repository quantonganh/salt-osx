{%- from "macros.jinja2" import user with context -%}
{%- set version = '2017.1.30973' -%}
{%- set jarfile = 'youtrack-' ~ version ~ '.jar' -%}

include:
  - nginx

/usr/local/youtrack:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 750

/usr/local/youtrack/{{ jarfile }}:
  file:
    - managed
    - source: https://download.jetbrains.com/charisma/{{ jarfile }}
    - source_hash: sha256=44ad587ecca96ed37ed14f4a2fe9512a27b72e7eecbd96c75639cedffd5cf62d
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - file: /usr/local/youtrack

youtrack:
  file:
    - managed
    - name: /Library/LaunchDaemons/com.jetbrains.youtrack.plist
    - source: salt://youtrack/launchd.jinja2
    - template: jinja
    - user: root
    - group: wheel
    - mode: 644
    - context:
        jarfile: {{ jarfile }}
  service:
    - running
    - name: com.jetbrains.youtrack
    - watch:
      - file: youtrack
  host:
    - present
    - name: {{ salt['pillar.get']('youtrack:hostname', 'youtrack.local') }}
    - ip: 127.0.0.1

/usr/local/etc/nginx/servers/youtrack.conf:
  file:
    - managed
    - source: salt://youtrack/nginx.jinja2
    - template: jinja
    - user: {{ user }}
    - group: admin
    - mode: 644
    - watch_in:
      - service: nginx
