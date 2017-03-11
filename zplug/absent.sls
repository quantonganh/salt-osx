{%- from "macros.jinja2" import user, home with context %}

{{ home }}/.zplug:
  file:
    - absent

{{ home }}/.zshrc.d/zplug.zsh:
  file:
    - absent
