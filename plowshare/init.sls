{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - brew
  - xquartz

plowshare:
  pkg:
    - installed
    - require:
      - cmd: brew
      - cmd: xquartz
