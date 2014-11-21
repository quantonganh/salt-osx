include:
  - wget.ssl

{%- set version = '1.3.0' %}
{%- set user = salt['cmd.run']('stat -f ''%Su'' /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set download = home ~ '/Downloads' %}

docker_download:
  cmd:
    - run
    - cwd: {{ download }}
    - name: 'wget https://github.com/boot2docker/osx-installer/releases/download/v{{ version }}/Boot2Docker-{{ version }}.pkg'
    - user: {{ user }}
    - unless: test -f {{ download }}/Boot2Docker-{{ version }}.pkg
{#-
    - require:
      - file: {{ home }}/.wgetrc
      #}

docker_install:
  cmd:
    - run
    - cwd: {{ download }}
    - name: sudo installer -verbose -pkg Boot2Docker-{{ version }}.pkg -target /
    - user: {{ user }}
    - unless: test -d /Applications/boot2docker.app
    - require:
      - cmd: docker_download

{#-
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
    #}
