{{ pillar['home'] }}/.vimrc:
  file:
    - managed
    - user: quanta
    - group: staff
    - mode: 644
    - template: jinja
    - source: salt://vim/vimrc.jinja2
    - backup: minion
