brew-update:
  cmd:
    - run
    - name: brew update
    - unless: brew doctor
