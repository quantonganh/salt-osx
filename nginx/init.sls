{%- from "macros.jinja2" import user with context -%}

include:
  - brew

nginx:
  pkg:
    - installed
    - options: "--with-passenger"
    - require:
      - cmd: brew
  cmd:
    - wait
    - name: brew services start nginx
    - watch:
      - pkg: nginx
  service:
    - running
    - name: homebrew.mxcl.nginx
    - require:
      - cmd: nginx

/usr/local/etc/nginx/servers/passenger.conf:
  file:
    - managed
    - contents: |
        passenger_root /usr/local/opt/passenger/libexec/src/ruby_supportlib/phusion_passenger/locations.ini;
        passenger_ruby /usr/bin/ruby;
    - user: {{ user }}
    - group: admin
    - mode: 644
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx
