{%- from "macros.jinja2" import user, home with context %}

rabbitmq:
  pkg:
    - installed
  module:
    - run
    - name: service.start
    - job_label: homebrew.mxcl.rabbitmq
    - runas: {{ user }}
    - require:
      - file: {{ home }}/Library/LaunchAgents/homebrew.mxcl.rabbitmq.plist
  rabbitmq_user:
    - absent
    - name: guest
    - runas: {{ user }}

rabbitmq_monitor_user:
  rabbitmq_user:
    - present
    - name: {{ pillar['rabbitmq']['monitor']['user'] }}
    - password: {{ pillar['rabbitmq']['monitor']['password'] }}
    - force: True
    - tags: monitoring
    - perms:
      - '/':
        - '.*'
        - '.*'
        - '.*'
    - runas: {{ user }}
    - require:
      - module: rabbitmq
  module:
    - run
    - name: rabbitmq.set_user_tags
    - m_name: {{ pillar['rabbitmq']['monitor']['user'] }}
    - tags: monitoring
    - runas: {{ user }}
    - require:
      - rabbitmq_user: rabbitmq_monitor_user

rabbitmq_management_user:
  rabbitmq_user:
    - present
    - name: {{ pillar['rabbitmq']['management']['user'] }}
    - password: {{ pillar['rabbitmq']['management']['password'] }}
    - force: True
    - runas: {{ user }}
    - require:
      - module: rabbitmq
  module:
    - run
    - name: rabbitmq.set_user_tags
    - m_name: {{ pillar['rabbitmq']['management']['user'] }}
    - tags: management
    - runas: {{ user }}
    - require:
      - rabbitmq_user: rabbitmq_management_user

set_management_tags:
  module:
    - run
    - name: cmd.run
    - cmd: rabbitmqctl set_user_tags {{ pillar['rabbitmq']['management']['user'] }} management
    - runas: {{ user }}
    - require:
      - rabbitmq_user: rabbitmq_management_user

rabbitmq-link:
  cmd:
    - run
    - name: brew link rabbitmq
    - unless: test -L /usr/local/sbin/rabbitmq-server
    - require:
      - pkg: rabbitmq

{{ home }}/Library/LaunchAgents/homebrew.mxcl.rabbitmq.plist:
  file:
    - symlink
    - target: /usr/local/opt/rabbitmq/homebrew.mxcl.rabbitmq.plist
    - user: {{ user }}
    - group: staff
    - require:
      - pkg: rabbitmq
