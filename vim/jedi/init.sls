{%- from "macros.jinja2" import user, home with context %}

include:
  - vim.pathogen

https://github.com/davidhalter/jedi-vim.git:
  git:
    - latest
    - target: {{ home }}/.vim/bundle/jedi-vim
    - user: {{ user }}
    - unless: test -d {{ home }}/.vim/bundle/jedi-vim

jedi-submodule:
  module:
    - run
    - cwd: {{ home }}/.vim/bundle/jedi-vim
    - name: git.submodule
    - user: {{ user }}
    - require:
      - git: https://github.com/davidhalter/jedi-vim.git
