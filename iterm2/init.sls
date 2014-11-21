{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = 'v2_0' %}

iterm2:
  archive:
    - extracted
    - name: {{ home }}/Downloads/
    - source: https://iterm2.com/downloads/stable/iTerm2_{{ version }}.zip
    - source_hash: md5=002b02ced93c36707bda3b5816fba345
    - archive_format: zip
    - if_missing: {{ home }}/Downloads/iTerm.app/
  file:
    - directory
    - name: {{ home }}/Downloads/iTerm.app/
    - owner: {{ user }}
    - require:
      - archive: iterm2

iterm2_install:
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: cp -r iTerm.app /Applications/
    - user: {{ user }}
    - unless: test -d /Applications/iTerm.app/
    - require:
      - file: iterm2
