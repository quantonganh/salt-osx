{%- from 'macros.jinja2' import user, home %}

include:
  - brew
  - zsh

kubectl:
  pkg:
    - installed
    - name: kubernetes-cli
    - require:
      - cmd: brew
  file:
    - managed
    - name: {{ home }}/.zshrc.d/kubectl.zsh
    - contents: |
        #source <(kubectl completion zsh)
        alias k="kubectl"
        alias kc="kubectl create"
        alias kd="kubectl describe"
        alias kdel="kubectl delete"
        alias ke="kubectl exec -it"
        alias kg="kubectl get"
        alias kl="kubectl logs"
        alias kr="kubectl run"
    - user: {{ user }}
    - group: staff
    - mode: 644
    - show_diff: True
    - require:
      - pkg: kubectl
      - file: {{ home }}/.zshrc.d
