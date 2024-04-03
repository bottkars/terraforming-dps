
locals {
  ppdm_image = {
    "19.15" = {
      projectId    = "dellemc-ddve-public"
      imageSKU     = "powerprotect"
      imageVersion = "19-15-0-17"
    }
    "19.16" = {
      projectId    = "dellemc-ddve-public"
      imageSKU     = "powerprotect"
      imageVersion = "19-16-0-11"
    }
  }
  ppdm_name = "${var.ppdm_name}-${var.ppdm_instance}"
}
resource "tls_private_key" "ppdm" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "google_compute_instance" "ppdm" {
  machine_type = var.instance_size
  name         = local.ppdm_name
  zone         = var.instance_zone
  tags         = concat(
    var.target_tags,
    [local.ppdm_name]
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
      size  = 98
      type  = "pd-ssd"
      image = "${local.ppdm_image[var.ppdm_version].projectId}/${local.ppdm_image[var.ppdm_version].imageSKU}-boot-${local.ppdm_image[var.ppdm_version].imageVersion}"
    }
  }
  network_interface {
    network    = var.instance_network_name
    subnetwork = var.instance_subnetwork_name
  }
  metadata = {
    ssh-keys = "admin:${tls_private_key.ppdm.public_key_openssh}"
  }

  lifecycle {
    ignore_changes = [attached_disk, boot_disk]
  }
}
resource "google_compute_attached_disk" "vm_attached_disk" {
  disk        = google_compute_disk.data1.name
  device_name = "${local.ppdm_name}-vm-0-data1"
  instance    = google_compute_instance.ppdm.id
}

resource "google_compute_attached_disk" "vm_attached_disk2" {
  disk        = google_compute_disk.data2.name
  device_name = "${local.ppdm_name}-vm-0-data2"
  instance    = google_compute_instance.ppdm.id
}

resource "google_compute_attached_disk" "vm_attached_disk3" {
  disk        = google_compute_disk.data3.name
  device_name = "${local.ppdm_name}-vm-0-data3"
  instance    = google_compute_instance.ppdm.id
}

resource "google_compute_attached_disk" "vm_attached_disk4" {
  disk        = google_compute_disk.data4.name
  device_name = "${local.ppdm_name}-vm-0-data4"
  instance    = google_compute_instance.ppdm.id
}
resource "google_compute_attached_disk" "vm_attached_disk5" {
  disk        = google_compute_disk.data5.name
  device_name = "${local.ppdm_name}-vm-0-data5"
  instance    = google_compute_instance.ppdm.id
}
resource "google_compute_attached_disk" "vm_attached_disk6" {
  disk        = google_compute_disk.data6.name
  device_name = "${local.ppdm_name}-vm-0-data6"
  instance    = google_compute_instance.ppdm.id
}
resource "google_compute_disk" "data1" {
  name  = "${local.ppdm_name}-data1"
  type  = "pd-ssd"
  image = "${local.ppdm_image[var.ppdm_version].projectId}/${local.ppdm_image[var.ppdm_version].imageSKU}-data1-${local.ppdm_image[var.ppdm_version].imageVersion}"
  size  = 498
  labels = merge(
    var.labels,
    {
      "instance"    = local.ppdm_name
      "environment" = var.environment
    },
  )
  lifecycle {
    ignore_changes = [image]
  }
}

resource "google_compute_disk" "data2" {
  name  = "${local.ppdm_name}-data2"
  type  = "pd-ssd"
  image = "${local.ppdm_image[var.ppdm_version].projectId}/${local.ppdm_image[var.ppdm_version].imageSKU}-data2-${local.ppdm_image[var.ppdm_version].imageVersion}"
  size  = 10
  labels = merge(
    var.labels,
    {
      "instance"    = local.ppdm_name
      "environment" = var.environment
    },
  )
  lifecycle {
    ignore_changes = [image]
  }
}
resource "google_compute_disk" "data3" {
  name  = "${local.ppdm_name}-data3"
  type  = "pd-ssd"
  image = "${local.ppdm_image[var.ppdm_version].projectId}/${local.ppdm_image[var.ppdm_version].imageSKU}-data3-${local.ppdm_image[var.ppdm_version].imageVersion}"
  size  = 10
  labels = merge(
    var.labels,
    {
      "instance"    = local.ppdm_name
      "environment" = var.environment
    },
  )
  lifecycle {
    ignore_changes = [image]
  }
}

resource "google_compute_disk" "data4" {
  name  = "${local.ppdm_name}-data4"
  type  = "pd-ssd"
  image = "${local.ppdm_image[var.ppdm_version].projectId}/${local.ppdm_image[var.ppdm_version].imageSKU}-data4-${local.ppdm_image[var.ppdm_version].imageVersion}"
  size  = 5
  labels = merge(
    var.labels,
    {
      "instance"    = local.ppdm_name
      "environment" = var.environment
    },
  )
  lifecycle {
    ignore_changes = [image]
  }
}

resource "google_compute_disk" "data5" {
  name  = "${local.ppdm_name}-data5"
  type  = "pd-ssd"
  image = "${local.ppdm_image[var.ppdm_version].projectId}/${local.ppdm_image[var.ppdm_version].imageSKU}-data5-${local.ppdm_image[var.ppdm_version].imageVersion}"
  size  = 5
  labels = merge(
    var.labels,
    {
      "instance"    = local.ppdm_name
      "environment" = var.environment
    },
  )
  lifecycle {
    ignore_changes = [image]
  }
}

resource "google_compute_disk" "data6" {
  name  = "${local.ppdm_name}-data6"
  type  = "pd-ssd"
  image = "${local.ppdm_image[var.ppdm_version].projectId}/${local.ppdm_image[var.ppdm_version].imageSKU}-data6-${local.ppdm_image[var.ppdm_version].imageVersion}"
  size  = 5
  labels = merge(
    var.labels,
    {
      "instance"    = local.ppdm_name
      "environment" = var.environment
    },
  )
  lifecycle {
    ignore_changes = [image]
  }
}
