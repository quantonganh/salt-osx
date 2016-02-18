{%- from "macros.jinja2" import user, home with context %}

include:
  - xhyve

xhyve-ubuntu:
  file:
    - directory
    - name: {{ home }}/xhyve/ubuntu
    - user: {{ user }}
    - group: staff
    - mode: 755
    - require:
      - file: xhyve

{%- set files = {
  "initrd.gz": {
    "source": "http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz",
    "md5": "5d0877c6e32b404608b9b7970fd204c4",
  },
  "linux": {
    "source": "http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux",
    "md5": "3830553e4d2e1e040238a4317911d8ed",
  },
  "mini.iso": {
    "source": "http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/mini.iso",
    "md5": "7297321c2fa6424417a548c85edd6e98",
  },
} %}

{%- for file, properties in files.iteritems() %}
{{ home }}/xhyve/ubuntu/{{ file }}:
  file:
    - managed
    - source: {{ properties['source'] }}
    - source_hash: md5={{ properties['md5'] }}
    - user: {{ user }}
    - group: staff
    - mode: 644
    - require:
      - file: xhyve-ubuntu
{%- endfor %}

xhyve-ubuntu-hard-disk:
  cmd:
    - run
    - name: dd if=/dev/zero of=hdd.img bs=1g count=8
    - user: {{ user }}
    - cwd: {{ home }}/xhyve/ubuntu
    - creates: {{ home }}/xhyve/ubuntu/hdd.img
    - require:
      - file: xhyve-ubuntu

{{ home }}/xhyve/ubuntu/install.sh:
  file:
    - managed
    - source: salt://xhyve/ubuntu/install.jinja2
    - template: jinja
    - user: {{ user }}
    - group: staff
    - mode: 755

/Library/LaunchDaemons/xhyve.ubuntu.plist:
  file:
    - managed
    - source: salt://xhyve/ubuntu/plist.jinja2
    - template: jinja
    - user: root
    - group: wheel
    - mode: 644
