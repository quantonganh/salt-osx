{%- from 'macros.jinja2' import home %}

helm:
  pkg:
    - removed
    - name: kubernetes-helm
  file:
    - absent
    - name: {{ home }}/.helm
    - require:
      - pkg: helm
