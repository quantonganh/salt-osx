{%- from 'macros.jinja2' import user, home %}

include:
  - brew
  - zsh

minikube:
  file:
    - managed
    - name: {{ home }}/.zshrc.d/minikube.zsh
    - contents: |
        #source <(minikube completion zsh)
        alias m="minikube"
        alias ma="minikube addons"
        alias mcf="minikube config"
        alias md="minikube delete"
        alias mi="minikube ip"
        alias ml="minikube logs"
        alias ms="minikube service"
    - user: {{ user }}
    - group: staff
    - mode: 644
    - show_diff: True
    - require:
      - file: {{ home }}/.zshrc.d
