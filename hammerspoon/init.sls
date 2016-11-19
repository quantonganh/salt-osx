{%- from "macros.jinja2" import user, home, downloads with context %}
{%- set version = '0.9.49' %}

hammerspoon:
  file:
    - managed
    - name: {{ downloads }}/Hammerspoon-{{ version }}.zip
    - source: https://github.com/Hammerspoon/hammerspoon/releases/download/{{ version }}/Hammerspoon-{{ version }}.zip
    - source_hash: md5=e0625576c54286a410ddb6557d09898d
  module:
    - wait
    - name: archive.cmd_unzip
    - zip_file: {{ downloads }}/Hammerspoon-{{ version }}.zip
    - dest: /Applications
    - watch:
      - file: hammerspoon

{{ home }}/.hammerspoon/init.lua:
  file:
    - managed
    - source: salt://hammerspoon/config.lua
    - user: {{ user }}
    - group: staff
    - mode: 400
    - require:
      - module: hammerspoon
