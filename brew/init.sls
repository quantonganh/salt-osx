{%- from "macros.jinja2" import user, home with context %}
{%- set pkgs = salt['pillar.get']('brew:pkgs', []) %}

include:
  - zsh

brew:
  cmd:
    - run
    - user: {{ user }}
    - name: ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    - unless: test -f /usr/local/bin/brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/brew.zsh
    - contents: |
        alias b="brew"
        alias bi="brew install"
        alias bif="brew info"
        alias bl="brew list"
        alias br="brew uninstall"
        alias bs="brew search"
        alias bu="brew upgrade"
        alias bud="brew update"
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - cmd: brew
      - file: {{ home }}/.zshrc.d
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
