locals {
  ddve_ssd = {
    "Cost Optimized" = {
      disk_type = "pd-balanced"
    }
    "Performance Optimized" = {
      disk_type = "pd-balanced"
    }
  }
  ddve_size = {
    "16 TB DDVE" = {
      ddve_metadata_volume_count = 2
      ddve_disksize              = 1000
      instance_type              = "e2-standard-4"
    }
    "32 TB DDVE" = {
      ddve_metadata_volume_count = 4
      ddve_disksize              = 1000
      instance_type              = "e2-standard-8"
    }
    "96 TB DDVE" = {
      ddve_metadata_volume_count = 10
      ddve_disksize              = 1000
      instance_type              = "e2-standard-16"
    }
    "256 TB DDVE" = {
      ddve_metadata_volume_count = 13
      ddve_disksize              = 2000
      instance_type              = "e2-standard-32"
    }

  }
  ddve_image = {
    "7.12.0.0" = {
      projectId = "dellemc-ddve-public"
      imageName = "ddve-gcp-7-12-0-0-1053185"
    }    
    "7.11.0.0" = {
      projectId = "dellemc-ddve-public"
      imageName = "ddve-gcp-7-11-0-0-1035502"
    }
    "7.10.0.0" = {
      projectId = "dellemc-ddve-public"
      imageName = "ddve-gcp-7-10-0-0-1017741"
    }
    "7.9.0.0" = {
      projectId = "dellemc-ddve-public"
      imageName = "ddve-gcp-7-9-0-0-1011258"
    }
    "7.8.0.20" = {
      projectId = "dellemc-ddve-public"
      imageName = "ddve-gcp-7-8-0-20-1011246"
    }
    "7.7.4.0" = {
      projectId = "dellemc-ddve-public"
      imageName = "ddve-gcp-7-7-4-0-1017976"
    }
  }
  ddve_name = "${var.ddve_name}-${var.ddve_instance}"
}
//data "google_compute_image" "ddve_image" {
//  family  = "debian-11"
//  project = "dellemc-ddve-public"
//}

resource "tls_private_key" "ddve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "google_compute_instance" "ddve" {
  machine_type = local.ddve_size[var.ddve_type].instance_type
  name         = local.ddve_name
  zone         = var.instance_zone
  tags = concat(
    var.ddve_target_tags,
    [local.ddve_name]
  )
  labels = merge(
    var.labels,
    {
      "instance"    = local.ddve_name
      "environment" = var.environment
    },
  )
  allow_stopping_for_update = true
  enable_display            = true
  boot_disk {
    initialize_params {
      size  = 250
      type  = "pd-ssd"
      image = "${local.ddve_image[var.ddve_version].projectId}/${local.ddve_image[var.ddve_version].imageName}"
    }
  }
  attached_disk {
    source      = google_compute_disk.nvram.name
    device_name = "${local.ddve_name}-nvram"
  }
  network_interface {
    network    = var.instance_network_name
    subnetwork = var.instance_subnetwork_name
  }
  metadata = {
    ssh-keys = "sysadmin:${tls_private_key.ddve.public_key_openssh}"
  }

  service_account {
    email  = data.google_service_account.ddve-sa.email
    scopes = ["cloud-platform"]
  }
  lifecycle {
    ignore_changes = [attached_disk,
    boot_disk]
  }
//  depends_on = [ google_storage_bucket.ddve-bucket ]
}

resource "google_compute_disk" "nvram" {
  name = "${local.ddve_name}-nvram"
  type = "pd-ssd"
  size = 10
  zone = var.instance_zone
  labels = merge(
    var.labels,
    {
      "instance"    = local.ddve_name
      "environment" = var.environment
    },
  )
}





resource "google_compute_disk" "metadatadisk" {
  count = local.ddve_size[var.ddve_type].ddve_metadata_volume_count
  name  = "${local.ddve_name}-metadatadisk-${count.index + 1}"
  size  = local.ddve_size[var.ddve_type].ddve_disksize
  type  = local.ddve_ssd[var.ddve_disk_type].disk_type
  zone  = var.instance_zone
  labels = merge(
    var.labels,
    {
      "instance"    = local.ddve_name
      "environment" = var.environment
    },
  )
}


resource "google_compute_attached_disk" "vm_attached_metadatadisk" {
  count       = local.ddve_size[var.ddve_type].ddve_metadata_volume_count
  device_name = "${local.ddve_name}-metadata-${count.index + 1}"
  disk        = google_compute_disk.metadatadisk[count.index].name
  instance    = google_compute_instance.ddve.self_link
  lifecycle {
    ignore_changes = [device_name]
  }
}
