# ---------------------------network----------------------------
resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

# ---------------------------subnet-web1----------------------------
resource "yandex_vpc_subnet" "privat-subnet-1" {
  name           = "privat-subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = [ "192.168.10.0/24" ]
  route_table_id = yandex_vpc_route_table.route_table.id
}

# ---------------------------subnet-web2----------------------------
resource "yandex_vpc_subnet" "privat-subnet-2" {
  name           = "privat-subnet-2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = [ "192.168.20.0/24" ]
  route_table_id = yandex_vpc_route_table.route_table.id
}

# ---------------------------subnet-l7-elastic----------------------------

resource "yandex_vpc_subnet" "privat-subnet-3" {
  name           = "privat-subnet-3"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = [ "192.168.30.0/24" ]
  route_table_id = yandex_vpc_route_table.route_table.id
}

# ---------------------------subnet-zabbix-kibana-bastion----------------------------

resource "yandex_vpc_subnet" "public-subnet-4" {
  name           = "public-subnet-4"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = [ "192.168.40.0/24" ]
}

# ---------------------------gateway_route_table----------------------------
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "route_table" {
  name       = "route-table"
  network_id = yandex_vpc_network.network-1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# ---------------------------target_group----------------------------


resource "yandex_alb_target_group" "target-1" {
  name      = "target-1"
  target {
    subnet_id = yandex_vpc_subnet.privat-subnet-1.id
    ip_address   = yandex_compute_instance.vm1.network_interface.0.ip_address
    }
  target {
    subnet_id = yandex_vpc_subnet.privat-subnet-2.id
    ip_address   = yandex_compute_instance.vm2.network_interface.0.ip_address
    }
}

# ---------------------------backend_group----------------------------
resource "yandex_alb_backend_group" "backend-group" {
  name      = "backend-group"

  http_backend {
    name    = "backend-1"
    weight  = 1
    port    = 80
    target_group_ids = [yandex_alb_target_group.target-1.id]
    
    load_balancing_config {
      panic_threshold = 0
    }    
    healthcheck {
      timeout = "1s"
      interval = "3s"
      healthy_threshold    = 3
      unhealthy_threshold  = 3 
      healthcheck_port     = 80
      http_healthcheck {
        path  = "/"
      }
    }
  }
}

# ---------------------------http_router----------------------------
resource "yandex_alb_http_router" "nginx-router" {
  name      = "nginx-router"
}

resource "yandex_alb_virtual_host" "virtual-host" {
  name                    = "virtual-host"
  http_router_id          = yandex_alb_http_router.nginx-router.id
  route {
    name                  = "vm-route"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend-group.id
      }
    }
  }
}    

# ---------------------------network_load_balancer----------------------------


resource "yandex_alb_load_balancer" "lb-1" {
  name = "lb-1"
  network_id  = yandex_vpc_network.network-1.id
  security_group_ids = [yandex_vpc_security_group.lb-1.id, yandex_vpc_security_group.sg-privat.id]  

  allocation_policy {
    location {
      zone_id   = "ru-central1-d"
      subnet_id = yandex_vpc_subnet.public-subnet-4.id 
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }    
    http {
      handler {
        http_router_id = yandex_alb_http_router.nginx-router.id
      }
    }
  }
}  

