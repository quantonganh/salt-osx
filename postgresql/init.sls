include:
  - brew

postgresql:
  pkg:
    - installed
    - require:
      - cmd: brew
  file:
    - managed
    - name: /Library/LaunchAgents/homebrew.mxcl.postgresql.plist
    - source: salt://postgresql/plist.jinja2
    - template: jinja
    - user: root
    - group: wheel
    - mode: 440
    - require:
      - pkg: postgresql
  service:
    - running
    - name: homebrew.mxcl.postgresql
    - watch:
      - file: postgresql
