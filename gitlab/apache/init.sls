/etc/apache2/other/gitlab.conf:
  file:
    - managed
    - template: jinja
    - source: salt://gitlab/apache/gitlab.jinja2
    - user: root
    - group: wheel
    - mode: 644
