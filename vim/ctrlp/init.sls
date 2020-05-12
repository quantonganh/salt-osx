{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

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
    - managed
    - name: {{ home }}/.vimrc.d/ctrlp.vim
    - contents: |
        set runtimepath^=~/.vim/bundle/ctrlp.vim
        let g:ctrlp_map = '<leader>f'
        map <leader>b :CtrlPBuffer
        let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("e")': ['<c-v>', '<2-LeftMouse>'],
            \ 'AcceptSelection("v")': ['<cr>', '<RightMouse>'],
            \ }
        let g:ctrlp_switch_buffer = '0'
    - require:
      - git: vim_ctrlp
    - watch_in:
      - cmd: vimrc
