
resource "tls_private_key" "ppdm" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "google_compute_instance" "ppdm" {
  machine_type = "custom-8-32768"
  name         = var.instance_name
  zone         = var.instance_zone
  tags         = [var.instance_name]

  boot_disk {
    initialize_params {
      size  = 98
      type  = "pd-ssd"
      image = "dellemc-ddve-public/powerprotect-boot-19-8-0-5"
    }
  }
  network_interface {
    network    = var.instance_network_name
    subnetwork = var.instance_subnetwork_name
//    access_config {
//      // Ephemeral IP
//    }
 
  }
  metadata = {
      ssh-keys = "admin:${tls_private_key.ppdm.public_key_openssh}"
  }

  
  lifecycle {
    ignore_changes = [attached_disk]
  }
    }
resource "google_compute_attached_disk" "vm_attached_disk" {
  disk        = google_compute_disk.data1.name
  device_name = "${var.instance_name}-vm-0-data1"
  instance    = google_compute_instance.ppdm.id
}

resource "google_compute_attached_disk" "vm_attached_disk2" {
  disk        = google_compute_disk.data2.name
  device_name = "${var.instance_name}-vm-0-data2"
  instance    = google_compute_instance.ppdm.id
}

resource "google_compute_attached_disk" "vm_attached_disk3" {
  disk        = google_compute_disk.data3.name
  device_name = "${var.instance_name}-vm-0-data3"
  instance    = google_compute_instance.ppdm.id
}

resource "google_compute_attached_disk" "vm_attached_disk4" {
  disk        = google_compute_disk.data4.name
  device_name = "${var.instance_name}-vm-0-data4"
  instance    = google_compute_instance.ppdm.id
}
resource "google_compute_attached_disk" "vm_attached_disk5" {
  disk        = google_compute_disk.data5.name
  device_name = "${var.instance_name}-vm-0-data5"
  instance    = google_compute_instance.ppdm.id
}
resource "google_compute_attached_disk" "vm_attached_disk6" {
  disk        = google_compute_disk.data6.name
  device_name = "${var.instance_name}-vm-0-data6"
  instance    = google_compute_instance.ppdm.id
}
resource "google_compute_disk" "data1" {
  name  = "${var.instance_name}-data1"
  type  = "pd-ssd"
  image = "dellemc-ddve-public/powerprotect-data1-19-8-0-5"
  size  = 498
  labels = {
    environment = "dev"
  }



}
resource "google_compute_disk" "data2" {
  name  = "${var.instance_name}-data2"
  type  = "pd-ssd"
  image = "dellemc-ddve-public/powerprotect-data2-19-8-0-5"
  size  = 10
  labels = {
    environment = "dev"
  }
}
resource "google_compute_disk" "data3" {
  name  = "${var.instance_name}-data3"
  type  = "pd-ssd"
  image = "dellemc-ddve-public/powerprotect-data3-19-8-0-5"
  size  = 10
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "data4" {
  name  = "${var.instance_name}-data4"
  type  = "pd-ssd"
  image = "dellemc-ddve-public/powerprotect-data4-19-8-0-5"
  size  = 5
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "data5" {
  name  = "${var.instance_name}-data5"
  type  = "pd-ssd"
  image = "dellemc-ddve-public/powerprotect-data5-19-8-0-5"
  size  = 5
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "data6" {
  name  = "${var.instance_name}-data6"
  type  = "pd-ssd"
  image = "dellemc-ddve-public/powerprotect-data6-19-8-0-5"
  size  = 5
  labels = {
    environment = "dev"
  }
}
