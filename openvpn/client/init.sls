openvpn:
  module:
    - run
    - name: pkg.install
    - m_name: tuntap
    - taps: 'Caskroom/cask'
  pkg:
    - installed
    - require:
      - module: openvpn

