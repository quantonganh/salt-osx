{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set version = '2_1_4' %}

iterm2:
  archive:
    - extracted
    - name: {{ home }}/Downloads/
    - source: https://iterm2.com/downloads/stable/iTerm2-{{ version }}.zip
    - source_hash: md5=07c275cb78ef2d42bc335e20d1f95d16
    - archive_format: zip
    - if_missing: {{ home }}/Downloads/iTerm.app/
  file:
    - directory
    - name: {{ home }}/Downloads/iTerm.app/
    - owner: {{ user }}
    - require:
      - archive: iterm2
  cmd:
    - run
    - cwd: {{ home }}/Downloads/
    - name: rsync -av --delete iTerm.app/ /Applications/iTerm.app/
    - user: {{ user }}
    - unless: grep -A1 CFBundleVersion /Applications/iTerm.app/Contents/Info.plist | grep {{ version }}
    - require:
      - file: iterm2
