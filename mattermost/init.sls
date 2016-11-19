{%- from "macros.jinja2" import user, home, downloads with context %}

{%- set version = '3.4.1' %}

mattermost:
  archive:
    - extracted
    - name: {{ downloads }}
    - source: https://releases.mattermost.com/desktop/{{ version }}/mattermost-desktop-{{ version }}-osx.tar.gz
    - source_hash: md5=14a31de4e3787f98c867a4d719d341fb
    - archive_format: tar
    - tar_options: x
    - user: {{ user }}
    - if_missing: {{ downloads }}/mattermost-desktop-osx
  cmd:
    - wait
    - cwd: {{ downloads }}/mattermost-desktop-osx
    - name: rsync -a --delete Mattermost.app/ /Applications/Mattermost.app/
    - user: {{ user }}
    - watch:
      - archive: mattermost
