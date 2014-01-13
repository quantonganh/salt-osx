{{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle:
  file:
    - directory
    - user: {{ pillar['user'] }}
    - group: staff
    - mode: 755
