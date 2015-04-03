{%- set user = salt['cmd.run']('stat -f ''%Su'' /dev/console') %}
{%- set home = salt['user.info'](user)['home'] %}

docker_zsh_completion:
  file:
    - directory
    - name: {{ home }}/.zsh/completion
    - user: {{ user }}
    - group: staff
    - mode: 755
    - makedirs: True
  cmd:
    - wait
    - name: curl -L https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker > {{ home }}/.zsh/completion/_docker
    - watch:
      - file: docker_zsh_completion
