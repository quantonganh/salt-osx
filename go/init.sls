include:
  - brew

{%- set user = salt['cmd.run']('stat -f ''%Su'' /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

go:
  pkg:
    - installed
    - require:
      - cmd: brew
  environ:
    - setenv
    - name: GOPATH
    - value: {{ home }}/go
    - require:
      - file: {{ home }}/go
  file:
    - managed
    - name: {{ home }}/go/src/github.com/{{ user }}/hello/hello.go
    - source: salt://go/hello.go
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - pkg: go
      - file: {{ home }}/go/src/github.com/{{ user }}/hello
  cmd:
    - wait
    - name: go install github.com/{{ user }}/hello
    - user: {{ user }}
    - require:
      - environ: go
    - watch:
      - file: go
  module:
    - wait
    - name: cmd.run
    - cmd: {{ home }}/go/bin/hello
    - watch:
      - cmd: go

{{ home }}/go:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755

{{ home }}/go/src/github.com/{{ user }}:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755
    - makedirs: True
    - require:
      - file: {{ home }}/go

{{ home }}/go/src/github.com/{{ user }}/hello:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755
    - makedirs: True
    - require:
      - file: {{ home }}/go/src/github.com/{{ user }}
