{%- set user = salt['cmd.run']('stat -f %Su /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

rightzoom_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: wget 'http://www.blazingtools.com/mac/RightZoom.zip'
    - user: {{ user }}
    - unless: test -f ~/Downloads/RightZoom.zip

rightzoom_extract:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: unzip RightZoom.zip
    - user: {{ user }}
    - unless: test -d ~/Downloads/RightZoom.app
    - require:
      - cmd: rightzoom_download

rightzoom_install:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: mv RightZoom.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/RightZoom.app
    - require:
      - cmd: rightzoom_extract
