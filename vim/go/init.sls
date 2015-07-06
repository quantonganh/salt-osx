{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - vim.pathogen

vim_go:
  git:
    - latest
    - name: https://github.com/fatih/vim-go.git
    - target: {{ home }}/.vim/bundle/vim-go
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/vim-go
  file:
    - append
    - name: {{ home }}/.vimrc
    - text: |

        " go
        let g:go_highlight_functions = 1
        let g:go_highlight_methods = 1
        let g:go_highlight_structs = 1
        let g:go_highlight_operators = 1
        let g:go_highlight_build_constraints = 1
        " end of go
    - require:
      - git: vim_go
    - watch_in:
      - cmd: vimrc
