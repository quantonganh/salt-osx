brew:
  cmd:
    - run
    - name: ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    - unless: test -x /usr/local/bin/brew
