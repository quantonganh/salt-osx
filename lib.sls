{#-
Copyright (c) 2013, Quan Tong Anh
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Quan Tong Anh <tonganhquan.net@gmail.com>
Maintainer: Quan Tong Anh <tonganhquan.net@gmail.com>

This macro is used to create a local repository mirror with debmirror.
-#}
{%- macro debmirror(arch, section, server, release, in_path, proto, out_path) -%}
{%- for package in ('debmirror', 'wget', 'gnupg') %}
{{ package }}:
  pkg:
    - installed
{%- endfor %}

{%- set gnupghome = kwargs.pop('gnupghome', '/root/.gnupg') %}
{%- set env = { 'GNUPGHOME': gnupghome } %}
keyring_import:
  cmd:
    - run
{%- if 'keyid' in kwargs and 'keyserver' in kwargs %}
    {%- set keyid = kwargs.pop('keyid', None) %}
    {%- set keyserver = kwargs.pop('keyserver', None) %}
    - name: 'gpg --no-default-keyring --keyring {{ gnupghome }}/trustedkeys.gpg --keyserver {{ keyserver }} --recv-keys {{ keyid }}'
{%- elif 'key_url' in kwargs %}
    {%- set key_url = kwargs.pop('key_url') %}
    - name: 'wget -q -O- "{{ key_url }}" | gpg --no-default-keyring --keyring {{ gnupghome }}/trustedkeys.gpg --import'
{%- endif %}
    - require:
      - pkg: wget
      - pkg: gnupg

salt_mirror:
  cmd:
    - run
    - name: 'debmirror -a {{ arch }} --no-source -s {{ section }} -h {{ server }} -d {{ release }} -r {{ in_path }} --progress -e {{ proto }} {{ out_path }}'
    - env: { 'GNUPGHOME': {{ gnupghome }} }
    - require:
      - pkg: debmirror
      - cmd: keyring_import
{%- endmacro %}
