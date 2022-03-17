data "template_file" "cb_init" {
  template = file("./couchbase/template/create-cluster.tpl")
}

data "template_file" "cb_add_node" {
  template = file("./couchbase/template/add-node.tpl")
  vars = {
    public_ip = google_compute_instance.master[0].network_interface.0.access_config.0.nat_ip
  }
}

resource "google_compute_instance" "master" {
  count        = 1
  name         = "couchbase${count.index + 1}"
  machine_type = var.nodes[count.index].machine_type
  zone         = var.nodes[count.index].zone
  tags         = var.nodes[count.index].tags

  metadata_startup_script = data.template_file.cb_init.rendered

  boot_disk {
    initialize_params {
      image = "${var.nodes[count.index].image_project}/${var.nodes[count.index].image_family}"
    }
  }

  network_interface {
    network = var.nodes[count.index].subnet

    access_config {
    }
  }
}

resource "google_compute_instance" "replicas" {
  count        = length(var.nodes) - 1
  name         = "couchbase${count.index + 2}"
  machine_type = var.nodes[count.index + 1].machine_type
  zone         = var.nodes[count.index + 1].zone
  tags         = var.nodes[count.index + 1].tags

  metadata_startup_script = data.template_file.cb_add_node.rendered

  boot_disk {
    initialize_params {
      image = "${var.nodes[count.index + 1].image_project}/${var.nodes[count.index + 1].image_family}"
    }
  }

  network_interface {
    network = var.nodes[count.index + 1].subnet

    access_config {
    }
  }
}

resource "google_compute_firewall" "rules" {
  project     = var.project_id
  name        = "couchbase-rule"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80", "8091"]
  }

  source_tags = []
  target_tags = ["couchbase-tag"]
}