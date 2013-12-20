include:
  - mysql.python

user_create:
  module:
    - run
    - name: mysql.user_create
    - user: 'gitlab'
    - host: 'localhost'
    - password: {{ pillar['mysql']['gitlab'] }}
    - require:
      - module: mysql-python

db_create:
  module:
    - run
    - name: mysql.db_create
    - m_name: 'gitlab'
    - character_set: 'utf8'
    - collate: 'utf8_unicode_ci'

grant_add:
  module:
    - run 
    - name: mysql.grant_add
    - grant: 'SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER'
    - database: 'gitlab.*'
    - user: 'gitlab'
    - host: 'localhost'
    - require:
      - module: db_create
      - module: user_create

