include:
  - vim.pathogen

https://github.com/kien/ctrlp.vim.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/ctrlp.vim
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/ctrlp.vim

{% for file in ('~/.vimrc', '/srv/salt/vim/vimrc.jinja2') %}
{{ file }}:
  cmd:
    - run
    - name: echo 'set runtimepath^=~/.vim/bundle/ctrlp.vim' >> {{ file }}
    - user: {{ pillar['user'] }}
    - unless: grep ctrlp {{ file }}
    - require:
      - git: https://github.com/kien/ctrlp.vim.git
{% endfor %}
