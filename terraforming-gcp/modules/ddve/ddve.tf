resource "tls_private_key" "ddve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "google_compute_instance" "ddve" {
  machine_type = var.instance_size
  name         = var.instance_name
  zone         = var.instance_zone
  tags         = [var.instance_name]

  boot_disk {
    initialize_params {
      size  = 250
      type  = "pd-ssd"
      image = "${var.instance_image.publisher}/${var.instance_image.sku}-${var.instance_image.version}"
    }
  }
  attached_disk {
    source        = google_compute_disk.nvram.name
    device_name = "${var.instance_name}-vm-${var.ddve_instance}-nvram"
//    instance    = google_compute_instance.ddve.id
  }
  network_interface {
    network    = var.instance_network_name
    subnetwork = var.instance_subnetwork_name
    //    access_config {
    //      // Ephemeral IP
    //    }

  }
  metadata = {
    ssh-keys = "sysadmin:${tls_private_key.ddve.public_key_openssh}"
  }


  lifecycle {
    ignore_changes = [attached_disk]
  }
}

resource "google_compute_disk" "nvram" {
  name = "${var.instance_name}-nvram"
  type = "pd-ssd"
  size = 10
  zone = var.instance_zone
  labels = {
    environment = "dev"
  }
}

//resource "google_compute_attached_disk" "vm_attached_disk_nvram" {
//  disk        = google_compute_disk.nvram.name
//  device_name = "${var.instance_name}-vm-${var.ddve_instance}-nvram"
//  instance    = google_compute_instance.ddve.id

//}



resource "google_compute_disk" "metadatadisk" {

    count = length(var.instance_compute_disks)
    name     = "${var.instance_name}-metadatadisk-${count.index + 1}"
    size     = var.instance_compute_disks[count.index]
    type     = "pd-ssd"
    zone     = var.instance_zone
  }


resource "google_compute_attached_disk" "vm_attached_metadatadisk" {
count = length(var.instance_compute_disks)
    device_name = "${var.instance_name}-vm-${var.ddve_instance}-metadata-${count.index + 1}"
    disk        = google_compute_disk.metadatadisk[count.index].name
    instance    = google_compute_instance.ddve.self_link
  }
