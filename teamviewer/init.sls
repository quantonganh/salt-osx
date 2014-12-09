{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set main_version = '10.0' %}
{%- set sub_version = '36341' %}
{%- set version = main_version + '.' + sub_version %}

teamviewer_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'http://download.teamviewer.com/download/TeamViewer.dmg' -O TeamViewer-{{ version }}.dmg
    - user: {{ user }}
    - unless: test -f /Users/{{ user }}/Downloads/TeamViewer-{{ version }}.dmg

teamviewer_mount:
  cmd:
    - run
    - cwd: /Users/{{ user }}/Downloads
    - name: hdiutil mount TeamViewer-{{ version }}.dmg
    - user: {{ user }}
    - unless: grep {{ version }} /Applications/TeamViewer.app/Contents/Info.plist
    - require:
      - cmd: teamviewer_download

teamviewer_install:
  cmd:
    - run
    - name: sudo installer -verbose -pkg /Volumes/TeamViewer/Install\ TeamViewer.pkg -target /
    - user: {{ user }}
    - unless: grep {{ version }} /Applications/TeamViewer.app/Contents/Info.plist
    - require:
      - cmd: teamviewer_mount

teamviewer_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/TeamViewer
    - user: {{ user }}
    - onlyif: test -d /Volumes/TeamViewer
    - require:
      - cmd: teamviewer_install
