{{ pillar['home']}}/salt.ulimit1:
  file:
    - managed
    - user: quanta
    - group: staff
    - mode: 644
    - template: jinja
    - source: salt://test/ulimit.jinja2

{{ pillar['home']}}/salt.ulimit2:
  file:
    - managed
    - user: quanta
    - group: staff
    - mode: 644
    - template: jinja
    - source: salt://test/ulimit.jinja2
