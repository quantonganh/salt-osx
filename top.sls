{%- set states = salt['cp.list_states']() %}

base:
  '*':
  {%- for state in states -%}
    {%- if not state.endswith('.absent') and state != "top" %}
    - {{ state }}
    {%- endif -%}
  {%- endfor %}
