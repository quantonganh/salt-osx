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
        alias ka="kubectl apply"
        alias kas="kubectl autoscale"
        alias kc="kubectl create"
        alias kcf="kubectl config"
        alias kcp="kubectl cp"
        alias kd="kubectl describe"
        alias kdel="kubectl delete"
        alias ke="kubectl exec -it"
        alias ked="kubectl edit"
        alias kep="kubectl expose"
        alias kg="kubectl get"
        alias kl="kubectl logs"
        alias kp="kubectl patch"
        alias kpf="kubectl port-forward"
        alias kr="kubectl run"
        alias kro="kubectl rollout"
        alias ks="kubectl scale"
        alias ku="kubectl replace"
        alias kx="kubectl expose"
    - user: {{ user }}
    - group: staff
    - mode: 644
    - show_diff: True
    - require:
      - pkg: kubectl
      - file: {{ home }}/.zshrc.d
