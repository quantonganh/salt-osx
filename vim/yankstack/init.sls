include:
  - vim.pathogen

https://github.com/maxbrunsfeld/vim-yankstack:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/vim-yankstack
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/vim-yankstack

{% for file in ('~/.vimrc', '/srv/salt/vim/vimrc.jinja2') %}
{{ file }}:
  cmd:
    - run
    - name: echo 'set macmeta' >> {{ file }}
    - user: {{ pillar['user'] }}
    - unless: grep macmeta {{ file }}
    - require:
      - git: https://github.com/maxbrunsfeld/vim-yankstack
{% endfor %}
