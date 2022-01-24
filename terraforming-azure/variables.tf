/*
Subscription Variables, should be set from env or vault
*/


variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {}

/*
Network Module Variables, if not derived from environment/tfvars
*/
variable "create_networks" {
  type    = bool
  default = false
}
variable "environment" {}
variable "enable_aks_subnet" {
  description = "If set to true, create subnet for aks"
  type        = bool
  default     = true
}
variable "enable_tkg_controlplane_subnet" {
  description = "If set to true, create subnet for aks"
  type        = bool
  default     = false
}
variable "enable_tkg_workload_subnet" {
  description = "If set to true, create subnet for aks"
  type        = bool
  default     = false
}
variable "azure_environment" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}
variable "dns_suffix" {}

variable "virtual_network_address_space" {
  type    = list(any)
  default = ["10.10.0.0/16"]
}

variable "infrastructure_subnet" {
  type    = list(string)
  default = ["10.10.8.0/26"]
}
variable "aks_subnet" {
  type    = list(string)
  default = ["10.10.6.0/24"]
}
variable "vpn_subnet" {
  type    = list(string)
  default = ["10.10.12.0/24"]
}
variable "tkg_workload_subnet" {
  type    = list(string)
  default = ["10.10.4.0/24"]
}
variable "tkg_controlplane_subnet" {
  type    = list(string)
  default = ["10.10.2.0/24"]
}
variable "azure_bastion_subnet" {
  type    = list(string)
  default = ["10.10.0.224/27"]
}


/*
ddve block start here
*/

variable "create_ave" {
  type    = bool
  default = false
}

variable "AVE_IMAGE" {
  type = map(any)
  default = {
    publisher = "dellemc"
    offer     = "dell-emc-avamar-virtual-edition"
    sku       = "avamar-virtual-edition-1930"
    version   = "19.3.01"
  }
}

variable "AVE_HOSTNAME" {
  default = "ave1"
}
variable "ave_gsan_disks" {
  default = ["250", "250", "250"]
}
variable "ave_initial_password" {
  default = "Change_Me12345_"
}
variable "ave_private_ip" {
  type        = string
  description = "IP for AVE instance"
  default     = "10.10.8.5"
}
variable "ave_vm_size" {
  type    = string
  default = "Standard_D4s_v3"
}
variable "AVE_PUBLIC_IP" {
  type    = string
  default = "true"
}
/*
ddve block start here
*/

variable "ddve_initial_password" {
  default = "Change_Me12345_"
}

variable "DDVE_TCP_INBOUND_RULES_INET" {
  type    = list(string)
  default = []
}
variable "ddve_meta_disks" {
  type    = list(string)
  default = ["1023", "250", "250"]
}

variable "DDVE_PPDD_NFS_PATH" {
  default = "/data/col1/powerprotect"
}

variable "DDVE_PRIVATE_IP" {
  type        = string
  description = "IP for ddve instance"
  default     = "10.10.8.4"
}

variable "ddve_public_ip" {
  type    = string
  default = "false"
}

variable "ddve_image" {
  type = map(any)
  default = {
    publisher = "dellemc"
    offer     = "dell-emc-datadomain-virtual-edition-v4"
    sku       = "ddve-7707"
    version   = "7.7.007"
  }
}
variable "ddve_type" {
  type        = string
  default     = "16 TB DDVE"
  description = "DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE','16 TB DDVE PERF', '32 TB DDVE PERF', '96 TB DDVE PERF', '256 TB DDVE PERF'"
  validation {
    condition = anytrue([
      var.ddve_type == "16 TB DDVE",
      var.ddve_type == "32 TB DDVE",
      var.ddve_type == "96 TB DDVE",
      var.ddve_type == "256 TB DDVE",
      var.ddve_type == "16 TB DDVE PERF",
      var.ddve_type == "32 TB DDVE PERF",
      var.ddve_type == "96 TB DDVE PERF",
      var.ddve_type == "256 TB DDVE PERF"
    ])
    error_message = "Must be a valid DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE'."
  }
}



/*
ppdm block start here
*/
variable "create_ppdm" {
  type    = bool
  default = false
}
variable "ppdm_initial_password" {
  default = "Change_Me12345_"
}

variable "ppdm_meta_disks" {
  type    = list(string)
  default = ["500", "10", "10", "5", "5", "5"]
}
variable "PPDM_PRIVATE_IP" {
  type        = string
  description = "IP for ppdm instance"
  default     = "10.10.8.4"
}

variable "ppdm_public_ip" {
  type    = string
  default = "false"
}
variable "ppdm_image" {
  type = map(any)
  default = {
    publisher = "dellemc"
    offer     = "ppdm_0_0_1"
    sku       = "powerprotect-data-manager-19-6-0"
    version   = "19.6.0"
  }
}
variable "ppdm_vm_size" {
  type    = string
  default = "Standard D8s v3"
}

# ubuntu block starts here
variable "create_linux" {
  type    = bool
  default = false
}
variable "LINUX_HOSTNAME" {
  default = "client1"
}
variable "LINUX_ADMIN_USERNAME" {
  default = "ubuntu"
}

variable "LINUX_DATA_DISKS" {
  type    = list(string)
  default = []
}
variable "storage_account_cs" {}
variable "storage_account_key_cs" {}

variable "file_uris_cs" {
  type = string
}

variable "LINUX_PRIVATE_IP" {
  type        = string
  description = "IP for linux instance"
  default     = "10.10.8.12"
}

variable "LINUX_IMAGE" {
  type = map(any)
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
variable "LINUX_VM_SIZE" {
  type    = string
  default = "Standard_DS1_v2"
}


/*
ddve block start here
*/

variable "create_nve" {
  type    = bool
  default = false
}
variable "NVE_INITIAL_PASSWORD" {
  type      = string
  default   = "Change_Me12345_"
  sensitive = true
}

variable "NVE_HOSTNAME" {
  type    = string
  default = "nve1"
}

variable "NVE_DATA_DISKS" {
  type    = list(string)
  default = ["600"]
}

variable "NVE_PRIVATE_IP" {
  type        = string
  description = "IP for NVE instance"
  default     = "10.10.8.10"
}

variable "NVE_IMAGE" {
  type = map(any)
  default = {
    publisher = "dellemc"
    offer     = "dell-emc-networker-virtual-edition"
    sku       = "dell-emc-networker-virtual-edition"
    version   = "19.4.25"
  }
}
variable "NVE_TCP_INBOUND_RULES_INET" {
  type    = list(string)
  default = []
}
variable "NVE_PUBLIC_IP" {
  type    = string
  default = "false"
}
variable "NVE_VM_SIZE" {
  type    = string
  default = "Standard_D8s_v3"
}
variable "networks_resource_group_name" {
  default = null
}

variable "networks_dns_zone_name" {
  default = null
}

variable "networks_infrastructure_subnet_id" {
  default = null
}

variable "create_s2s_vpn" {
  default = false
}

variable "tunnel1_preshared_key" {}
variable "wan_ip" {}
variable "vnet_name" {
  default = ""
}
variable "network_rg_name" {
  default     = ""
  description = "The RG for Network if different is used"
}
variable "networks_aks_subnet_id" {
  default     = ""
  description = "The AKS Subnet ID if not deployed from Module"
}

variable "vpn_destination_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "the cidr blocks as string !!! for the destination route in you local network, when s2s_vpn is deployed"

}
variable "ddve_count" {
  type    = number
  default = 0

}

variable "ppdm_count" {
  type    = number
  default = 0

}

variable "aks_count" {
  type    = number
  default = 0

}