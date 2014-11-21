{%- set user = salt['cmd.run']('stat -f ''%Su'' /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - docker

boot2docker_init:
  cmd:
    - run
    - name: boot2docker init
    - user: {{ user }}
    - unless: test -f {{ home }}/.boot2docker/boot2docker.iso
    - require:
      - cmd: docker_install

boot2docker_stop:
  cmd:
    - run
    - name: boot2docker stop
    - user: {{ user }}
    - require:
      - cmd: boot2docker_init

disable_serial_port:
  cmd:
    - run
    - name: VBoxManage modifyvm boot2docker-vm --uart1 off
    - user: {{ user }}
    - require:
      - cmd: boot2docker_stop

boot2docker_start:
  cmd:
    - run
    - name: boot2docker start
    - user: {{ user }}
    - require:
      - cmd: disable_serial_port

{{ home }}/.bash_profile:
  file:
    - append
    - text: |
        export DOCKER_HOST=tcp://192.168.59.103:2376
        export DOCKER_CERT_PATH={{ home }}/.boot2docker/certs/boot2docker-vm
        export DOCKER_TLS_VERIFY=1
    - require:
      - cmd: boot2docker_start
