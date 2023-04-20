



resource "google_service_account" "ddve-sa" {
  account_id   = "${local.ddve_name}-sa"
  display_name = "SA-${local.ddve_name}"

}

resource "google_storage_bucket_iam_member" "ddve_member" {
  bucket = google_storage_bucket.ddve-bucket.name
  role   = "projects/${var.gcp_project}/roles/${var.ddve_role_id}"
  member = "serviceAccount:${google_service_account.ddve-sa.email}"
}


resource "google_storage_bucket" "ddve-bucket" {
  name                     = "${local.ddve_name}-bucket"
  location                 = var.ddve_object_region
  force_destroy            = true
  public_access_prevention = "enforced"

}
