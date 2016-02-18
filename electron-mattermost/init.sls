{%- from "macros.jinja2" import user, home, downloads with context %}

{%- set version = '1.0.5' %}

electron-mattermost:
  archive:
    - extracted
    - name: {{ downloads }}
    - source: https://github.com/yuya-oc/electron-mattermost/releases/download/v{{ version }}/electron-mattermost-v{{ version }}-osx.tar.gz
    - source_hash: md5=9d6bb6916a23477d47498aece180d793
    - archive_format: tar
    - tar_options: x
    - user: {{ user }}
    - if_missing: {{ downloads }}/electron-mattermost-v{{ version }}-osx
  cmd:
    - wait
    - cwd: {{ downloads }}/electron-mattermost-v{{ version }}-osx
    - name: rsync -a --delete electron-mattermost.app/ /Applications/electron-mattermost.app/
    - user: {{ user }}
    - watch:
      - archive: electron-mattermost
