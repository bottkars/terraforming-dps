provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
  # expect to use with env vars, otherwise derive from vars  ...
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  environment     = var.environment
}



module "infra" {
  source = "./modules/infra"
  ENV_NAME                           = var.ENV_NAME
  location                           = var.location
  dns_suffix                         = var.dns_suffix
  dps_infrastructure_subnet          = var.dps_infrastructure_subnet
  dps_aks_subnet                     = var.dps_aks_subnet
  dps_tkg_workload_subnet            = var.dps_tkg_workload_subnet
  dps_tkg_controlplane_subnet        = var.dps_tkg_controlplane_subnet
  dps_azure_bastion_subnet           = var.dps_azure_bastion_subnet
  dps_virtual_network_address_space  = var.dps_virtual_network_address_space
  dps_enable_tkg_workload_subnet     = var.tkg_workload_subnet
  dps_enable_tkg_controlplane_subnet = var.tkg_controlplane_subnet
  dps_enable_aks_subnet              = var.aks_subnet
}
/*
uncomment next block to add ave
*/

/*
module "ave" {
  source = "./modules/ave"
  AVE_IMAGE = var.AVE_IMAGE
  ave_hostname = var.AVE_HOSTNAME
  ave_gsan_disks = var.ave_gsan_disks
  ave_initial_password = var.ave_initial_password
  ave_private_ip = var.ave_private_ip
  ENV_NAME = var.ENV_NAME
  location = var.location
  ave_vm_size    = var.ave_vm_size
  resource_group_name = module.infra.resource_group_name
  dns_zone_name       = module.infra.dns_zone_name
 # security_group_id   = module.infra.ave_security_group_id
  subnet_id           = module.infra.infrastructure_subnet_id
  public_ip             = var.AVE_PUBLIC_IP
}
*/
/* Module NVE starts here */
module "nve" {
  source = "./modules/nve"
  nve_image = var.NVE_IMAGE
  nve_hostname = var.NVE_HOSTNAME
  nve_data_disks = var.NVE_DATA_DISKS
  nve_initial_password = var.NVE_INITIAL_PASSWORD
  nve_private_ip = var.NVE_PRIVATE_IP
  ENV_NAME = var.ENV_NAME
  location = var.location
  nve_vm_size    = var.NVE_VM_SIZE
  nve_tcp_inbound_rules_Inet = var.NVE_TCP_INBOUND_RULES_INET  
  public_ip           = var.NVE_PUBLIC_IP  
  resource_group_name = module.infra.resource_group_name
  dns_zone_name       = module.infra.dns_zone_name
  subnet_id           = module.infra.infrastructure_subnet_id
}

/* Module NVE ends here */
/* uncomment next block for ddve */
module "ddve" {
#   count = var.ddve ? 1 : 0 terraform 0.13 only
  source                = "./modules/ddve"
  ddve_image            = var.DDVE_IMAGE
  ddve_hostname         = var.DDVE_HOSTNAME
  ddve_meta_disks       = var.DDVE_META_DISKS
  ddve_initial_password = var.DDVE_INITIAL_PASSWORD
  ddve_tcp_inbound_rules_Inet = var.DDVE_TCP_INBOUND_RULES_INET
  ddve_private_ip       = var.DDVE_PRIVATE_IP
  ENV_NAME              = var.ENV_NAME
  location              = var.location
  ddve_vm_size          = var.DDVE_VM_SIZE
  resource_group_name   = module.infra.resource_group_name
  dns_zone_name         = module.infra.dns_zone_name
  subnet_id             = module.infra.infrastructure_subnet_id
  public_ip             = var.DDVE_PUBLIC_IP
  ddve_ppdd_nfs_client  = var.DDVE_PPDM_HOSTNAME
  ddve_ppdd_nfs_path    = var.DDVE_PPDD_NFS_PATH
}

/*
uncomment next block to add ppdm
 

module "ppdm" {
#   count = var.ppdm ? 1 : 0  only on terraform 0.13
  source                = "./modules/ppdm"
  ppdm_image            = var.PPDM_IMAGE
  ppdm_hostname         = var.PPDM_HOSTNAME
  ppdm_meta_disks       = var.PPDM_META_DISKS
  ppdm_initial_password = var.PPDM_INITIAL_PASSWORD
  ppdm_private_ip       = var.PPDM_PRIVATE_IP
  ENV_NAME              = var.ENV_NAME
  location              = var.location
  ppdm_vm_size          = var.PPDM_VM_SIZE
  resource_group_name   = module.infra.resource_group_name
  dns_zone_name         = module.infra.dns_zone_name
  subnet_id             = module.infra.infrastructure_subnet_id
  public_ip             = var.PPDM_PUBLIC_IP
}
*/

/*
uncomment next block to add ppdm# linux guest

module "linux" {
#  count = var.LINUX ? 1 : 0  terraform 0.13 only
  source = "./modules/linux"
  linux_image = var.LINUX_IMAGE
  linux_hostname = var.LINUX_HOSTNAME
  linux_data_disks = var.LINUX_DATA_DISKS
  linux_admin_username = var.LINUX_ADMIN_USERNAME
  linux_private_ip = var.LINUX_PRIVATE_IP
  ENV_NAME = var.ENV_NAME
  location = var.location
  linux_vm_size     = var.LINUX_VM_SIZE
  resource_group_name   = module.infra.resource_group_name
  dns_zone_name         = module.infra.dns_zone_name
 # security_group_id   = module.infra.linux_security_group_id
  subnet_id             = module.infra.infrastructure_subnet_id
  storage_account_key       = var.storage_account_key_cs
  storage_account           = var.storage_account_cs
  file_uris                 = var.file_uris_cs
}
*/