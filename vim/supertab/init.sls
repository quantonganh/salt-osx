include:
  - vim.pathogen

https://github.com/ervandew/supertab.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/supertab
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/supertab

{% for file in ('~/.vimrc', '/srv/salt/vim/vimrc.jinja2') %}
{{ file }}:
  cmd:
    - run
    - name: echo 'let g:SuperTabDefaultCompletionType = "context"' >> {{ file }}
    - user: {{ pillar['user'] }}
    - unless: grep SuperTabDefaultCompletionType {{ file }}
    - require:
      - git: https://github.com/ervandew/supertab.git
{% endfor %}
