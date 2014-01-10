{% set version = '0.7.5' %}

docker_download:
  cmd:
    - run
    - name: 'curl http://get.docker.io/builds/Darwin/x86_64/docker-{{ version }}.tgz | tar xvz'
    - cwd: /
    - unless: test -f /usr/local/bin/docker

docker_host_export:
  cmd:
    - run
    - name: export DOCKER_HOST=localhost
    - user: {{ pillar['user'] }}
    - unless: env | grep DOCKER_HOST=localhost

docker_host_bash_profile:
  cmd:
    - run
    - name: 'echo "export DOCKER_HOST=localhost" >> {{ pillar['home'] }}/{{ pillar['user'] }}/.bash_profile'
    - user: {{ pillar['user'] }}
    - unless: grep DOCKER_HOST=localhost {{ pillar['home'] }}/{{ pillar['user'] }}/.bash_profile
