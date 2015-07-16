{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

nokia_photo_transfer:
  cmd:
    - run
    - cwd: {{ home }}/Downloads
    - name: wget 'http://nds1.webapps.microsoft.com/Nokia_Photo_Transfer/NokiaPhotoTransferForMac.dmg'
    - user: {{ user }}
    - unless: test -f {{ home }}/Downloads/NokiaPhotoTransferForMac.dmg
  hdiutil:
    - mounted
    - name: {{ home }}/Downloads/NokiaPhotoTransferForMac.dmg
    - user: {{ user }}
    - require:
      - cmd: nokia_photo_transfer
  module:
    - wait
    - name: cmd.run
    - cwd: /Volumes/Nokia Photo Transfer
    - cmd: cp -R Nokia\ Photo\ Transfer.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/Nokia\ Photo\ Transfer.app
    - watch:
      - hdiutil: nokia_photo_transfer

nokia_photo_transfer_unmount:
  hdiutil:
    - unmounted
    - name: /Volumes/Nokia Photo Transfer
    - user: {{ user }}
    - require:
      - module: nokia_photo_transfer
