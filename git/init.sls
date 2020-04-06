{%- from "macros.jinja2" import user, home with context %}

git:
  group:
    - present
  user:
    - present
    - groups:
      - git
    - shell: /bin/sh
    - home: {{ home }}/git
    - createhome: False
    - require:
      - group: git
  cmd:
    - run
    - name: defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add git
    - unless: defaults read /Library/Preferences/com.apple.loginwindow HiddenUsersList | grep git
    - require:
      - user: git

git_hide:
  cmd:
    - run
    - name: defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool FALSE
    - onlyif: defaults read /Library/Preferences/com.apple.loginwindow | grep '"SHOWOTHERUSERS_MANAGED" = 1'

{{ home }}/git:
  file:
    - directory
    - user: git
    - group: git
    - mode: 700
    - require:
      - user: git
      - group: git

{{ home }}/.gitconfig:
  file:
    - managed
    - template: jinja
    - source: salt://git/config.jinja2
    - user: {{ user }}
    - group: staff
    - mode: 644
