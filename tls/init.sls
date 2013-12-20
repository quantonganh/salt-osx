include:
  - pyopenssl

tls:
  module:
    - run 
    - name: tls.create_self_signed_cert
    - C: VN
    - ST: HN
    - L: Hanoi
    - O: Home
    - OU: DevOps
    - require:
      - module: pyopenssl
