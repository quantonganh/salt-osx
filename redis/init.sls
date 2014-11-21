redis:
  pkg:
    - installed
  module:
    - run
    - name: pip.install
    - pkgs: redis
    - bin_env: /usr/local/bin/pip
  file:
    - symlink
    - name: /Users/quanta/Library/LaunchAgents/homebrew.mxcl.redis.plist
    - target: /usr/local/opt/redis/homebrew.mxcl.redis.plist
    - require:
      - file: /usr/local/opt/redis/homebrew.mxcl.redis.plist
  cmd:
    - run
    - name: launchctl load -w /Users/quanta/Library/LaunchAgents/homebrew.mxcl.redis.plist

/usr/local/opt/redis/homebrew.mxcl.redis.plist:
  file:
    - managed
    - user: root
    - require:
      - pkg: redis
