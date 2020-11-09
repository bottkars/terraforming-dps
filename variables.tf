/*
Subscription Variables, should be set from env or vault
*/


variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {}

/*
Infra Module Variables, if not derived from environment/tfvars
*/
variable "ENV_NAME" {}
variable "aks_subnet" {
  description = "If set to true, create subnet for aks"
  type        = bool
  default     = true
}
variable "environment" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}
variable "dns_suffix" {}

variable "dps_virtual_network_address_space" {
  type    = list
  default = ["10.10.0.0/16"]
}

variable "dps_infrastructure_subnet" {
  type    = string
  default = "10.10.8.0/26"
}
variable "dps_aks_subnet" {
  type    = string
  default = "10.10.6.0/24"
}
variable "dps_azure_bastion_subnet" {
  type    = string
  default = "10.10.0.224/27"
}

/*
ddve block start here
*/
variable "ddve" {
  type = bool
}
variable "DDVE_HOSTNAME" {}


variable "DDVE_INITIAL_PASSWORD" {
  default = "Change_Me12345_"
}

variable "DDVE_META_DISKS" {
  type    = list(string)
  default = ["1023", "250", "250"]
}

variable "ddve_ppdd_nfs_path" {
  default = "/data/col1/powerprotect"
}

variable "ddve_private_ip" {
  type        = string
  description = "IP for ddve instance"
  default     = "10.10.8.4"
}

variable "DDVE_PUBLIC_IP" {
  type    = string
  default = "false"
}

variable "DDVE_IMAGE" {
  type = map
  default = {
    publisher = "dellemc"
    offer     = "dell-emc-datadomain-virtual-edition-v4"
    sku       = "ddve-60-ver-7305"
    version   = "7.3.05"
  }
}
variable "DDVE_VM_SIZE" {
  type    = string
  default = "Standard_DS4_v2"
}
variable "DDVE_PPDM_HOSTNAME" {
}


/*
ppdm block start here
*/
variable "ppdm" {
  type = bool
}
variable "PPDM_HOSTNAME" {} # if mot used from ddve
variable "PPDM_INITIAL_PASSWORD" {
  default = "Change_Me12345_"
}

variable "PPDM_META_DISKS" {
  type    = list(string)
  default = ["488", "10", "10", "5", "5", "5"]
}
variable "ppdm_private_ip" {
  type        = string
  description = "IP for ppdm instance"
  default     = "10.10.8.4"
}

variable "PPDM_PUBLIC_IP" {
  type    = string
  default = "false"
}

variable "PPDM_IMAGE" {
  type = map
  #    default = {
  #       publisher =  "dellemc"
  #       offer = "dell-emc-datadomain-virtual-edition-v4"
  #       sku = "ppdm-60-ver-7305"
  #       version = "7.3.05"
  #   }
}
variable "PPDM_VM_SIZE" {
  type    = string
  default = "Standard_F8s_v2"
}

# ubuntu block starts here
variable "linux" {
  type = bool
}
variable "linux_hostname" {
  default = "client1"
}
variable "linux_admin_username" {
  default = "ubuntu"
}

variable "linux_data_disks" {
  type    = list(string)
  default = []
}
variable "storage_account_cs" {}
variable "storage_account_key_cs" {}

variable "file_uris_cs" {
  type = string
}

variable "linux_private_ip" {
  type        = string
  description = "IP for linux instance"
  default     = "10.10.8.12"
}

variable "linux_image" {
  type = map
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
variable "linux_vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}
