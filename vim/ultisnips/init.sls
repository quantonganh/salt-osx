{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

vim_ultisnips:
{%- if salt['file.directory_exists'](home + '/.vim/bundle/ultisnips') %}
  cmd:
    - run
    - user: {{ user }}
    - cwd: {{ home }}/.vim/bundle/ultisnips
    - name: |
        git fetch origin master
        git reset --hard FETCH_HEAD
    - requrie_in:
      - git: vim_ultisnips
{%- endif %}
  git:
    - latest
    - name: https://github.com/SirVer/ultisnips.git
    - target: {{ home }}/.vim/bundle/ultisnips
    - user: {{ user }}
  file:
    - accumulated
    - name: plugins
    - filename: {{ home }}/.vimrc
    - require_in:
      - git: vim_ultisnips
      - file: vimrc
      - file: {{ home }}/.vim/bundle/ultisnips/UltiSnips
    - text: |
        " gundo
        let g:UltiSnipsSnippetsDir ="~/.vim/bundle/ultisnips/UltiSnips"
        let g:UltiSnipsListSnippets = "<c-j>"
        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<tab>"
        let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
        " end of gundo

{{ home }}/.vim/bundle/ultisnips/UltiSnips:
  file:
    - directory
    - user: {{ user }}
    - group: staff
    - mode: 750
    - require:
      - git: vim_ultisnips

{{ home }}/.vim/bundle/ultisnips/UltiSnips/jinja2.snippets:
  file:
    - managed
    - source: salt://vim/ultisnips/jinja2.snippets
    - user: {{ user }}
    - group: staff
    - mode: 600
    - require:
      - git: vim_ultisnips
