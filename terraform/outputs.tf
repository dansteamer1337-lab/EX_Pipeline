output "server_public_ip" {
  description = "Public IP address of the deployed Yandex Cloud VM"
  value       = yandex_compute_instance.app_server.network_interface[0].nat_ip_address
}

output "server_fqdn" {
  description = "FQDN of the compute instance"
  value       = yandex_compute_instance.app_server.fqdn
}

output "subnet_id" {
  description = "Subnet ID"
  value       = yandex_vpc_subnet.app_subnet.id
}

output "vpc_network_id" {
  description = "VPC Network ID"
  value       = yandex_vpc_network.app_network.id
}
