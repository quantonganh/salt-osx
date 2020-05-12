{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - vim.pathogen

vim_airline:
  git:
    - latest
    - name: https://github.com/bling/vim-airline
    - target: {{ home }}/.vim/bundle/vim-airline
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/vim-airline
  file:
    - managed
    - name: {{ home }}/.vimrc.d/airline.vim
    - contents: |
        set laststatus=2

        " Enable the list of buffers
        let g:airline#extensions#tabline#enabled = 1

        " Show the dir/filename
        let g:airline#extensions#tabline#formatter = 'short_path'

        " Show buffer number
        let g:airline#extensions#tabline#buffer_nr_show = 1
    - require:
      - git: vim_airline
      - file: {{ home }}/.vimrc.d
