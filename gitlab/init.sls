include:
  - git

{%- set home_dir = "/Users/git" %}
{%- set gitlab_dir = home_dir + "/gitlab" %}

icu4c:
  pkg:
    - installed

https://github.com/gitlabhq/gitlabhq.git:
  git:
    - latest
    - rev: 6-3-stable
    - target: /Users/git/gitlab
    - user: git
    - require:
      - file: /Users/git
    - unless: 'test -d /Users/git/gitlab/.git'

/Users/git/gitlab/config/gitlab.yml:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/gitlab.jinja2
    - user: git
    - group: git
    - mode: 644

{% for d in ('gitlab/log', 'gitlab/tmp', 'gitlab-satellites', 'gitlab/tmp/sockets', 'gitlab/tmp/pids', 'gitlab/public/upload') %}
/Users/git/{{ d }}:
  file:
    - directory
    - user: git
    - mode: 700
{% endfor %}

/Users/git/repositories/:
  file:
    - directory
    - user: git
    - group: git
    - mode: 770

repositories-sgid:
  cmd:
    - run
    - name: find /Users/git/repositories/ -type d -print0 | sudo xargs -0 chmod g+s
    - require:
      - file: /Users/git/repositories/

unicorn:
  gem:
    - installed

/Users/git/gitlab/config/unicorn.rb:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/unicorn.jinja2
    - user: git
    - group: git
    - mode: 644
    - require:
      - gem: unicorn

/Users/git/gitlab/config/initializers/rack_attack.rb:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/rack_attack.jinja2
    - user: git
    - group: git
    - mode: 644

/Users/git/gitlab/config/database.yml:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/database.jinja2
    - user: git
    - group: git
    - mode: 640

charlock_holmes:
  gem:
    - installed
    - version: 0.6.9.4
    - require:
      - pkg: icu4c

bundler:
  gem:
    - installed
    - require:
      - gem: charlock_holmes
  cmd:
    - run
    - name: bundle install --deployment --without development test postgres aws --verbose
    - cwd: {{ gitlab_dir }}
    - require:
      - gem: bundler

gitlab:
  cmd:
    - run
    - name: force=yes bundle exec rake gitlab:setup
    - env:
        RAILS_ENV: production
    - user: git
    - cwd: {{ gitlab_dir }}
    - require:
      - cmd: bundler

/etc/init.d:
  file:
    - directory
    - user: root
    - group: wheel
    - mode: 755

/etc/init.d/gitlab:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/gitlab.init.jinja2
    - user: root
    - group: wheel
    - mode: 755
