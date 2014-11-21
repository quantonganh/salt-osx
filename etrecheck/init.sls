{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

etrecheck_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: wget 'http://www.etresoft.com/download/EtreCheck.zip'
    - user: {{ user }}
    - unless: test -f ~/Downloads/EtreCheck.zip

etrecheck_extract:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: unzip EtreCheck.zip
    - user: {{ user }}
    - unless: test -d ~/Downloads/EtreCheck.app
    - require:
      - cmd: etrecheck_download

etrecheck_install:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: mv EtreCheck.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/EtreCheck.app
    - require:
      - cmd: etrecheck_extract
