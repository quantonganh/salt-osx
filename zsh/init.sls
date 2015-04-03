include:
  - prezto

{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

zsh:
  file:
    - managed
    - name: {{ home }}/.zprezto/runcoms/zshrc
    - source: salt://zsh/rc
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - cmd: prezto_clone_repo
