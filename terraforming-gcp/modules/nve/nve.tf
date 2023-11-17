
locals {
  nve_size = {
    "small" = {
      nve_data_volume_count = 1
      nve_disksize          = 600
      instance_type         = "e2-standard-4"
    }
    "medium" = {
      nve_data_volume_count = 1
      nve_disksize          = 1200
      instance_type         = "e2-standard-4"
    }
    "large" = {
      nve_data_volume_count = 1
      nve_disksize          = 2400
      instance_type         = "e2-standard-8"
    }


  }
    nve_image = {
    "19.9" = {
      projectId    = "dellemc-ddve-public"
      imageSKU     = "networker-virtual-edition"
      imageVersion = "19900-build-15010-052023"
    }

    "19.8" = {
      projectId    = "dellemc-ddve-public"
      imageSKU     = "networker-virtual-edition"
      imageVersion = "rtm198-nw40-nve23"
    }
    "19.7" = {
      projectId    = "dellemc-ddve-public"
      imageSKU     = "networker-virtual-edition"
      imageVersion = "rtm197-nw35-nve28"
    }
  }
  nve_name = "${var.nve_name}-${var.nve_instance}"

}

resource "tls_private_key" "nve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "google_compute_instance" "nve" {
  machine_type = local.nve_size[var.nve_type].instance_type
  name         = local.nve_name
  zone         = var.instance_zone
  tags = concat(
    var.target_tags,
    [local.nve_name]
  )
  labels = merge(
    var.labels,
    {
      "environment" = var.environment
    },
  )
  allow_stopping_for_update = true
  enable_display            = true
  boot_disk {
    initialize_params {
      size  = 126
      type  = "pd-ssd"
      image = "${local.nve_image[var.nve_version].projectId}/${local.nve_image[var.nve_version].imageSKU}-${local.nve_image[var.nve_version].imageVersion}"
    }
  }
  network_interface {
    network    = var.instance_network_name
    subnetwork = var.instance_subnetwork_name
  }
  metadata = {
    ssh-keys = "admin:${tls_private_key.nve.public_key_openssh}"
  }

  lifecycle {
    ignore_changes = [attached_disk, boot_disk]
  }
}


resource "google_compute_disk" "datadisk" {
  count = local.nve_size[var.nve_type].nve_data_volume_count
  name  = "${local.nve_name}-datadisk-${count.index + 1}"
  size  = local.nve_size[var.nve_type].nve_disksize
  type  = "pd-ssd"
  zone  = var.instance_zone
  labels = merge(
    var.labels,
    {
      "instance"    = local.nve_name
      "environment" = var.environment
    },
  )
}


resource "google_compute_attached_disk" "vm_attached_datadisk" {
  count       = local.nve_size[var.nve_type].nve_data_volume_count
  device_name = "${local.nve_name}-data-${count.index + 1}"
  disk        = google_compute_disk.datadisk[count.index].name
  instance    = google_compute_instance.nve.self_link
  lifecycle {
    ignore_changes = [device_name]
  }
}

