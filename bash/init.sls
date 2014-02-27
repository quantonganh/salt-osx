{{ pillar['home'] }}/{{ pillar['user'] }}/.bashrc:
  file:
    - managed
    - template: jinja
    - source: salt://bash/rc.jinja2
    - user: {{ pillar['user'] }}
    - group: staff
    - mode: 644

{{ pillar['home'] }}/{{ pillar['user'] }}/.bash_profile:
  file:
    - managed
    - template: jinja
    - source: salt://bash/profile.jinja2
    - user: {{ pillar['user'] }}
    - group: staff
    - mode: 644
