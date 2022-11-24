locals {
  ppdm_image = {
    "19.12.0" = {
      publisher = "dellemc"
      offer     = "ppdm_0_0_1"
      sku       = "powerprotect-data-manager-19-12-0-19"
      version   = "19.12.0"
    }
    "19.11.0" = {
      publisher = "dellemc"
      offer     = "ppdm_0_0_1"
      sku       = "powerprotect-data-manager-19-11-0-14"
      version   = "19.11.0"
    }    
  }
  ppdm_vm_size       = "Standard_D8s_v3"
  ppdm_name          = "ppdm${var.ppdm_instance}"
  resourcegroup_name = "${var.environment}-${local.ppdm_name}"
  ppdm_meta_disks    = ["500", "10", "10", "5", "5", "5"]
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resourcegroup_name
  location = var.location
}



resource "random_string" "ppdm_diag_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}
resource "random_string" "fqdn_name" {
  length  = 8
  special = false
  upper   = false
}
resource "tls_private_key" "ppdm" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_storage_account" "ppdm_diag_storage_account" {
  name                     = random_string.ppdm_diag_storage_account_name.result
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.deployment
    autodelete  = var.autodelete
  }
}

resource "azurerm_marketplace_agreement" "ppdm" {
  publisher = local.ppdm_image[var.ppdm_version]["publisher"]
  offer     = local.ppdm_image[var.ppdm_version]["offer"]
  plan      = local.ppdm_image[var.ppdm_version]["sku"]
}
# DNS

resource "azurerm_private_dns_a_record" "ppdm_dns" {
  name                = local.ppdm_name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.ppdm_nic.ip_configuration[0].private_ip_address]
}

## dynamic NSG
resource "azurerm_network_security_group" "ppdm_security_group" {
  name                = "${var.environment}-${local.ppdm_name}-security-group"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location

  dynamic "security_rule" {
    for_each = var.ppdm_tcp_inbound_rules_Vnet
    content {
      name                       = "TCP_inbound_rule_Vnet_${security_rule.key}"
      priority                   = security_rule.key * 10 + 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
  }
  dynamic "security_rule" {
    for_each = var.ppdm_tcp_inbound_rules_Inet
    content {
      name                       = "TCP_inbound_rule_Inet_${security_rule.key}"
      priority                   = security_rule.key * 10 + 1100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }
  security_rule {
    name                       = "TCP_outbound_rule_1"
    priority                   = 1010
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 443
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface_security_group_association" "ppdm_security_group" {
  network_interface_id      = azurerm_network_interface.ppdm_nic.id
  network_security_group_id = azurerm_network_security_group.ppdm_security_group.id
}

# VMs
## network interface
resource "azurerm_network_interface" "ppdm_nic" {
  name                = "${var.environment}-${local.ppdm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.environment}-${local.ppdm_name}-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip == "true" ? azurerm_public_ip.publicip.0.id : null
  }
}
resource "azurerm_public_ip" "publicip" {
  count               = var.public_ip == "true" ? 1 : 0
  name                = "${var.environment}-${local.ppdm_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = "ppdm-${random_string.fqdn_name.result}"
}


resource "azurerm_virtual_machine" "ppdm" {
  name                             = "${var.environment}-${local.ppdm_name}"
  resource_group_name              = azurerm_resource_group.resource_group.name
  location                         = azurerm_resource_group.resource_group.location
  depends_on                       = [azurerm_network_interface.ppdm_nic]
  network_interface_ids            = [azurerm_network_interface.ppdm_nic.id]
  vm_size                          = local.ppdm_vm_size
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  storage_os_disk {
    name              = "ppdmOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.ppdm_disk_type
  }

  dynamic "storage_data_disk" {
    for_each = local.ppdm_meta_disks
    content {
      name              = "DataDisk-${storage_data_disk.key + 1}"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value
      create_option     = "FromImage"
      managed_disk_type = var.ppdm_disk_type
    }
  }

  plan {
    name      = local.ppdm_image[var.ppdm_version]["sku"]
    publisher = local.ppdm_image[var.ppdm_version]["publisher"]
    product   = local.ppdm_image[var.ppdm_version]["offer"]
  }

  storage_image_reference {
    #    id = local.ppdm_image[var.ppdm_version]["id"]
    publisher = local.ppdm_image[var.ppdm_version]["publisher"]
    offer     = local.ppdm_image[var.ppdm_version]["offer"]
    sku       = local.ppdm_image[var.ppdm_version]["sku"]
    version   = local.ppdm_image[var.ppdm_version]["version"]
  }
  os_profile {
    computer_name  = local.ppdm_name
    admin_username = "ppdmadmin"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ppdm.public_key_openssh
      path     = "/home/ppdmadmin/.ssh/authorized_keys"
    }
  }


  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.ppdm_diag_storage_account.primary_blob_endpoint
  }

  tags = {
    environment = var.deployment
  }
}
