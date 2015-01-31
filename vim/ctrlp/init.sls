{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['pillar.get']('master:file_roots:base')[0] %}

include:
  - vim.pathogen

https://github.com/kien/ctrlp.vim.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/ctrlp.vim
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/ctrlp.vim

{% for file in ('~/.vimrc', file_roots ~ '/vim/rc.jinja2') %}
{{ file }}:
  file:
    - append
    - text: |
        set runtimepath^=~/.vim/bundle/ctrlp.vim
        let g:ctrlp_map = '<leader>f'
        let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("e")': ['<c-v>', '<2-LeftMouse>'],
            \ 'AcceptSelection("v")': ['<cr>', '<RightMouse>'],
            \ }
    - require:
      - git: https://github.com/kien/ctrlp.vim.git
{% endfor %}
