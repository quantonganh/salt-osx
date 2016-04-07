{%- from "macros.jinja2" import user with context %}

{%- set version = '1.0.1' %}

doctl:
  archive:
    - extracted
    - name: /usr/local/bin
    - source: https://github.com/digitalocean/doctl/releases/download/v{{ version }}/doctl-{{ version }}-{{ grains['kernel'] | lower }}-10.6-amd64.tar.gz
    - source_hash: sha256=70416037a31bf47c23bc19783d538c2634d85f8401f5c3691ec55c9ab1fc997e
    - archive_format: tar
    - tar_options: x
    - user: {{ user }}
    - if_missing: /usr/local/bin/doctl
  cmd:
    - wait
    - user: {{ user }}
    - name: doctl auth login
    - watch:
      - archive: doctl
