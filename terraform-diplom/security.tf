# ----------------------------security groups---------------------------
# -------------privat------------
resource "yandex_vpc_security_group" "sg-privat" {
  name       = "sg-privat"
  description = "for subnets"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "ANY"
    description    = "Allow any from sg-privat subnets"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24", "192.168.30.0/24", "192.168.40.0/24"]
  }

  egress {
    protocol       = "ANY"
    description    = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------bastion------------
resource "yandex_vpc_security_group" "sg-bastion" {
  name        = "sg-bastion"
  description = "for bastion ssh"
  network_id  = "${yandex_vpc_network.network-1.id}"  

  ingress {
      description       = "Allow SSH"
      protocol          = "TCP"
      port              = 22
      v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow ping"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      description       = "Permit ANY"
      protocol          = "ANY"
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
}


# -------------zabbix------------
resource "yandex_vpc_security_group" "sg-zabbix" {
  name        = "sg-zabbix"
  description = "for zabbix"
  network_id  = "${yandex_vpc_network.network-1.id}"  

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    port           = "80"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Allow zabbix-agent"
    protocol       = "TCP"
    port           = "10051"
    v4_cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description    = "Allow ping"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"] 
  }
}

# -------------kibana------------
resource "yandex_vpc_security_group" "sg-kibana" {
  name        = "sg-kibana"
  description = "for kibana"
  network_id  = "${yandex_vpc_network.network-1.id}"  

  ingress {
    description    = "Allow Zabbix-server"
    protocol       = "TCP"
    port           = "10050"
    v4_cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description    = "Allow kibana"
    protocol       = "TCP"
    port           = "5601"
    v4_cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    protocol       = "ICMP"
    description    = "allow ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"] 
  }
}

# -------------load_balancer------------
resource "yandex_vpc_security_group" "lb-1" {
  name       = "lb-1"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    description       = "Health checks"
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    predefined_target = "loadbalancer_healthchecks"
  }

  ingress {
    description    = "Allow HTTP"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    description    = "Allow ping"
    protocol       = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
