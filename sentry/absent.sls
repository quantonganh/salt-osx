{%- from "macros.jinja2" import user, home with context %}

/etc/apache2/other/sentry.conf:
  file:
    - absent

/usr/local/share/supervisor/conf.d/sentry.conf:
  file:
    - absent
    - require:
      - file: /etc/apache2/other/sentry.conf

{{ home }}/.sentry/sentry.conf.py:
  file:
    - absent
    - require:
      - file: /etc/apache2/other/sentry.conf

/usr/local/sentry:
  file:
    - absent
    - require:
      - file: /etc/apache2/other/sentry.conf

sentry:
  postgres_database:
    - absent
    - name: {{ salt['pillar.get']('sentry:db:name', 'sentry') }}
    - user: {{ user }}
  postgres_user:
    - absent
    - name: {{ salt['pillar.get']('sentry:db:username', 'sentry') }}
    - user: {{ user }}
    - require:
      - postgres_database: sentry
