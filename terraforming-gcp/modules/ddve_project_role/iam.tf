resource "google_project_iam_custom_role" "ddve-role" {
  role_id     = var.ddve_role_id
  title       = "DDVE Role"
  description = "Oauth Role for Accessing Object Store"
  permissions = [
    "storage.buckets.get",
    "storage.buckets.update",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.list",
    "storage.objects.get",
    "storage.objects.update",
  ]
  lifecycle {
    prevent_destroy = false
  }
}
