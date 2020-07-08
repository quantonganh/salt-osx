{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "macros.jinja2" import user, home with context %}
{%- set pkgs = salt['pillar.get']('fisher:pkgs', []) %}

include:
  - fish

fisher:
  cmd:
    - run
    - name: curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    - user: {{ user }}
    - unless: test -f ~/.config/fish/functions/fisher.fish

{%- if pkgs %}
fisher_pkgs:
  cmd:
    - run
    - user: {{ user }}
    - name: fisher add {{ pkgs | join(' ') }}
    - require:
      - cmd: fisher
{%- endif %}
