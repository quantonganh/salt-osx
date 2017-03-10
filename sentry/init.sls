{%- from "macros.jinja2" import user, home with context -%}
{%- set hostname = salt['pillar.get']('sentry:hostname', 'sentry.local') -%}

include:
  - nginx
  - postgresql
  - redis
  - supervisor
  - virtualenv

{%- set username = salt['pillar.get']('sentry:postgres:username', 'sentry') %}

sentry:
  virtualenv:
    - managed
    - name: /usr/local/sentry
    - user: {{ user }}
    - system_site_packages: False
    - require:
      - pip: virtualenv
  pip:
    - installed
    - bin_env: /usr/local/sentry
    - user: {{ user }}
    - require:
      - virtualenv: sentry
  file:
    - managed
    - name: {{ home }}/.sentry/sentry.conf.py
    - source: salt://sentry/config.jinja2
    - template: jinja
    - user: {{ user }}
    - group: staff
    - mode: 440
  postgres_user:
    - present
    - name: {{ username }}
    - password: {{ salt['pillar.get']('sentry:postgres:password') }}
    - user: {{ user }}
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('sentry:postgres:database', 'sentry') }}
    - owner: {{ username }}
    - user: {{ user }}
    - require:
      - postgres_user: sentry
      - service: postgresql
  cmd:
    - wait
    - stateful: False
    - user: {{ user }}
    - group: staff
    - name: /usr/local/sentry/bin/sentry upgrade --noinput
    - require:
      - postgres_database: sentry
    - watch:
      - pip: sentry
      - file: sentry
  host:
    - present
    - name: {{ hostname }}
    - ip: 127.0.0.1

sentry_admin_user:
  cmd:
    - wait
    - user: {{ user }}
    - name: /usr/local/sentry/bin/sentry createuser --email={{ salt['pillar.get']('sentry:admin:email') }} --password={{ salt['pillar.get']('sentry:admin:password') }} --superuser
    - require:
      - pip: sentry
      - file: sentry
      - cmd: sentry
    - watch:
      - postgres_database: sentry

/usr/local/share/supervisor/conf.d:
  file:
    - directory
    - makedirs: True
    - user: {{ user }}
    - group: admin
    - mode: 550

/usr/local/share/supervisor/conf.d/sentry.conf:
  file:
    - managed
    - source: salt://sentry/supervisor.jinja2
    - template: jinja
    - user: {{ user }}
    - group: admin
    - mode: 440
    - require:
      - file: /usr/local/share/supervisor/conf.d
      - cmd: sentry_admin_user
    - watch_in:
      - service: supervisor

/usr/local/etc/nginx/servers/sentry.conf:
  file:
    - managed
    - source: salt://nginx/template.jinja2
    - template: jinja
    - user: {{ user }}
    - group: admin
    - mode: 644
    - context:
        hostname: {{ hostname }}
        port: 9000
    - watch_in:
      - service: nginx
