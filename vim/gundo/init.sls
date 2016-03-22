{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

vim_gundo:
  git:
    - latest
    - name: http://github.com/sjl/gundo.vim.git
    - target: {{ home }}/.vim/bundle/gundo.vim
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/gundo.vim
  file:
    - accumulated
    - name: plugins
    - filename: {{ home }}/.vimrc
    - require_in:
      - git: vim_gundo
      - file: vimrc
    - text: |
        " gundo
        nnoremap <F6> :GundoToggle<CR>
        " end of gundo
