{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '2_9_20150715' %}

iterm2:
  archive:
    - extracted
    - name: {{ home }}/Downloads
    - source: https://iterm2.com/downloads/nightly/iTerm2-{{ version }}-nightly.zip
    - source_hash: md5=b0da1310ca439e7c593826fad2c950ea
    - archive_format: zip
    - if_missing: {{ home }}/Downloads/iTerm.app
  file:
    - directory
    - name: {{ home }}/Downloads/iTerm.app/
    - user: {{ user }}
    - require:
      - archive: iterm2
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: rsync -av --delete iTerm.app/ /Applications/iTerm.app/
    - user: {{ user }}
    - require:
      - file: iterm2
