/etc/uwsgi:
  file:
    - directory
    - user: root
    - group: wheel
    - mode: 755
    - makedirs: True

/etc/uwsgi/carbon.ini:
  file:
    - managed
    - user: root
    - group: wheel
    - mode: 644
    - template: jinja
    - source: salt://uwsgi/template.jinja2
    - require:
      - file: /etc/uwsgi
