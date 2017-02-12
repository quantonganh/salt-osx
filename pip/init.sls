pip:
  cmd:
    - run
    - name: easy_install pip
    - unless: which pip
    - reload_modules: True
  pip:
    - installed
    - pkgs: {{ salt['pillar.get']('pip:pkgs') }}
    - require:
      - cmd: pip
