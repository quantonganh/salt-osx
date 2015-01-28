{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set downloads = home + '/Downloads' %}
{%- set version = '0.3.5-1' %}

chefdk_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'https://opscode-omnibus-packages.s3.amazonaws.com/mac_os_x/10.8/x86_64/chefdk-{{ version }}.dmg'
    - user: {{ user }}
    - unless: ls {{ downloads }}/chefdk-{{ version }}.dmg

{#-
chefdk_mount:
  cmd:
    - run
    - cwd: {{ downloads }}
    - name: hdiutil mount chefdk-{{ version }}.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/chefdk {{ version }}/
    - require:
      - cmd: chefdk_download

chefdk_install:
  cmd:
    - run
    - cwd: /Volumes/Adium {{ version }}/
    - name: mv Adium.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/Adium.app
    - require:
      - cmd: chefdk_mount

chefdk_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Adium\ {{ version }}/
    - user: {{ user }}
    - onlyif: test -d /Volumes/Adium\ {{ version }}/
    - require:
      - cmd: chefdk_install
      #}
