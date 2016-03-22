{%- from "macros.jinja2" import user, home with context %}

include:
  - git

https://github.com/gitlabhq/gitlab-shell.git:
  git:
    - latest
    - rev: v1.9.7
    - target: {{ home }}/git/gitlab-shell
    - user: git
    - require:
      - file: {{ home }}/git
    - unless: 'test -d {{ home }}/git/gitlab-shell/.git'

{{ home }}/git/gitlab-shell/config.yml:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/shell/config.jinja2
    - user: git
    - group: git
    - mode: 644

gitlab_shell_install:
  cmd:
    - run
    - cwd: {{ home }}/git/gitlab-shell
    - name: ./bin/install
    - user: git
    - require:
      - file: {{ home }}/git/gitlab-shell/config.yml

