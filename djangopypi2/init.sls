include:
  - apache

djangopypi2:
  virtualenv:
    - manage
    - upgrade: True
    - name: /opt/djangopypi2
    - venv_bin: /usr/local/bin/virtualenv
  module:
    - run
    - name: pip.install
    - pkgs: djangopypi2
    - bin_env: /opt/djangopypi2
    - require:
      - virtualenv: djangopypi2

gunicorn:
  module:
    - run
    - name: pip.install
    - pkgs: gunicorn
    - bin_env: /opt/djangopypi2
    - require:
      - virtualenv: djangopypi2

/etc/djangopypi2:
  file:
    - directory
    - user: root
    - group: wheel
    - mode: 755

syncdb:
  module:
    - run
    - name: django.syncdb
    - settings_module: djangopypi2.website.settings
    - bin_env: /opt/djangopypi2
    - env: DJANGOPYPI2_ROOT=/etc/djangopypi2
    - require:
      - virtualenv: djangopypi2
      - module: djangopypi2
      - file: /etc/djangopypi2

collectstatic:
  module:
    - run
    - name: django.collectstatic
    - settings_module: djangopypi2.website.settings
    - bin_env: /opt/djangopypi2
    - env: DJANGOPYPI2_ROOT=/etc/djangopypi2
    - require:
      - virtualenv: djangopypi2
      - module: djangopypi2

loaddata_initial:
  module:
    - run
    - name: django.loaddata
    - settings_module: djangopypi2.website.settings
    - fixtures: initial
    - bin_env: /opt/djangopypi2
    - env: DJANGOPYPI2_ROOT=/etc/djangopypi2
    - require:
      - virtualenv: djangopypi2
      - module: djangopypi2

createsuperuser:
  module:
    - run
    - name: django.createsuperuser
    - settings_module: djangopypi2.website.settings
    - bin_env: /opt/djangopypi2
    - username: quanta
    - email: tonganhquan.net@gmail.com

djangopypi2_hostname:
  cmd:
    - run
    - name: salt-call augeas.setvalue '/files/etc/hosts/1/alias[last() + 1]' {{ pillar['djangopypi2']['hostname'] }}
    - unless: grep '127.0.0.*{{ pillar['djangopypi2']['hostname'] }}' /etc/hosts

/etc/apache2/other/pip.conf:
  file:
    - managed
    - template: jinja
    - source: salt://djangopypi2/vhost.jinja2
    - user: root
    - group: wheel
    - mode: 644
    - require:
      - cmd: djangopypi2_hostname

/etc/djangopypi2/wsgi.py:
  file:
    - managed
    - template: jinja
    - source: salt://djangopypi2/wsgi.jinja2
    - user: root
    - group: wheel
    - mode: 755

extend:
  httpd:
    module:
      - watch:
        - file: /etc/apache2/other/pip.conf
