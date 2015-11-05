include:
  - vagrant

hostmanager_install:
  cmd:
    - run
    - name: vagrant plugin install vagrant-hostmanager
    - require:
      - cmd: vagrant
