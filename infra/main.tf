provider "google" {
  project     = var.gcp_project_id
}

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.1.0"
    }
  }
  required_version = "1.1.7"
}

module "couchbase" {
  source           = "./couchbase"
  nodes            = local.nodes
  project_id       = var.gcp_project_id
}