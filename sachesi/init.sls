{%- from "macros.jinja2" import user, home with context %}
{%- set version = '2.0.3' %}

sachesi:
  archive:
    - extracted
    - name: {{ home }}/Downloads/Sachesi{{ version }}-OSX
    - source: https://github.com/xsacha/Sachesi/releases/download/{{ version }}/Sachesi{{ version }}-OSX.zip
    - source_hash: md5=ac71346740fb0ca21ea9e9d835ef94d2
    - archive_format: zip
  module:
    - run
    - name: file.copy
    - src: {{ home }}/Downloads/Sachesi{{ version }}-OSX/Sachesi.app
    - dst: /Applications/Sachesi.app
    - recurse: True
    - require:
      - archive: sachesi
