
# ========================resources.tf===============================

# -------------------------nginx1------------------------------

resource "yandex_compute_instance" "vm1" {
  name = "nginx1"
  hostname = "nginx1"
  platform_id = "standard-v3"
  zone = "ru-central1-a"
  resources {
    core_fraction = 20
    cores = 2
    memory = 4
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      description = "boot disk for nginx1"
      image_id = "${var.images["debian_12"]}"
      type = "network-hdd"
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.privat-subnet-1.id
    security_group_ids = [yandex_vpc_security_group.sg-privat.id]
    ip_address = "192.168.10.10"
    nat = false
  }

  metadata = {
    user-data = "${file("user-data.yaml")}"
  }
}


# -----------------------------nginx2--------------------------

resource "yandex_compute_instance" "vm2" {
  name = "nginx2"
  hostname = "nginx2"
  platform_id = "standard-v3"
  zone = "ru-central1-b"
  resources {
    core_fraction = 20
    cores = 2
    memory = 4
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = "${var.images["debian_12"]}"
      type = "network-hdd"
      size = 10
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.privat-subnet-2.id
    security_group_ids = [yandex_vpc_security_group.sg-privat.id]
    ip_address = "192.168.20.10"
    nat = false
  }

  metadata = {
    user-data = "${file("user-data.yaml")}"
  }
}

# -----------------------------elasticsearch--------------------------

resource "yandex_compute_instance" "vm3" {
  name = "elastic"
  hostname = "elastic"
  platform_id = "standard-v3"
  zone = "ru-central1-d"
  resources {
    core_fraction = 20
    cores = 2
    memory = 6
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      description = "boot disk for elastic"
      image_id = "${var.images["debian_12"]}"
      type = "network-hdd"
      size = 10
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.privat-subnet-3.id
    security_group_ids = [yandex_vpc_security_group.sg-privat.id]
    ip_address = "192.168.30.10"
    nat = false
  }

  metadata = {
    user-data = "${file("user-data.yaml")}"
  }
}

# -----------------------------zabbix--------------------------

resource "yandex_compute_instance" "vm4" {
  name = "zabbix"
  hostname = "zabbix"
  platform_id = "standard-v3"
  zone = "ru-central1-d"
  resources {
    core_fraction = 20
    cores = 2
    memory = 4
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      description = "boot disk for zabbix"
      image_id = "${var.images["debian_12"]}"
      type = "network-hdd"
      size = 10
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet-4.id
    security_group_ids = [yandex_vpc_security_group.sg-privat.id, yandex_vpc_security_group.sg-zabbix.id]
    ip_address = "192.168.40.3"
    nat = true
  }

  metadata = {
    user-data = "${file("user-data.yaml")}"
  }
}

# -----------------------------kibana--------------------------

resource "yandex_compute_instance" "vm5" {
  name = "kibana"
  hostname = "kibana"
  platform_id = "standard-v3"
  zone = "ru-central1-d"
  resources {
    core_fraction = 20
    cores = 2
    memory = 4
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      description = "boot disk for kibana"
      image_id = "${var.images["debian_12"]}"
      type = "network-hdd"
      size = 10
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet-4.id
    security_group_ids = [yandex_vpc_security_group.sg-kibana.id, yandex_vpc_security_group.sg-privat.id]
    ip_address = "192.168.40.4"
    nat = true
  }

  metadata = {
    user-data = "${file("user-data.yaml")}"
  }
}

# -----------------------------bastion--------------------------

resource "yandex_compute_instance" "vm6" {
  name = "bastion"
  hostname = "bastion"
  platform_id = "standard-v3"
  zone = "ru-central1-d"

  resources {
    core_fraction = 20
    cores = 2
    memory = 4
  }
  scheduling_policy {
    preemptible = true
  }
  boot_disk {
    initialize_params {
      image_id = "${var.images["Fedora_37"]}"
      type = "network-hdd"
      size = 10
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet-4.id
    security_group_ids = [yandex_vpc_security_group.sg-privat.id, yandex_vpc_security_group.sg-bastion.id]
    ip_address = "192.168.40.17"
    nat = true
  }


  metadata = {
    user-data = "${file("user-data.yaml")}"
  }
}
