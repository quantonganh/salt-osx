include:
  - brew

redis:
  pkg:
    - installed
    - require:
      - cmd: brew
  file:
    - managed
    - name: /Library/LaunchAgents/homebrew.mxcl.redis.plist
    - source: salt://redis/plist.jinja2
    - template: jinja
    - user: root
    - group: wheel
    - mode: 440
    - require:
      - pkg: redis
  service:
    - running
    - name: homebrew.mxcl.redis
    - watch:
      - file: redis
