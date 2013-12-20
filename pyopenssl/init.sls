pyopenssl:
  module:
    - run
    - name: pip.install
    - pkgs: pyOpenSSL
    - bin_env: /usr/local/bin/pip
{#-
    - require_in:
      - salt['saltutil.sync_modules']()
-#}
