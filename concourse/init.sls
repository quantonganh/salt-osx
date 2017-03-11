{%- from 'macros.jinja2' import user with context %}
{%- set hostname = salt['pillar.get']('concourse:hostname', 'concourse.local') -%}
{%- set username = salt['pillar.get']('concourse:postgres:username', 'concourse') %}

include:
  - nginx

/opt/concourse:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755

concourse_hello:
  file:
    - managed
    - name: /opt/concourse/hello.yml
    - source: salt://concourse/hello.yml
    - template: jinja
    - context:
        platform: {{ grains['kernel']|lower }}
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - file: /opt/concourse
  cmd:
    - wait
    - cwd: /opt/concourse
    - name: echo 'y' | fly -t lite set-pipeline -p hello-world -c hello.yml
    - watch:
      - file: concourse_hello

concourse:
  postgres_user:
    - present
    - name: {{ username }}
    - password: {{ salt['pillar.get']('concourse:postgres:password') }}
    - user: {{ user }}
  postgres_database:
    - present
    - name: atc
    - owner: {{ username }}
    - user: {{ user }}
    - require:
      - postgres_user: concourse
  host:
    - present
    - name: {{ salt['pillar.get']('concourse:hostname', 'concourse.local') }}
    - ip: 127.0.0.1
  file:
    - managed
    - name: /usr/local/etc/nginx/servers/concourse.conf
    - source: salt://nginx/template.jinja2
    - template: jinja
    - user: {{ user }}
    - group: admin
    - mode: 644
    - context:
        hostname: {{ hostname }}
        port: 8080
    - watch_in:
      - service: nginx
