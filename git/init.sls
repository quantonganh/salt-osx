git:
  group:
    - present
  user:
    - present
    - groups: 
      - git
    - shell: /bin/sh
    - home: /Users/git
    - createhome: False
    - requite:
      - group: git

/Users/git:
  file:
    - directory
    - user: git
    - group: git
    - mode: 700
    - require:
      - user: git
      - group: git
