{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

prezto:
  file:
    - absent
    - names:
      - {{ home }}/.zprezto
      - {{ home }}/.zpreztorc
  cmd:
    - run
    - name: chsh -s /bin/bash {{ user }}
    - require:
      - file: prezto
