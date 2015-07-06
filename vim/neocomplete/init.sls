{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - vim.pathogen

macvim_lua:
  cmd:
    - run
    - user: {{ user }}
    - name: |
        brew unlink macvim
        brew install macvim --with-cscope --with-lua --HEAD
    - unless: vim --version | grep '\-lua'

vim_neocomplete:
  git:
    - latest
    - name: https://github.com/Shougo/neocomplete.vim.git
    - target: {{ home }}/.vim/bundle/neocomplete.vim
    - user: {{ user }}
    - require:
      - cmd: macvim_lua
  file:
    - append
    - name: {{ home }}/.vimrc
    - text: |

        " neocomplete
        let g:neocomplete#enable_at_startup = 1
        " end of neocomplete
    - require:
      - git: vim_neocomplete
    - watch_in:
      - cmd: vimrc
