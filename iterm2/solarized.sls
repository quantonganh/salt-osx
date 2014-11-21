{%- set home = salt['user.info'](user)['home'] %}
{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}

solarized_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: wget 'http://ethanschoonover.com/solarized/files/solarized.zip'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/solarized.zip

solarized_extract:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: unzip solarized.zip
    - user: {{ user }}
    - unless: test -d {{ home }}/Downloads/solarized/
