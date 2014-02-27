/Users/quanta/test:
  file:
    - managed
    - template: jinja
    - source: salt://test/test.jinja2
    - user: quanta
    - group: staff
    - mode: 644
