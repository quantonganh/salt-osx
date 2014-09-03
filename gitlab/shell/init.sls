include:
  - git

https://github.com/gitlabhq/gitlab-shell.git:
  git:
    - latest
    - rev: v1.9.7
    - target: {{ pillar['home'] }}/git/gitlab-shell
    - user: git
    - require:
      - file: {{ pillar['home'] }}/git
    - unless: 'test -d {{ pillar['home'] }}/git/gitlab-shell/.git'

{{ pillar['home'] }}/git/gitlab-shell/config.yml:
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
    - cwd: {{ pillar['home'] }}/git/gitlab-shell
    - name: ./bin/install
    - user: git
    - require:
      - file: {{ pillar['home'] }}/git/gitlab-shell/config.yml

