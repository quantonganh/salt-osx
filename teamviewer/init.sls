{%- from "macros.jinja2" import dmg_install with context %}

{%- set version = '10.0.43320' %}

{{ dmg_install('teamviewer',
               filename='TeamViewer',
               version=version,
               source='http://download.teamviewer.com/download/TeamViewer.dmg',
               source_hash='md5=02c16506a4b9ba4af9173167e5bc1215',
               pkg=True) }}
