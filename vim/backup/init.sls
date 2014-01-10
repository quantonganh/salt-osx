{{ pillar['home'] }}/{{ pillar['user'] }}/.vim/backup:
  file:
    - directory
    - user: quanta
    - group: staff
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode
