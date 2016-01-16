{%- from "macros.jinja2" import user, home, downloads with context %}

include:
  - python

supervisor:
  pip:
    - installed
    - require:
      - pkg: python
  file:
    - managed
    - name: /Library/LaunchDaemons/com.agendaless.supervisord.plist
    - source: salt://supervisor/plist.jinja2
    - user: root
    - group: wheel
    - mode: 440
    - require:
      - pip: supervisor
  service:
    - running
    - name: com.agendaless.supervisord
    - watch:
      - file: supervisor
      - file: /usr/local/etc/supervisord.conf

/usr/local/etc/supervisord.conf:
  file:
    - managed
    - source: salt://supervisor/config.jinja2
    - template: jinja
    - user: {{ user }}
    - group: admin
    - mode: 440
    - require:
      - pip: supervisor
