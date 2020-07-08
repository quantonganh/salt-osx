{%- from "macros.jinja2" import user, home with context %}
{%- set pkgs = salt['pillar.get']('brew:pkgs', []) %}

brew:
  cmd:
    - run
    - user: {{ user }}
    - name: ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    - unless: test -f /usr/local/bin/brew
{%- if pkgs %}
  pkg:
    - installed
    - pkgs:
  {%- for pkg in pkgs %}
      - {{ pkg }}
  {%- endfor %}
    - require:
      - cmd: brew
{%- endif %}

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
