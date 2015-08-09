{%- from "macros.jinja2" import user with context %}

include:
  - vim.pathogen

vim_syntastic:
  git:
    - latest
    - name: https://github.com/scrooloose/syntastic.git
    - target: {{ user.home }}/.vim/bundle/syntastic
    - user: {{ user.owner }}
    - unless: test -d {{ user.home }}/.vim/bundle/syntastic
  file:
    - accumulated
    - name: plugins
    - filename: {{ user.home }}/.vimrc
    - require_in:
      - file: vimrc
      - git: vim_syntastic
    - text: |
        " syntastic
        let g:syntastic_check_on_open=1
        let g:syntastic_python_checkers=['flake8']
        " end of syntastic
