{%- from 'macros.jinja2' import user, home %}

include:
  - brew
  - zsh

helm:
  pkg:
    - installed
    - name: kubernetes-helm
    - require:
      - cmd: brew
  cmd:
    - wait
    - user: {{ user }}
    - name: helm init
    - watch:
      - pkg: helm
  file:
    - managed
    - name: {{ home }}/.zshrc.d/helm.zsh
    - contents: |
        alias h="helm"
        alias hc="helm create"
        alias hd="helm delete --purge"
        alias hf="helm fetch"
        alias hg="helm get"
        alias hh="helm history"
        alias hi="helm install"
        alias hl="helm list"
        alias hp="helm package"
        alias hs="helm status"
        alias hu="helm upgrade"
    - require:
      - file: {{ home }}/.zshrc.d
