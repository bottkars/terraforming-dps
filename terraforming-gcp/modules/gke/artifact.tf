resource "google_artifact_registry_repository" "docker-private" {
  location = var.region
  repository_id = "${var.gcp_project}-artifact"
  description   = "${var.gcp_project} Docker registry"
  format        = "DOCKER"
}