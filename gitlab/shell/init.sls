include:
  - git

https://github.com/gitlabhq/gitlab-shell.git:
  git:
    - latest
    - rev: v1.7.9
    - target: /Users/git/gitlab-shell
    - user: git
    - require:
      - file: /Users/git
    - unless: 'test -d /Users/git/gitlab-shell/.git'

/Users/git/gitlab-shell/config.yml:
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
    - cwd: /Users/git/gitlab-shell
    - name: ./bin/install
    - user: git
    - require:
      - file: /Users/git/gitlab-shell/config.yml

