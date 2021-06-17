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
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}
provider "kubernetes" {
   load_config_file = "false"

   host     = google_container_cluster.primary.endpoint
   username = var.gke_username
   password = var.gke_password

   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
   client_key             = google_container_cluster.primary.master_auth.0.client_key
   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
 }
module "infra" {
  count             = var.create_infra ? 1 : 0 // terraform  >=0.13 only  
  source            = "./modules/infra"
  ENV_NAME          = var.ENV_NAME
  gcp_project       = var.gcp_project
  subnet_region     = var.gcp_region
  subnetwork_name   = var.gcp_subnetwork_name_1
  subnet_cidr_block = var.gcp_subnet_cidr_block_1
  network_name      = var.gcp_network
}
module "s2svpn" {
  count             = var.create_s2svpn ? 1 : 0 // terraform  >=0.13 only  
  source            = "./modules/s2svpn"
  ENV_NAME          = var.ENV_NAME
  gcp_project       = var.gcp_project
  subnet_region     = var.gcp_region
  subnetwork_name   = var.gcp_subnetwork_name_1
  subnet_cidr_block = var.gcp_subnet_cidr_block_1
  ike_shared_secret = var.vpn_shared_secret
  network_name      = var.gcp_network
  peer_ip           = var.vpn_wan_ip
  vpn_route_dest    = var.s2s_vpn_route_dest
}

module "ppdm" {
  count                    = var.create_ppdm ? 1 : 0 // terraform  >=0.13 only  
  source                   = "./modules/ppdm"
  depends_on               = [module.infra]
  instance_name            = var.PPDM_HOSTNAME
  instance_zone            = var.gcp_zone
  instance_network_name    = var.gcp_network
  instance_subnetwork_name = var.gcp_subnetwork_name_1
  instance_image           = var.PPDM_IMAGE
  instance_size            = "custom-8-32768" //don´t change this walue
}

module "ddve" {
  count                    = var.create_ddve ? 1 : 0 // terraform  >=0.13 only
  source                   = "./modules/ddve"
  depends_on               = [module.infra]
  instance_name            = var.DDVE_HOSTNAME
  instance_zone            = var.gcp_zone
  instance_network_name    = var.gcp_network
  instance_subnetwork_name = var.gcp_subnetwork_name_1
  instance_image           = var.DDVE_IMAGE
  instance_size            = var.DDVE_VM_SIZE
  instance_compute_disks   = var.DDVE_META_DISKS
}


module "gke" {
  count           = var.create_gke ? 1 : 0 // terraform  >=0.13 only
  source          = "./modules/gke"
  depends_on      = [module.infra]
  gcp_project     = var.gcp_project
  gke_num_nodes   = var.gke_num_nodes
  network_name    = var.gcp_network
  subnetwork_name = var.gcp_subnetwork_name_1
  region      = var.gcp_zone // selecting a zone will create a zonal cluster, a gegion a regionla cluster
}


