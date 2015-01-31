{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['pillar.get']('master:file_roots:base')[0] %}

include:
  - vim.pathogen

https://github.com/SirVer/ultisnips.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/ultisnips
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/ultisnips

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
      - git: https://github.com/SirVer/ultisnips.git
{% endfor %}

{{ home }}/.vim/bundle/ultisnips/UltiSnips/jinja2.snippets:
  file:
    - managed
    - source: salt://vim/ultisnips/jinja2.snippets
    - user: {{ user }}
    - group: staff
    - mode: 600
    - require:
      - git: https://github.com/SirVer/ultisnips.git
