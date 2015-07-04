{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['pillar.get']('master:file_roots:base')[0] %}

include:
  - vim.pathogen

vim_ultisnips:
  cmd:
    - run
    - cwd: {{ home }}/.vim/bundle/ultisnips
    - name: |
        git fetch origin master
        git reset --hard FETCH_HEAD
  git:
    - latest
    - name: https://github.com/SirVer/ultisnips.git
    - target: {{ home }}/.vim/bundle/ultisnips
    - user: {{ user }}
    - require:
      - cmd: vim_ultisnips

{% for file in ('~/.vimrc', file_roots ~ '/vim/rc.jinja2') %}
{{ file }}:
  file:
    - append
    - text: |
        let g:UltiSnipsSnippetsDir ="~/.vim/bundle/ultisnips/UltiSnips"
        let g:UltiSnipsListSnippets = "<c-j>"
        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
    - require:
      - git: vim_ultisnips
{% endfor %}

{{ home }}/.vim/bundle/ultisnips/UltiSnips/jinja2.snippets:
  file:
    - managed
    - source: salt://vim/ultisnips/jinja2.snippets
    - user: {{ user }}
    - group: staff
    - mode: 600
    - require:
      - git: vim_ultisnips
