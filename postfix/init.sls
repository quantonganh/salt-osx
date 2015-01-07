org.postfix.master.plist:
  file:
    - managed
    - name: /System/Library/LaunchDaemons/org.postfix.master.plist
    - source: salt://postfix/master.plist
    - user: root
    - group: wheel
    - mode: 644

/etc/postfix/main.cf:
  file:
    - managed
    - source: salt://postfix/main.cf
    - user: root
    - group: wheel
    - mode: 644

/etc/postfix/sasl_passwd:
  file:
    - managed
    - template: jinja
    - source: salt://postfix/sasl_passwd.jinja2
    - user: root
    - group: wheel
    - mode: 600
  cmd:
    - wait
    - name: postmap /etc/postfix/sasl_passwd
    - watch:
      - file: /etc/postfix/sasl_passwd

postfix:
  module:
    - run
    - name: service.restart
    - job_label: org.postfix.master
    - watch:
      - file: /etc/postfix/main.cf
      - file: /etc/postfix/sasl_passwd
