{%- from 'macros.jinja2' import user, home %}

include:
  - zsh.prezto.absent

zim:
  git:
    - latest
    - user: {{ user }}
    - submodules: True
    - name: https://github.com/Eriner/zim.git
    - target: {{ home }}/.zim
  cmd:
    - wait_script
    - user: {{ user }}
    - shell: /bin/zsh
    - name: salt://zsh/zim/copy_templates.zsh
    - require:
      - file: prezto
    - watch:
      - git: zim
  file:
    - replace
    - name: {{ home }}/.zimrc
    - pattern: zprompt_theme='steeef'
    - repl: zprompt_theme='minimal'
    - require:
      - cmd: zim
