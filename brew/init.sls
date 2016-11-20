{%- from "macros.jinja2" import user with context %}
{%- set pkgs = salt['pillar.get']('brew:pkgs', []) %}
{%- set cask_pkgs = salt['pillar.get']('brew:cask:pkgs', []) %}

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

{%- if cask_pkgs -%}
  {%- for pkg in cask_pkgs %}
brew_cask_{{ pkg }}:
  cmd:
    - run
    - user: {{ user }}
    - name: brew cask install {{ pkg }}
    - unless: test -d /usr/local/Caskroom/{{ pkg }}
    - require:
      - cmd: brew
  {%- endfor -%}
{%- endif %}
