{{ opts['cachedir'] }}/raven-requirements.txt:
 file:
   - absent

raven:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/raven
    - template: jinja
    - user: root
    - group: wheel
    - mode: 440
    - source: salt://raven/requirements.jinja2
  module:
    - wait
    - name: pip.install
    - requirements: {{ opts['cachedir'] }}/pip/raven
    - watch:
      - file: raven
