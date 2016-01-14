{%- from "macros.jinja2" import dmg_install with context %}

{%- set version = '2.0' %}

{{ dmg_install('KeePassX',
               version=version,
               source='https://www.keepassx.org/releases/2.0/KeePassX-2.0.dmg',
               source_hash='md5=f5eb7bd72bf97dc8b08308f87cdf1470') }}
