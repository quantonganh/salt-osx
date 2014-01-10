{{ pillar['home'] }}/{{ pillar['user'] }}/vm:
  file:
    - directory
    - user: {{ pillar['user'] }}
    - group: staff
    - mode: 755
    - makedirs: True
    - recurse:
      - user

boot2docker-download:
  cmd:
    - run
    - name: 'curl https://raw.github.com/steeve/boot2docker/master/boot2docker > boot2docker'
    - cwd: {{ pillar['home'] }}/{{ pillar['user'] }}/vm
    - unless: test -f {{ pillar['home'] }}/{{ pillar['user'] }}/vm/boot2docker
    - require:
      - file: {{ pillar['home'] }}/{{ pillar['user'] }}/vm

{{ pillar['home'] }}/{{ pillar['user'] }}/vm/boot2docker:
  file:
    - managed
    - user: {{ pillar['user'] }}
    - group: staff
    - mode: 755
    - require:
      - file: {{ pillar['home'] }}/{{ pillar['user'] }}/vm
      - cmd: boot2docker-download

boot2docker-init:
  cmd:
    - run
    - name: './boot2docker init'
    - cwd: {{ pillar['home'] }}/{{ pillar['user'] }}/vm
    - user: {{ pillar['user'] }}
    - require:
      - file: {{ pillar['home'] }}/{{ pillar['user'] }}/vm/boot2docker

boot2docker-up:
  cmd:
    - run
    - name: './boot2docker up'
    - cwd: {{ pillar['home'] }}/{{ pillar['user'] }}/vm
    - user: {{ pillar['user'] }}
    - require:
      - file: {{ pillar['home'] }}/{{ pillar['user'] }}/vm/boot2docker
      - cmd: boot2docker-init
