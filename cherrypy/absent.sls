cherrypy:
  module:
    - run
    - bin_env: /usr/local/bin/pip
    - name: pip.uninstall
    - pkgs: CherryPy
