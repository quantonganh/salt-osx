include:
  - vim.pathogen

http://github.com/sjl/gundo.vim.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/gundo.vim
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/gundo.vim

{% for file in ('~/.vimrc', '/srv/salt/vim/vimrc.jinja2') %}
{{ file }}:
  cmd:
    - run
    - name: echo 'nnoremap <F6> :GundoToggle<CR>' >> {{ file }}
    - user: {{ pillar['user'] }}
    - unless: grep GundoToggle {{ file }}
    - require:
      - git: http://github.com/sjl/gundo.vim.git
{% endfor %}
