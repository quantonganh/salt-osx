{%- from "macros.jinja2" import user with context %}

include:
  - vim.pathogen

vim_supertab:
  git:
    - latest
    - name: https://github.com/ervandew/supertab.git
    - target: {{ user.home }}/.vim/bundle/supertab
    - user: {{ user.owner }}
    - unless: test -d {{ user.home }}/.vim/bundle/supertab
  file:
    - accumulated
    - name: plugins
    - filename: {{ user.home }}/.vimrc
    - require_in:
      - git: vim_supertab
      - file: vimrc
    - text: |
        " supertab
        let g:SuperTabDefaultCompletionType = "context"
        " end of supertab
