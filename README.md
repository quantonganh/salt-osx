# Salt OS X

A collection of salt states which can be used to install essential/useful apps and development environment on the OS X.

Sample pillar: https://github.com/quantonganh/pillar-osx

- Install: https://docs.saltstack.com/en/master/topics/installation/osx.html
- Config:

```
file_roots:
  base:
    - /path/to/salt-osx

pillar_roots:
  base:
    - /path/to/pillar-osx
```

- Test:

```
$ salt-call test.ping
local:
    True
```

- Dry run:

```
$ salt-call state.apply test=True
```
