redis:
  pkg:
    - installed
  module:
    - run
    - name: pip.install
    - pkgs: redis
    - bin_env: /usr/local/bin/pip
