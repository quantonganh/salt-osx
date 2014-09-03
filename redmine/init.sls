{%- set version = '2.5.2' %}

include:
  - apache

{%- for gem in ('bundler', 'passenger') %}  
{{ gem }}:
  gem:
    - installed
{%- endfor %}

redmine_passenger:
  cmd:
    - run
    - name: yes | passenger-install-apache2-module
    - unless: test -f /etc/apache2/other/passenger.conf
    - require:
      - gem: passenger

imagemagick_download:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: wget http://cactuslab.com/imagemagick/assets/ImageMagick-6.8.8-6.pkg.zip
    - unless: test -f /Users/quanta/Downloads/ImageMagick-6.8.8-6.pkg.zip

imagemagick_extract:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: unzip ImageMagick-6.8.8-6.pkg.zip
    - unless: test -f /Users/quanta/Downloads/ImageMagick-6.8.8-6.pkg
    - require:
      - cmd: imagemagick_download

imagemagick_install:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: installer -verbose -pkg ImageMagick-6.8.8-6.pkg -target /
    - unless: test -d /opt/ImageMagick
    - require:
      - cmd: imagemagick_extract

pkgconfig_download:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: wget http://ncu.dl.sourceforge.net/project/macpkg/PkgConfig/0.26/PkgConfig.pkg
    - unless: test -f /Users/quanta/Downloads/PkgConfig.pkg

pkgconfig_install:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: installer -verbose -pkg PkgConfig.pkg -target /
    - unless: test -d /opt/pkgconfig
    - require:
      - cmd: pkgconfig_download

export_path:
  cmd:
    - run
    - name: export PATH=/opt/ImageMagick/bin:/opt/pkgconfig/bin:$PATH

rmagick_download:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: wget http://rubygems.org/downloads/rmagick-2.13.3.gem
    - unless: test -f rmagick-2.13.3.gem

rmagick_install:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: C_INCLUDE_PATH=/opt/ImageMagick/include/ImageMagick-6/ PKG_CONFIG_PATH=/opt/ImageMagick/lib/pkgconfig/ gem install --local rmagick-2.13.3.gem
    - unless: gem list -i rmagick

redmine_download:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: wget http://www.redmine.org/releases/redmine-{{ version }}.tar.gz
    - unless: test -f /Users/quanta/Downloads/redmine-{{ version }}.tar.gz

redmine_extract:
  cmd:
    - run
    - cwd: /Users/quanta/Downloads/
    - name: tar zxvf redmine-{{ version }}.tar.gz -C /Library/WebServer/Documents
    - unless: test -d /Library/WebServer/Documents/redmine-{{ version }}
    - require:
      - cmd: redmine_download

redmine_symlink:
  file:
    - symlink
    - name: /Library/WebServer/Documents/redmine
    - target: /Library/WebServer/Documents/redmine-{{ version }}
    - require:
      - cmd: redmine_extract

redmine_configure:
  cmd:
    - run
    - cwd: /Library/WebServer/Documents/redmine
    - name: |
        mkdir public/plugin_assets
        chown -R _www:_www tmp public/plugin_assets log files
        chmod -R 755 files log tmp public/plugin_assets
    - require:
      - file: redmine_symlink

redmine:
  mysql_user:
    - present
    - host: localhost
    - password: {{ pillar['redmine']['mysql']['password'] }}

redmine_database:
  file:
    - managed
    - name: /Library/WebServer/Documents/redmine/config/database.yml
    - source: salt://redmine/database.jinja2
    - template: jinja

redmine_bundle:
  cmd:
    - run
    - cwd: /Library/WebServer/Documents/redmine
    - name: bundle install --without development test

redmine_rake:
  cmd:
    - run
    - cwd: /Library/WebServer/Documents/redmine
    - name: rake generate_secret_token

redmine_db_migrate:
  cmd:
    - run
    - cwd: /Library/WebServer/Documents/redmine
    - name: RAILS_ENV=production rake db:migrate
    
redmine_load_default_data:
  cmd:
    - run
    - cwd: /Library/WebServer/Documents/redmine
    - name: RAILS_ENV=production rake redmine:load_default_data

{% from "apache/map.jinja" import apache with context %}

redmine_hostname:
  module:
    - run
    - name: hosts.add_host
    - ip: {{ pillar['redmine']['address'] }}
    - alias: {{ pillar['redmine']['hostname'] }}

{{ apache.conf }}/redmine.conf:
  file:
    - managed
    - user: root
    - group: wheel
    - mode: 644
    - template: jinja
    - source: salt://redmine/apache.jinja2
    - require:
      - module: redmine_hostname
    - watch_in:
      - module: apache


