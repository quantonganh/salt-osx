{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - brew

fzf:
  pkg:
    - installed
    - require:
      - cmd: brew
  cmd:
    - wait
    - user: {{ user }}
    - name: yes | /usr/local/opt/fzf/install
    - watch:
      - pkg: fzf
  file:
    - managed
    - name: {{ home }}/.vimrc.d/fzf.vim
    - contents: |
        set rtp+=/usr/local/opt/fzf
        nnoremap <leader>b :Buffers<CR>
        nnoremap <leader>f :Files<CR>
    - require:
      - pkg: fzf
