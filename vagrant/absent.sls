{%- from "macros.jinja2" import user, home with context %}

vagrant:
  cmd:
    - run
    - user: {{ user }}
    - name: brew cask uninstall vagrant
  file:
    - absent
    - name: {{ home }}/.zshrc.d/vagrant.zsh
    - require:
      - cmd: vagrant
