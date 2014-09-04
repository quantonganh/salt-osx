git:
  group:
    - present
  user:
    - present
    - groups: 
      - git
    - shell: /bin/sh
    - home: {{ pillar['home'] }}/git
    - createhome: False
    - requite:
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

{{ pillar['home'] }}/git:
  file:
    - directory
    - user: git
    - group: git
    - mode: 700
    - require:
      - user: git
      - group: git

{{ pillar['home'] }}/{{ pillar['user'] }}/.gitconfig:
  file:
    - managed
    - template: jinja
    - source: salt://git/config.jinja2
    - user: {{ pillar['user'] }}
    - group: staff
    - mode: 644
