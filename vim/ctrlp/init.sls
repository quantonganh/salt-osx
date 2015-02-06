{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['pillar.get']('master:file_roots:base')[0] %}

include:
  - vim.pathogen

vim_ctrlp:
  git:
    - latest
    - name: https://github.com/kien/ctrlp.vim.git
    - target: {{ home }}/.vim/bundle/ctrlp.vim
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/ctrlp.vim
  file:
    - append
    - name: {{ home }}/.vimrc
    - text: |

        " ctrp
        set runtimepath^=~/.vim/bundle/ctrlp.vim
        let g:ctrlp_map = '<leader>f'
        let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("e")': ['<c-v>', '<2-LeftMouse>'],
            \ 'AcceptSelection("v")': ['<cr>', '<RightMouse>'],
            \ }
        " end of ctrlp
    - require:
      - git: vim_ctrlp
    - watch_in:
      - cmd: vimrc
