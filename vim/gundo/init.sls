{%- from "macros.jinja2" import user with context %}

include:
  - vim.pathogen

vim_gundo:
  git:
    - latest
    - name: http://github.com/sjl/gundo.vim.git
    - target: {{ user.home }}/.vim/bundle/gundo.vim
    - user: {{ user.owner}}
    - unless: test -d {{ user.home }}/.vim/bundle/gundo.vim
  file:
    - accumulated
    - name: plugins
    - filename: {{ user.home }}/.vimrc
    - require_in:
      - git: vim_gundo
      - file: vimrc
    - text: |
        " gundo
        nnoremap <F6> :GundoToggle<CR>
        " end of gundo
