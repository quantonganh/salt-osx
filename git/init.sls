git:
  group:
    - present
  user:
    - present
    - groups: 
      - git
    - shell: /bin/sh
    - home: {{ pillar['home'] }}/git
    - createhome: False
    - requite:
      - group: git

{{ pillar['home'] }}/git:
  file:
    - directory
    - user: git
    - group: git
    - mode: 700
    - require:
      - user: git
      - group: git

{{ pillar['home'] }}/{{ pillar['user'] }}/.gitconfig:
  file:
    - managed
    - template: jinja
    - source: salt://git/config.jinja2
    - user: {{ pillar['user'] }}
    - group: staff
    - mode: 644
