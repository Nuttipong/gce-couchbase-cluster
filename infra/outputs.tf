output "data" {
  sensitive = false
  value = {
    ip             = module.couchbase.result.master,
    replicas-ip    = module.couchbase.result.replicas
  }
}