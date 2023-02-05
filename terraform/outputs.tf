output "ip_address" {
  value = google_compute_instance.vpn.network_interface[0].access_config[0].nat_ip
}

output "ssh_key_path" {
  value = local_file.ssh_private_key.filename
}
