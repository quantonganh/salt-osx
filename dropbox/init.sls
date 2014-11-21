{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '31.0' %}

dropbox_download:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'https://dl-web.dropbox.com/installer?tag=eJyrVipOLS7OzM-Lz0xRslIwNDe3MDM2NDM1NzIxNjM0MbI0NzA2MzMxMTUxtbA0MDYwNDM3NbeoBQCqWw3L&build_key=Dropbox&build_no=2.10.28&plat=mac'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/DropboxInstaller.dmg

dropbox_mount:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: hdiutil mount DropboxInstaller.dmg
    - user: {{ user }}
    - unless: test -d /Volumes/Dropbox\ Installer
    - require:
      - cmd: dropbox_download

dropbox_install:
  cmd:
    - run
    - cwd: /Volumes/Dropbox Installer/
    - name: cp -r Dropbox.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/Dropbox.app
    - require:
      - cmd: dropbox_mount

dropbox_unmount:
  cmd:
    - run
    - name: hdiutil unmount /Volumes/Dropbox\ Installer/
    - user: {{ user }}
    - onlyif: test -d /Volumes/Dropbox\ Installer
    - require:
      - cmd: dropbox_install
