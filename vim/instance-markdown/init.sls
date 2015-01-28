npm:
  pkg:
    - installed

instant-markdown-d:
  cmd:
    - run
    - name: sudo npm -g install instant-markdown-d
    - require:
      - pkg: npm


