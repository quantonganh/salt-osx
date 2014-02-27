{% from 'lib.sls' import debmirror with context %}

{#- This macro should be called in the following order
  debmirror(arch,
            section,
            server,
            release,
            in_path,
            proto,
            out_path,
            **kwargs)
-#}

{{ debmirror('i386,amd64', 'main,restricted,universe,multiverse', 'ppa.launchpad.net', 'precise', '/saltstack/salt/ubuntu', 'http', '/saltmirror', key_url='http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6', gnupghome='/home/mirrorkeyring') }}
