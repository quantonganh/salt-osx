{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

vim_syntastic:
  git:
    - latest
    - name: https://github.com/scrooloose/syntastic.git
    - target: {{ home }}/.vim/bundle/syntastic
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/syntastic
  file:
    - accumulated
    - name: plugins
    - filename: {{ home }}/.vimrc
    - require_in:
      - file: vimrc
      - git: vim_syntastic
    - text: |
        " syntastic
        let g:syntastic_check_on_open=1
        let g:syntastic_python_checkers=['flake8']
        " end of syntastic
