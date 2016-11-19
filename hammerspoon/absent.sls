{%- from "macros.jinja2" import home with context %}

hammerspoon:
  file:
    - absent
    - names:
      - {{ home }}/.hammerspoon
      - /Applications/Hammerspoon.app
