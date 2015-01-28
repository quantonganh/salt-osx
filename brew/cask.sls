{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}

include:
  - brew

brew-cask:
  cmd:
    - wait
    - name: brew install caskroom/cask/brew-cask
    - user: {{ user }}
    - watch:
      - cmd: brew_install
