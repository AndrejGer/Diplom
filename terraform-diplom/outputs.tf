# -------------------------ip_bastion------------------------------
output "external_ip_address_vm6_bastion" {
  value = yandex_compute_instance.vm6.network_interface.0.nat_ip_address
}
output "internal_ip_address_vm6_bastion" {
  value = yandex_compute_instance.vm6.network_interface.0.ip_address
}
output "fqdn_vm6_bastion" {
  value = yandex_compute_instance.vm6.fqdn
}

output "external_ip_address_vm4_zabbix" {
  value = yandex_compute_instance.vm4.network_interface.0.nat_ip_address
}
output "internal_ip_address_vm4_zabbix" {
  value = yandex_compute_instance.vm4.network_interface.0.ip_address
}
output "fqdn_vm4_zabbix" {
  value = yandex_compute_instance.vm4.fqdn
}

output "external_ip_address_vm5_kibana" {
  value = yandex_compute_instance.vm5.network_interface.0.nat_ip_address
}
output "internal_ip_address_vm5_kibana" {
  value = yandex_compute_instance.vm5.network_interface.0.ip_address
}
output "fqdn_vm4_kibana" {
  value = yandex_compute_instance.vm5.fqdn
}

output "internal_ip_address_vm3_elastic" {
  value = yandex_compute_instance.vm3.network_interface.0.ip_address
}
output "fqdn_elastic" {
  value = yandex_compute_instance.vm3.fqdn
}

output "internal_ip_address_vm1_nginx1" {
  value = yandex_compute_instance.vm1.network_interface.0.ip_address
}
output "fqdn_vm1" {
  value = yandex_compute_instance.vm1.fqdn
}

output "internal_ip_address_vm2_nginx2" {
  value = yandex_compute_instance.vm2.network_interface.0.ip_address
}
output "fqdn_vm2" {
  value = yandex_compute_instance.vm2.fqdn
}

output "external_ip_address_L7balancer" {
  value = yandex_alb_load_balancer.lb-1.listener.0.endpoint.0.address.0.external_ipv4_address
}
