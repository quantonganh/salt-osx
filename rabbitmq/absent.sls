rabbitmq-absent:
  module:
    - run
    - name: service.stop
    - job_label: homebrew.mxcl.rabbitmq
  cmd:
    - run
    - name: brew uninstall rabbitmq
    - onlyif: brew list | grep rabbitmq
    - require:
      - module: rabbitmq-absent

{{ pillar['home'] }}/{{ pillar['user'] }}/Library/LaunchAgents/homebrew.mxcl.rabbitmq.plist:
  file:
    - absent
    - require:
      - module: rabbitmq-absent
