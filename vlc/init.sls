{%- from "macros.jinja2" import user with context %}

{%- set version = '2.2.1' %}

vlc:
  file:
    - managed
    - name: {{ user.downloads }}/vlc-{{ version }}.dmg
    - source: http://get.videolan.org/vlc/{{ version }}/macosx/vlc-{{ version }}.dmg
    - source_hash: sha1=ac20bcdeb18fd21627fd2b08e7bcf295258ad513
    - user: {{ user.owner }}
  hdiutil:
    - mounted
    - name: {{ user.downloads }}/vlc-{{ version }}.dmg
    - user: {{ user.owner }}
    - unless: grep {{ version }} /Applications/VLC.app/Contents/Info.plist
    - watch:
      - file: vlc
  cmd:
    - wait
    - cwd: /Volumes/vlc-{{ version }}/
    - name: rsync -a --delete VLC.app/ /Applications/VLC.app/
    - user: {{ user.owner }}
    - watch:
      - hdiutil: vlc
  module:
    - wait
    - name: hdiutil.unmount
    - m_name: /Volumes/vlc-{{ version }}/
    - user: {{ user.owner }}
    - watch:
      - cmd: vlc
