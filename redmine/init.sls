{%- from "macros.jinja2" import user, home, downloads with context %}
{%- set version = '3.3.2' %}
{%- set username = salt['pillar.get']('redmine:postgres:username', 'redmine') %}

include:
  - brew
  - nginx
  - postgresql
  - ruby

redmine:
  pkg:
    - installed
    - name: imagemagick
    - require:
      - cmd: brew
  gem:
    - installed
    - user: {{ user }}
    - names:
      - bundler
      - pg
      - rails
    - require:
      - pkg: ruby
  archive:
    - extracted
    - name: /Library/WebServer/Documents/
    - source: http://www.redmine.org/releases/redmine-{{ version }}.tar.gz
    - source_hash: md5=8e403981dc3a19a42ee978f055be62ca
    - archive_format: tar
    - tar_options: z
    - if_missing: /Library/WebServer/Documents/redmine-{{ version }}
  postgres_user:
    - present
    - name: {{ username }}
    - password: {{ salt['pillar.get']('redmine:postgres:password') }}
    - user: {{ user }}
  postgres_database:
    - present
    - name: {{ salt['pillar.get']('redmine:postgres:database', 'redmine') }}
    - owner: {{ username }}
    - user: {{ user }}
    - require:
      - postgres_user: redmine
  host:
    - present
    - name: {{ salt['pillar.get']('redmine:hostname', 'redmine.local') }}
    - ip: 127.0.0.1
  file:
    - managed
    - name: /Library/WebServer/Documents/redmine-{{ version }}/config/database.yml
    - source: salt://redmine/database.jinja2
    - template: jinja
    - require:
      - archive: redmine
  cmd:
    - wait
    - cwd: /Library/WebServer/Documents/redmine-{{ version }}
    - user: {{ user }}
    - name: bundle install --without development test
    - require:
      - gem: redmine
    - watch:
      - archive: redmine

redmine_generate_token:
  cmd:
    - run
    - cwd: /Library/WebServer/Documents/redmine-{{ version }}
    - name: rake generate_secret_token
    - require:
      - gem: redmine
    - watch:
      - archive: redmine

/usr/local/etc/nginx/servers/redmine.conf:
  file:
    - managed
    - source: salt://redmine/nginx.jinja2
    - template: jinja
    - user: {{ user }}
    - group: admin
    - mode: 644
    - context:
        version: {{ version }}
    - require:
      - host: redmine
    - watch_in:
      - service: nginx

{%- set old_dirs = salt['file.find']('/Library/WebServer/Documents', name='redmine-*', type='d', print='name') -%}
{%- for dir in old_dirs if dir != "redmine-" ~ version %}
/Library/WebServer/Documents/{{ dir }}:
  file:
    - absent
    - require:
      - cmd: redmine
{%- endfor %}
