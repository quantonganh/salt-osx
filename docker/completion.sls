{%- set user = salt['cmd.run']('stat -f ''%Su'' /dev/console') %}

include:
  - bash.completion

/usr/local/etc/bash_completion.d/docker:
  file:
    - managed
    - source: https://raw.githubusercontent.com/docker/docker/master/contrib/completion/bash/docker
    - source_hash: md5=58e6ada24366ed032b600a9bdf6b08a7
    - user: {{ user }}
    - group: admin
    - mode: 400
