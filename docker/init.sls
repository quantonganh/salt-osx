{%- set version = '1.7.1' %}
{%- set user = salt['cmd.run']('stat -f ''%Su'' /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - brew

boot2docker:
  cmd:
    - run
    - name: brew install boot2docker
    - unless: brew list | grep boot2docker
    - user: {{ user }}
    - require:
      - cmd: brew
{%- if version not in salt['cmd.run']('boot2docker version') %}
      - file boot2docker_absent_old_version

boot2docker_stop:
  cmd:
    - run
    - name: boot2docker stop
    - user: {{ user }}
    - require:
      - cmd: boot2docker

boot2docker_absent_old_version:
  cmd:
    - run
    - name: brew unlink boot2docker
    - user: {{ user }}
    - require:
      - cmd: boot2docker_stop
  file:
    - absent
    - names:
      - /usr/local/bin/boot2docker
      - {{ home }}/VirtualBox\ VMs/boot2docker-vm
      - {{ home }}/.boot2docker
      - {{ home }}/.ssh/id_boot2docker
      - {{ home }}/.ssh/id_boot2docker.pub
    - require:
      - cmd: boot2docker_absent_old_version

boot2docker_link:
  cmd:
    - run
    - name: brew link boot2docker
    - user: {{ user }}
    - unless: test -L /usr/local/bin/boot2docker
    - require:
      - file: boot2docker_absent_old_version

boot2docker_download:
  cmd:
    - run
    - name: boot2docker download
    - user: {{ user }}
    - require:
      - cmd: boot2docker_link
{%- endif %}

boot2docker_init:
  cmd:
    - wait
    - name: boot2docker -v init
    - user: {{ user }}
    - watch:
{%- if version not in salt['cmd.run']('boot2docker version') %}
      - cmd: boot2docker_download
{%- else %}
      - cmd: boot2docker
{%- endif %}

boot2docker_start:
  cmd:
    - run
    - name: boot2docker start
    - user: {{ user }}
    - unless: boot2docker status != 'running'
    - require:
      - cmd: boot2docker_init
  file:
    - symlink
    - name: {{ home }}/Library/LaunchAgents/homebrew.mxcl.boot2docker.plist
    - target: /usr/local/opt/boot2docker/homebrew.mxcl.boot2docker.plist
    - user: {{ user }}
    - require:
      - cmd: boot2docker_start

{{ home }}/.zprofile:
  file:
    - append
    - text: |
        export DOCKER_HOST=tcp://192.168.59.103:2376
        export DOCKER_CERT_PATH={{ home }}/.boot2docker/certs/boot2docker-vm
        export DOCKER_TLS_VERIFY=1
    - require:
      - cmd: boot2docker_start
