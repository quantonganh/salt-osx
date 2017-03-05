{%- set user = salt['cmd.run']('stat -f "%Su" /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

include:
  - vim

vim_go:
  file:
    - managed
    - name: {{ home }}/.vimrc.d/go.vim
    - contents: |
        au FileType go nmap <leader>r <Plug>(go-run)
        au FileType go nmap <leader>b <Plug>(go-build)
        au FileType go nmap <leader>t <Plug>(go-test)
        au FileType go nmap <leader>c <Plug>(go-coverage)

        au FileType go nmap <Leader>ds <Plug>(go-def-split)
        au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
        au FileType go nmap <Leader>dt <Plug>(go-def-tab)

        au FileType go nmap <Leader>gd <Plug>(go-doc)
        au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

        au FileType go nmap <Leader>gb <Plug>(go-doc-browser)

        au FileType go nmap <Leader>s <Plug>(go-implements)

        au FileType go nmap <Leader>i <Plug>(go-info)
        au FileType go nmap <Leader>e <Plug>(go-rename)

        let g:go_highlight_functions = 1
        let g:go_highlight_methods = 1
        let g:go_highlight_structs = 1
        let g:go_highlight_operators = 1
        let g:go_highlight_build_constraints = 1

        let g:go_fmt_fail_silently = 1
        let g:go_play_open_browser = 0
        let g:go_get_update = 0
    - user: {{ user }}
    - group: staff
    - mode: 640
    - require:
      - file: {{ home }}/.vimrc.d
