include:
  - brew

xquartz:
  cmd:
    - run
    - name: brew install Caskroom/cask/xquartz
    - require:
      - cmd: brew
