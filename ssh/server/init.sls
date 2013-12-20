remote-login:
  cmd:
    - run
    - name: systemsetup -setremotelogin on

only-these-users:
  cmd:
    - run
    - name: dscl . append /Groups/com.apple.access_ssh user git
