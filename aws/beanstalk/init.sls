include:
  - brew

aws-elasticbeanstalk:
  pkg:
    - installed
    - require:
      - cmd: brew
  cmd:
    - wait
    - name: /usr/local/bin/eb --version
    - watch:
      - pkg: aws-elasticbeanstalk
