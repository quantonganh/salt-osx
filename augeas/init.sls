augeas:
  pkg:
    - installed
  module:
    - run
    - name: pip.install
    - bin_env: /usr/local/bin/pip
    - pkgs: https://fedorahosted.org/released/python-augeas/python-augeas-0.4.1.tar.gz
