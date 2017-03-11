{%- from 'macros.jinja2' import user with context %}
{%- set version = '146.0.0' %}
{%- set filename = 'google-cloud-sdk-' ~ version ~ '-' ~ grains['kernel']|lower ~ '-' ~ grains['osarch'] ~ '.tar.gz' %}

gcloud_sdk:
  archive:
    - extracted
    - name: /opt
    - source: https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/{{ filename }}
    - source_hash: sha1=eeef8a6574d8c7fccce265b4784ac397eeacb9d7
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/google-cloud-sdk
  file:
    - directory
    - name: /opt/google-cloud-sdk
    - user: {{ user }}
    - group: staff
    - recurse:
      - user
      - group
    - require:
      - archive: gcloud_sdk
  cmd:
    - wait
    - cwd: /opt/google-cloud-sdk
    - user: {{ user }}
    - name: echo 'Y' | ./install.sh
    - watch:
      - archive: gcloud_sdk
    - require:
      - file: gcloud_sdk
