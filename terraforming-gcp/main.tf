terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = var.gcp_credentials

  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}
module "infra" {
  source            = "./modules/infra"
  ENV_NAME          = var.ENV_NAME
  gcp_project       = var.gcp_project
  subnet_region     = var.gcp_region
  subnetwork_name   = var.subnetwork_name_1
  subnet_cidr_block = var.subnet_cidr_block_1
}

module "ppdm" {
  source                   = "./modules/ppdm"
  depends_on = [module.infra]
  instance_name            = var.ppdm_instance_name
  instance_zone            = var.gcp_zone
  instance_network_name    = "${var.ENV_NAME}-network"
  instance_subnetwork_name = var.subnetwork_name_1
}

module "ddve" {
  source                   = "./modules/ddve"
  depends_on = [module.infra]
  instance_name            = var.ddve_instance_name
  instance_zone            = var.gcp_zone
  instance_network_name    = "${var.ENV_NAME}-network"
  instance_subnetwork_name = var.subnetwork_name_1
}