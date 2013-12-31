salt_api:
  module:
    - run
    - name: pip.install
    - bin_env: /usr/local/bin/pip
    - pkgs: salt-api
