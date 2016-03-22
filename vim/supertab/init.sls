{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

vim_supertab:
  git:
    - latest
    - name: https://github.com/ervandew/supertab.git
    - target: {{ home }}/.vim/bundle/supertab
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/supertab
  file:
    - accumulated
    - name: plugins
    - filename: {{ home }}/.vimrc
    - require_in:
      - git: vim_supertab
      - file: vimrc
    - text: |
        " supertab
        let g:SuperTabDefaultCompletionType = "context"
        " end of supertab
