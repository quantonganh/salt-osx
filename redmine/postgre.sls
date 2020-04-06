{%- from "macros.jinja2" import user, home, downloads with context %}
{%- set username = salt['pillar.get']('redmine:psql:username', 'redmine') -%}

redmine_postgres:
  postgres_user:
    - present
    - name: {{ username }}
    - password: {{ salt['pillar.get']('redmine:psql:password') }}
    - user: {{ user }}
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('redmine:psql:name', 'redmine') }}
    - owner: {{ username }}
    - user: {{ user }}
    - require:
      - postgres_user: redmine
