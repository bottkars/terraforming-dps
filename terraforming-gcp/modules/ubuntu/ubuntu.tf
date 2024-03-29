locals {
  ubuntu_name = "${var.ubuntu_name}-${var.ubuntu_instance}"

}
resource "google_compute_instance" "ubuntu" {
  zone         = var.instance_zone
  tags         = concat(
    var.target_tags,
    [local.ubuntu_name]
  )
  labels = merge(
    var.labels,
    {
      "environment" = var.environment
    },
  )
  boot_disk {
    auto_delete = true
    device_name = "ubuntu-jammy-1"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230616"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  enable_display      = true
  machine_type = "e2-medium"
  name         = "ubuntu"
  network_interface {
    network    = var.instance_network_name
    subnetwork = var.instance_subnetwork_name
  }
  metadata = {
    ssh-keys = "cloudadmin:${tls_private_key.ubuntu.public_key_openssh}"
  }


  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }
 deletion_protection = var.deletion_protection
}


resource "tls_private_key" "ubuntu" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

