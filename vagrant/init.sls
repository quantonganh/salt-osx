{%- from "macros.jinja2" import user, home with context %}

include:
  - brew
  - zsh

vagrant:
  cmd:
    - run
    - user: {{ user }}
    - name: brew cask install vagrant
    - unless: test -d /usr/local/Caskroom/vagrant
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/vagrant.zsh
    - contents: |
        alias vh="vagrant halt $1"
        alias vr="vagrant reload $1"
        alias vs="vagrant ssh $1"
        alias vu="vagrant up $1"
    - require:
      - cmd: vagrant
      - file: {{ home }}/.zshrc.d
