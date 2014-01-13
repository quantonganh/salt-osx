include:
  - vim.pathogen

https://github.com/scrooloose/nerdtree.git:
  git:
    - latest
    - target: {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/nerdtree
    - user: {{ pillar['user'] }}
    - unless: test -d {{ pillar['home'] }}/{{ pillar['user'] }}/.vim/bundle/nerdtree

{% for file in ('~/.vimrc', '/srv/salt/vim/vimrc.jinja2') %}
nerdtree-{{ file }}:
  cmd:
    - run
    - name: echo '\nmap <F9> :NERDTreeToggle<CR>\nimap <F9> <ESC>:NERDTreeToggle<CR>' >> {{ file }}
    - user: {{ pillar['user'] }}
    - unless: grep NERDTreeToggle {{ file }}
    - require:
      - git: https://github.com/scrooloose/nerdtree.git
{% endfor %}
