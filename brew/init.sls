{%- from "macros.jinja2" import user with context %}

brew:
  cmd:
    - run
    - user: {{ user }}
    - name: ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    - unless: test -f /usr/local/bin/brew

{%- if salt['pillar.get']('brew:update', False) %}
brew_update:
  cmd:
    - run
    - user: {{ user }}
    - name: brew update
    - unless: brew doctor
    - require:
      - cmd: brew
{%- endif %}
