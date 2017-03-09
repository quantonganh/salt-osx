{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - brew

prezto:
  git:
    - latest
    - name: https://github.com/sorin-ionescu/prezto.git
    - rev: master
    - target: {{ home }}/.zprezto
    - user: {{ user }}
    - unless: test -d {{ home }}/.zprezto
  cmd:
    - wait_script
    - name: salt://zsh/prezto/default.zsh
    - user: {{ user }}
    - shell: /bin/zsh
    - watch:
      - git: prezto
  file:
    - managed
    - name: {{ home }}/.zpreztorc
    - source: salt://zsh/prezto/config.rc
    - user: {{ user }}
    - group: staff
    - mode: 640
    - require:
      - cmd: prezto
  module:
    - wait
    - name: cmd.run
    - cmd: chsh -s /bin/zsh {{ user }}
    - watch:
      - git: prezto

prezto-syntax-highlighting:
  git:
    - latest
    - name: https://github.com/zsh-users/zsh-syntax-highlighting.git
    - rev: master
    - target: {{ home }}/.zprezto/modules/syntax-highlighting/external
    - force: True
    - unless: test -f {{ home }}/.zprezto/modules/syntax-highlighting/external/zsh-syntax-highlighting.zsh
    - watch:
      - git: prezto

prezto-history-substring-search:
  git:
    - latest
    - name: https://github.com/zsh-users/zsh-history-substring-search.git
    - rev: master
    - target: {{ home }}/.zprezto/modules/history-substring-search/external
    - force: True
    - unless: test -f {{ home }}/.zprezto/modules/history-substring-search/external/zsh-history-substring-search.zsh
    - watch:
      - git: prezto

prezto-prompt:
  cmd:
    - wait
    - names:
      - wget -P {{ home }}/.zprezto/modules/prompt/external/agnoster/ https://raw.githubusercontent.com/digitalformula/zsh.prompts/master/prompt_agnoster_setup
      - wget -P {{ home }}/.zprezto/modules/prompt/external/agnoster/ https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/themes/agnoster.zsh-theme
      - wget -P {{ home }}/.zprezto/modules/prompt/external/powerline/ https://raw.githubusercontent.com/davidjrice/prezto_powerline/master/prompt_powerline_setup
      - wget -P {{ home }}/.zprezto/modules/prompt/external/pure https://raw.githubusercontent.com/Layzie/dotfiles/master/.zsh/functions/Completion/prompt_pure_setup
      - wget -P {{ home }}/.zprezto/modules/prompt/external/pure https://raw.githubusercontent.com/sindresorhus/pure/master/pure.zsh
    - watch:
      - git: prezto
    - require:
      - pkg: brew
