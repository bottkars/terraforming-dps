
resource "random_string" "storage_bucket_name" {
  length  = 16
  special = false
  upper   = false
}


data "google_service_account" "ddve-sa" {
  account_id = var.ddve_sa_account_id
}

resource "google_storage_bucket_iam_member" "ddve_member" {
  bucket = google_storage_bucket.ddve-bucket.name
  role   = var.ddve_role_id
  # "projects/${var.gcp_project}/roles/${var.ddve_role_id}"
  member = data.google_service_account.ddve-sa.member
}


resource "google_storage_bucket" "ddve-bucket" {
  name                     = "${local.ddve_name}-bucket-${random_string.storage_bucket_name.result}"
  location                 = var.ddve_object_region
  force_destroy            = true
  public_access_prevention = "enforced"
  uniform_bucket_level_access = true
}
