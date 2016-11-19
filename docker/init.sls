{%- from "macros.jinja2" import user, home with context %}

include:
  - brew
  - xhyve

docker:
  pkg:
    - installed
    - pkgs:
      - docker
      - docker-compose
      - docker-machine
    - require:
      - cmd: brew{% if salt['pillar.get']('brew:update', False) %}_update{% endif %}

docker-xhyve:
  file:
    - managed
    - name: /usr/local/bin/docker-machine-driver-xhyve
    - source: https://github.com/zchee/docker-machine-driver-xhyve/releases/download/v0.2.1/docker-machine-driver-xhyve
    - source_hash: md5=e8d2e23d76e29e13dd050c912916f0af
    - user: root
    - group: wheel
    - mode: 4755
    - require:
      - pkg: xhyve

com.apple.NetworkSharing:
  service:
    - running

{%- set machine_name = salt['pillar.get']('docker:machine_name', 'boot2docker') %}
docker-machine:
  cmd:
    - run
    - name: docker-machine create {{ machine_name }} --driver xhyve --xhyve-experimental-nfs-share
    - user: {{ user }}
    - unless: docker-machine status {{ machine_name }}
    - require:
      - pkg: docker
      - file: docker-xhyve
      - service: com.apple.NetworkSharing

{{ home }}/.zprofile:
  file:
    - append
    - text: |
        export DOCKER_HOST=tcp://192.168.64.2:2376
        export DOCKER_CERT_PATH={{ home }}/.docker/machine/certs
        export DOCKER_TLS_VERIFY=1
    - require:
      - cmd: docker-machine
