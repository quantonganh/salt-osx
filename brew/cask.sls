{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set version = '0.54.1' %}

include:
  - brew

brew-cask:
  cmd:
    - run
    - name: brew install caskroom/cask/brew-cask
    - user: {{ user }}
    - unless: brew list | grep brew-cask
    - onlyif: brew-cask --version != {{ version }}
    - require:
      - cmd: brew
{%- if salt['cmd.run']('brew-cask --version') != version %}
      - cmd: brew-cask_unlink_old_version

brew-cask_unlink_old_version:
  cmd:
    - run
    - name: brew unlink brew-cask
    - user: {{ user }}
    - require:
      - cmd: brew
{%- endif %}
