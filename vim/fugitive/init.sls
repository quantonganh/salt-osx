{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

vim_fugitive:
  git:
    - latest
    - name: git://github.com/tpope/vim-fugitive.git
    - target: {{ home }}/.vim/bundle/vim-fugitive
    - user: {{ user }}
    - unless: test -d {{ home }}/{{ user }}/.vim/bundle/vim-fugitive
  file:
    - managed
    - name: {{ home }}/.vimrc.d/fugitive.vim
    - contents: |
        nnoremap <leader>gs :Gstatus<CR>
        nnoremap <leader>gc :Gcommit -v -q<CR>
        nnoremap <leader>gca :Gcommit -a<CR>
        nnoremap <leader>gt :Gcommit -v -q %:p<CR>
        nnoremap <leader>gd :Gdiff<CR>
        nnoremap <leader>gid :Git diff --no-ext-diff --cached<CR>
        nnoremap <leader>gb :Gblame<CR>
        nnoremap <leader>gr :Gread<CR>
        nnoremap <leader>gw :Gwrite<CR>
        nnoremap <leader>gfr :Git pull --rebase<CR>
        nnoremap <leader>gp :Git push<CR>
        nnoremap <leader>gpf :Git push --force<CR>
    - require:
      - git: vim_fugitive
      - file: {{ home }}/.vimrc.d
