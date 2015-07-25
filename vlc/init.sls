{%- from "macros.jinja2" import dmg_install with context %}

{%- set version = '2.2.1' %}

{{ dmg_install('vlc',
               version=version,
               source='http://get.videolan.org/vlc/' + version + '/macosx/vlc-' + version + '.dmg',
               source_hash='sha1=ac20bcdeb18fd21627fd2b08e7bcf295258ad513',
               app_name='VLC.app',
               volume='vlc-' + version) }}
