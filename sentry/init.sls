{%- from "macros.jinja2" import user, home with context %}

include:
  - apache
  - postgresql
  - redis
  - supervisor
  - virtualenv

{%- set username = salt['pillar.get']('sentry:db:username', 'sentry') %}

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
    - password: {{ salt['pillar.get']('sentry:db:password') }}
    - user: {{ user }}
    - require:
      - service: postgresql
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('sentry:db:name', 'sentry') }}
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

/etc/apache2/other/sentry.conf:
  file:
    - managed
    - source: salt://sentry/apache.jinja2
    - template: jinja
    - user: root
    - group: wheel
    - mode: 644
    - watch_in:
      - service: apache
