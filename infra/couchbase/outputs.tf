output "result" {
  sensitive = false  
  value = {
    master   = google_compute_instance.master[0].network_interface.0.access_config.0.nat_ip,
    replicas = google_compute_instance.replicas[*].network_interface[*].access_config.0.nat_ip
  }
}