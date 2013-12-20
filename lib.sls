{#-

Author: Quan Tong Anh <tonganhquan.net@gmail.com>
Maintainer: Quan Tong Anh <tonganhquan.net@gmail.com>

-#}
{% macro convert_hostname_to_ip(hostname) -%}
  {% if salt['dig.A'](hostname) -%}
    {{ salt['dig.A'](hostname)[0] }}
  {% else -%}
    {{ hostname }}
  {%- endif %}
{%- endmacro %}
