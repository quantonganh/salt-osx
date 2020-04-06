{%- set key = salt['pillar.get']('aws:key') -%}
{%- set secret = salt['pillar.get']('aws:secret') %}
{%- set subnets = salt['pillar.get']('vpc:subnets') %}

aws_import_key_pair:
   boto_ec2:
    - key_present
    - name: salt
    - upload_public: salt://aws/id_rsa.pub
    - keyid: {{ key }}
    - key: "{{ secret }}"

aws_iam_role:
  boto_iam_role:
    - present
    - name: devops
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
    - policies:
        Infrastructure:
          Statement:
            - Action:
                - ec2:*
                - elasticloadbalancing:*
                - cloudwatch:*
                - autoscaling:*
                - route53:*
                - route53domains:*
                - iam:*
                - s3:*
              Effect: Allow
              Resource: "*"

{%- for group, config in salt['pillar.get']('iam:groups', {}).iteritems() %}
  {%- for user in config['users'] %}
aws_iam_{{ user }}_user:
  boto_iam:
    - user_present
    - name: {{ user }}
    - policies:
        AllowAllPolicy:
          Statement:
            - Action: "*"
              Effect: Allow
              Resource: "*"
    - password: {{ config['users'][user] }}
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
    - require_in:
      - boto_iam: aws_iam_{{ group }}_group
  {%- endfor %}

aws_iam_{{ group }}_group:
  boto_iam:
    - group_present
    - name: {{ group }}
    - users:
  {%- for user in config['users'] %}
      - {{ user }}
  {%- endfor %}
    - policies:
        AllowAllPolicy:
          Statement:
            - Action: "*"
              Effect: Allow
              Resource: "*"
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
{%- endfor %}

{%- set vpc_name = 'Weldai' %}

aws_singapore:
  boto_vpc:
    - present
    - name: {{ vpc_name }}
    - cidr_block: {{ salt['pillar.get']('vpc:cidr_block') }}
    - dns_hostnames: True
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
  boto_secgroup:
    - present
    - name: Gateway
    - description: Gateway VPC security group
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
    - vpc_name: {{ vpc_name }}
    - rules:
      - ip_protocol: tcp
        from_port: 22
        to_port: 22
        cidr_ip:
          - 0.0.0.0/0
      - ip_protocol: tcp
        from_port: 22022
        to_port: 22022
        cidr_ip:
          - 0.0.0.0/0
      - ip_protocol: udp
        from_port: 1194
        to_port: 1194
        cidr_ip:
          - 0.0.0.0/0
    - require:
      - boto_vpc: aws_singapore

aws_ec2_network:
  module:
    - run
    - name: boto_ec2.create_network_interface
    - m_name: Gateway
    - subnet_id: Public
    - private_ip_address: 172.16.0.4
    - description: Gateway
    - groups: ['Gateway']
    - require:
      - boto_secgroup: aws_singapore

{%- if subnets %}
  {%- for subnet in subnets %}
aws_vpc_{{ subnet }}_subnet:
  boto_vpc:
    - subnet_present
    - name: {{ subnet }}
    - vpc_name: {{ vpc_name }}
    - cidr_block: {{ salt['pillar.get']('vpc:subnets:' ~ subnet ~ ':cidr_block') }}
    - availability_zone: {{ salt['pillar.get']('vpc:subnets:' ~ subnet ~ ':availability_zone')  }}
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
    - require:
      - boto_vpc: aws_singapore
  {%- endfor %}
{%- endif %}

aws_vpc_gateway:
  boto_vpc:
    - internet_gateway_present
    - name: Weldai
    - vpc_name: {{ vpc_name }}
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
    - require:
      - boto_vpc: aws_singapore

aws_vpc_route:
  boto_vpc:
    - route_table_present
    - name: Public
    - vpc_name: {{ vpc_name }}
    - routes:
      - destination_cidr_block: 0.0.0.0/0
        internet_gateway_name: Weldai
    - subnet_names:
      - Public
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
    - require:
      - boto_vpc: aws_vpc_Public_subnet
      - boto_vpc: aws_vpc_gateway

aws_rds_subnet_group:
  boto_rds:
    - subnet_group_present
    - name: private-a-sg
    - description: "subnet group for the Private-A and Private-B"
    - subnet_names:
{%- if subnets %}
  {%- for subnet in subnets %}
    {%- if subnet.startswith('Private-') %}
      - {{ subnet }}
    {%- endif %}
  {%- endfor %}
{%- endif %}
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
{%- if subnets %}
    - require:
  {%- for subnet in subnets %}
      - boto_vpc: aws_vpc_{{ subnet  }}_subnet
  {%- endfor %}
{%- endif %}

{%- for engine, config in salt['pillar.get']('rds:engines', {}).iteritems() %}
aws_{{ engine }}_rds:
  boto_rds:
    - present
    - name: {{ engine }}-rds
    - allocated_storage: 5
    - db_instance_class: db.t2.micro
    - engine: {{ engine }}
    - master_username: {{ config['username'] }}
    - master_user_password: {{ config['password'] }}
    - db_subnet_group_name: private-a-sg
    - region: ap-southeast-1
    - keyid: {{ key }}
    - key: "{{ secret }}"
    - require:
      - boto_rds: aws_rds_subnet_group
{%- endfor %}
