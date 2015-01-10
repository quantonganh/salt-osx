{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

prezto_clone_repo:
  cmd:
    - run
    - name: git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    - user: {{ user }}
    - shell: /bin/zsh
    - unless: test -d "${ZDOTDIR:-$HOME}/.zprezto"

prezto_create_config:
  cmd:
    - wait_script
    - name: salt://prezto/default.zsh
    - user: {{ user }}
    - shell: /bin/zsh
    - watch:
      - cmd: prezto_clone_repo
  file:
    - managed
    - name: {{ home }}/.zpreztorc
    - source: salt://prezto/config.rc
    - user: {{ user }}
    - group: staff
    - mode: 640
    - require:
      - cmd: prezto_create_config

prezto_change_shell:
  cmd:
    - run
    - name: chsh -s /bin/zsh {{ user }}
    - onlyif: test {{ salt['user.info'](user)['shell'] }} != "/bin/zsh"
    - require:
      - cmd: prezto_create_config
