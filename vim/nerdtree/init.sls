{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

https://github.com/scrooloose/nerdtree.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/nerdtree
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/nerdtree

{% for file in ('~/.vimrc', '/srv/salt/vim/vimrc.jinja2') %}
nerdtree-{{ file }}:
  cmd:
    - run
    - name: echo '\nmap <F9> :NERDTreeToggle<CR>\nimap <F9> <ESC>:NERDTreeToggle<CR>' >> {{ file }}
    - user: {{ user }}
    - unless: grep NERDTreeToggle {{ file }}
    - require:
      - git: https://github.com/scrooloose/nerdtree.git
{% endfor %}
