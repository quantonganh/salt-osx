{%- from "macros.jinja2" import user, home with context %}
{%- set version = '0.9.49' %}

include:
  - brew

{{ home }}/.hammerspoon:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 755

hammerspoon:
  cmd:
    - run
    - user: {{ user }}
    - name: brew cask install hammerspoon
    - unless: test -d /usr/local/Caskroom/hammerspoon
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.hammerspoon/init.lua
    - source: salt://hammerspoon/config.lua
    - user: {{ user }}
    - group: staff
    - mode: 400
    - require:
      - cmd: hammerspoon
      - file: {{ home }}/.hammerspoon
