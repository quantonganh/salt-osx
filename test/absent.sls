{% for file in salt['cmd.run']('ls /Users/quanta/salt.ulimit*') %}
{{ file }}:
  file:
    - absent
{% endfor %}
