include:
  - brew

mypkgs:
  pkg:
    - installed
    - pkgs:
{%- for pkg in salt['pillar.get']('pkgs') %}
      - {{ pkg }}
{%- endfor %}
    - require:
      - cmd: brew
