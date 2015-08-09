include:
  - git
  - redis

{%- set home_dir = "{{ pillar['home'] }}/git" %}
{%- set gitlab_dir = home_dir + "/gitlab" %}

icu4c:
  pkg:
    - installed

https://github.com/gitlabhq/gitlabhq.git:
  git:
    - latest
    - rev: 7-2-stable
    - target: /Users/git/gitlab
    - user: git
    - require:
      - file: {{ pillar['home'] }}/git
    - unless: 'test -d {{ pillar['home'] }}/git/gitlab/.git'

{{ pillar['home'] }}/git/gitlab/config/gitlab.yml:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/gitlab.jinja2
    - user: git
    - group: git
    - mode: 644

{% for d in ('gitlab/log', 'gitlab/tmp', 'gitlab-satellites', 'gitlab/tmp/sockets', 'gitlab/tmp/pids', 'gitlab/public/upload') %}
{{ pillar['home'] }}/git/{{ d }}:
  file:
    - directory
    - user: git
    - mode: 700
{% endfor %}

{{ pillar['home'] }}/git/repositories/:
  file:
    - directory
    - user: git
    - group: git
    - mode: 770

repositories-sgid:
  cmd:
    - run
    - name: find {{ pillar['home'] }}/git/repositories/ -type d -print0 | sudo xargs -0 chmod g+s
    - require:
      - file: {{ pillar['home'] }}/git/repositories/

unicorn:
  gem:
    - installed

{{ pillar['home'] }}/git/gitlab/config/unicorn.rb:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/unicorn.jinja2
    - user: git
    - group: git
    - mode: 644
    - require:
      - gem: unicorn

{{ pillar['home'] }}/git/gitlab/config/initializers/rack_attack.rb:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/rack_attack.jinja2
    - user: git
    - group: git
    - mode: 644

{{ pillar['home'] }}/git/gitlab/config/database.yml:
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

cmake:
  pkg:
    - installed

rugged:
  cmd:
    - run
    - name: gem install rugged -v '0.21.0' -V
    - unless: gem list | grep rugged
    - require:
      - pkg: cmake

gitlab_bundler:
  gem:
    - installed
    - require:
      - gem: charlock_holmes
  cmd:
    - run
    - name: bundle install --deployment --without development test postgres aws --verbose
    - cwd: {{ salt['user.info']('git')['home'] }}/gitlab
    - require:
      - gem: gitlab_bundler
      - cmd: rugged

{%- for suffix in ('', '.lock') %}
gitlab_gemfile{{ suffix }}:
  module:
    - run
    - name: file.replace
    - path: /Users/git/gitlab/Gemfile{{ suffix }}
    - pattern: "underscore-rails (1.4.4)"
    - repl: "underscore-rails (1.5.2)"
{%- endfor %}

gitlab_setup:
  cmd:
    - run
    - name: force=yes bundle exec rake gitlab:setup
    - env:
        RAILS_ENV: production
    - user: git
    - cwd: /Users/git/gitlab
    - require:
      - cmd: gitlab_bundler
      - cmd: redis
      - module: gitlab_gemfile.lock
      - module: gitlab_gemfile

gitlab_assets_precompile:
  cmd:
    - run
    - cwd: /Users/git/gitlab
    - name: bundle exec rake assets:precompile RAILS_ENV=production
    - require:
      - cmd: gitlab_setup

/Library/LaunchDaemons/gitlab.web.plist:
  file:
    - managed
    - source: https://raw.githubusercontent.com/CiTroNaK/Installation-guide-for-GitLab-on-OS-X/master/gitlab.web.plist
    - source_hash: md5=d7022c0d483b353c46a7df102982531d
    - require:
      - cmd: gitlab_assets_precompile

gitlab_web:
  module:
    - run
    - name: service.start
    - job_label: gitlab.web
    - require:
      - file: /Library/LaunchDaemons/gitlab.web.plist

/Library/LaunchDaemons/gitlab.background_jobs.plist:
  file:
    - managed
    - source: https://raw.githubusercontent.com/CiTroNaK/Installation-guide-for-GitLab-on-OS-X/master/gitlab.background_jobs.plist
    - source_hash: md5=8d6a387b817aa298648f5b8c1978c5f4
    - require:
      - cmd: gitlab_assets_precompile

gitlab_background_jobs:
  module:
    - run
    - name: service.start
    - job_label: gitlab.background_jobs
    - require:
      - file: /Library/LaunchDaemons/gitlab.background_jobs.plist

/Library/LaunchDaemons/gitlab.backup.plist:
  file:
    - managed
    - source: https://raw.githubusercontent.com/CiTroNaK/Installation-guide-for-GitLab-on-OS-X/master/gitlab.backup.plist
    - source_hash: md5=07259e5db154f0f4396e67b955583468
    - require:
      - cmd: gitlab_assets_precompile

gitlab_backup:
  module:
    - run
    - name: service.start
    - job_label: gitlab.backup
    - require:
      - file: /Library/LaunchDaemons/gitlab.backup.plist

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
    - source: salt://gitlab/gitlab_init.jinja2
    - user: root
    - group: wheel
    - mode: 755
    - require:
      - file: /etc/init.d

gitlab_start:
  cmd:
    - run
    - name: /etc/init.d/gitlab start
    - require:
      - file: /etc/init.d/gitlab

gitlab_plist:
  file:
    - managed
    - name: /Library/LaunchDaemons/com.gitlab.gitlab.plist
    - template: jinja
    - source: salt://gitlab/plist.jinja2
    - user: root
    - group: wheel
    - mode: 644

gitlab_hostname:
  module:
    - run
    - name: hosts.add_host
    - ip: {{ salt['pillar.get']('gitlab:address', '127.0.0.1') }}
    - alias: {{ pillar['gitlab']['url'] }}
