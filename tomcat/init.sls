tomcat:
  archive:
    - extracted
    - name: /opt/
    - source: http://mirrors.digipower.vn/apache/tomcat/tomcat-7/v7.0.47/bin/apache-tomcat-7.0.47.tar.gz
    - source_hash: md5=efbae77efad579b655ae175754cad3df
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/apache-tomcat-7.0.47
