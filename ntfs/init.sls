ntfs-3g:
  pkg:
    - installed

mount_ntfs:
  cmd:
    - run
    - user: quanta
    - name: sudo mv /sbin/mount_ntfs /sbin/mount_ntfs.orig
    - unless: test -f /sbin/mount_ntfs.orig
  file:
    - symlink
    - name: /sbin/mount_ntfs
    - target: /usr/local/Cellar/ntfs-3g/2014.2.15/sbin/mount_ntfs
    - require:
      - cmd: mount_ntfs

osxfuse:
  pkg:
    - installed
  cmd:
    - run
    - user: quanta
    - name: sudo /bin/cp -RfX /usr/local/Cellar/osxfuse/2.7.0/Library/Filesystems/osxfusefs.fs /Library/Filesystems/
    - require:
      - pkg: osxfuse

osxfuse_chmod:
  cmd:
    - run
    - user: quanta
    - name: sudo chmod +s /Library/Filesystems/osxfusefs.fs/Support/load_osxfusefs
    - require:
      - cmd: osxfuse
