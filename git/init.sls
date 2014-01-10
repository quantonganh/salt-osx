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
