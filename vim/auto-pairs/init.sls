{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['pillar.get']('master:file_roots:base')[0] %}

include:
  - vim.pathogen

vim_auto-pairs:
  git:
    - latest
    - name: git://github.com/jiangmiao/auto-pairs.git
    - target: {{ home }}/.vim/bundle/auto-pairs
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/auto-pairs
