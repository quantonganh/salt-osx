{%- from "macros.jinja2" import user with context %}

include:
  - brew

{%- for pkg in salt['pillar.get']('brew:cask:pkgs', []) %}
brew_cask_{{ pkg }}:
  cmd:
    - run
    - user: {{ user }}
    - name: brew cask install {{ pkg }}
    - unless: test -d /usr/local/Caskroom/{{ pkg }}
    - require:
      - cmd: brew
{%- endfor %}
