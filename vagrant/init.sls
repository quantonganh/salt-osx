{%- from "macros.jinja2" import dmg_install with context %}

{%- set version = '1.7.4' %}

{{ dmg_install('vagrant',
               version=version,
               filename='vagrant_' + version,
               source='https://dl.bintray.com/mitchellh/vagrant/vagrant_' + version + '.dmg',
               source_hash='md5=dab14e5498db788cc85a7335d8186d66',
               pkg=True) }}
