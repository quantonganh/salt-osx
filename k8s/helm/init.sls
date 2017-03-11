{%- from 'macros.jinja2' import user %}

include:
  - brew

helm:
  pkg:
    - installed
    - name: kubernetes-helm
    - require:
      - cmd: brew
  cmd:
    - wait
    - user: {{ user }}
    - name: helm init
    - watch:
      - pkg: helm
