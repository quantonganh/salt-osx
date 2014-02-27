{{ pillar['home'] }}/{{ pillar['user'] }}/.tmux.conf:
  file:
    - managed
    - user: quanta
    - group: staff
    - mode: 644
    - template: jinja
    - source: salt://tmux/tmux.jinja2
