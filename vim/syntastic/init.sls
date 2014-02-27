include:
  - vim.pathogen

https://github.com/scrooloose/syntastic.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/syntastic
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/syntastic

{% for file in ('~/.vimrc', '/srv/salt/vim/vimrc.jinja2') %}
{{ file }}:
  cmd:
    - run
    - name: echo "let g:syntastic_check_on_open=1\nlet g:syntastic_python_checkers=['flake8']\n" >> {{ file }}
    - user: {{ pillar['user'] }}
    - unless: grep syntastic {{ file }}
    - require:
      - git: https://github.com/scrooloose/syntastic.git
{% endfor %}
