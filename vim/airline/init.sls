{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}
{%- set file_roots = salt['pillar.get']('master:file_roots:base')[0] %}

include:
  - vim.pathogen
  - vim.powerline.absent

vim_airline:
  git:
    - latest
    - name: https://github.com/bling/vim-airline
    - target: {{ home }}/.vim/bundle/vim-airline
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/vim-airline
  file:
    - append
    - name: {{ home }}/.vimrc
    - text: |

        " airline
        set laststatus=2
        " end of airline
    - require:
      - git: vim_airline
    - watch_in:
      - cmd: vimrc
