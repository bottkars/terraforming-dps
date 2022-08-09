locals {
  nve_size = {
    "SMALL" = {
      instance_type = "Standard_D4s_v3"
      nve_disk_type = "Standard_LRS"
      data_disks    = ["600"]
    }
    "MEDIUM" = {
      instance_type = "Standard_D4s_v3"
      nve_disk_type = "Standard_LRS"
      data_disks    = ["1200"]
    }
    "LARGE" = {
      instance_type = "Standard_D8s_v3"
      nve_disk_type = "Standard_LRS"
      data_disks    = ["2400"]
    }
  }
  nve_image = {
    "19.6.49" = {
      publisher = "dellemc"
      offer     = "dell-emc-networker-virtual-edition"
      sku       = "dell-emc-networker-virtual-edition-196"
      version   = "19.6.49"
    }
    "19.5.154" = {
      publisher = "dellemc"
      offer     = "dell-emc-networker-virtual-edition"
      sku       = "dell-emc-networker-virtual-edition19505"
      version   = "19.5.154"
    }
    "19.7.0" = {
      publisher = "dellemc"
      offer     = "dell-emc-networker-virtual-edition"
      sku       = "dell-emc-networker-virtual-edition197"
      version   = "19.7.0"
    }
  }
  nve_name           = "nve${var.nve_instance}"
  resourcegroup_name = "${var.environment}-${local.nve_name}"
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resourcegroup_name
  location = var.location
}

resource "azurerm_storage_account" "nve_diag_storage_account" {
  name                     = random_string.nve_diag_storage_account_name.result
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.deployment
    autodelete  = var.autodelete
  }
}
resource "random_string" "fqdn_name" {
  length  = 8
  special = false
  upper   = false
}
resource "random_string" "nve_diag_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "tls_private_key" "nve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "azurerm_marketplace_agreement" "nve" {
  publisher = local.nve_image[var.nve_version]["publisher"]
  offer     = local.nve_image[var.nve_version]["offer"]
  plan      = local.nve_image[var.nve_version]["sku"]
}
# DNS

resource "azurerm_private_dns_a_record" "nve_dns" {
  name                = local.nve_name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.nve_nic.ip_configuration[0].private_ip_address]

}
## nsg


resource "azurerm_network_security_group" "nve_security_group" {
  name                = "${var.environment}-${local.nve_name}-security-group"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  dynamic "security_rule" {
    for_each = var.nve_tcp_inbound_rules_Vnet
    content {
      name                       = "TCP_inbound_rule_Vnet_${security_rule.key}"
      priority                   = security_rule.key * 10 + 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }
  dynamic "security_rule" {
    for_each = var.nve_tcp_inbound_rules_Inet
    content {
      name                       = "TCP_inbound_rule_Inet_${security_rule.key}"
      priority                   = security_rule.key * 10 + 2000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }  

  dynamic "security_rule" {
    for_each = var.nve_tcp_outbound_rules
    content {
      name                       = "TCP_outbound_rule_${security_rule.key}"
      priority                   = security_rule.key * 10 + 1000
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }

}
resource "azurerm_network_interface_security_group_association" "nve_security_group" {
  network_interface_id      = azurerm_network_interface.nve_nic.id
  network_security_group_id = azurerm_network_security_group.nve_security_group.id

}

# VMs
## network interface
resource "azurerm_network_interface" "nve_nic" {
  name                = "${var.environment}-${local.nve_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.environment}-${local.nve_name}-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip == "true" ? azurerm_public_ip.publicip.0.id : null
  }
}
resource "azurerm_public_ip" "publicip" {
  count               = var.public_ip == "true" ? 1 : 0
  name                = "${var.environment}-${local.nve_name}-pip"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  domain_name_label   = "ppdd-${random_string.fqdn_name.result}"
  allocation_method   = "Dynamic"
}
resource "azurerm_virtual_machine" "nve" {
  name                          = "${var.environment}-${local.nve_name}"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  depends_on                    = [azurerm_network_interface.nve_nic]
  network_interface_ids         = [azurerm_network_interface.nve_nic.id]
  vm_size                       = local.nve_size[var.nve_type].instance_type
  delete_os_disk_on_termination = "true"
  storage_os_disk {
    name              = "NVEOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = local.nve_size[var.nve_type].nve_disk_type
  }
  dynamic "storage_data_disk" {
    for_each = local.nve_size[var.nve_type].data_disks
    content {
      name              = "datadisk-${storage_data_disk.key}"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value
      create_option     = "empty"
      managed_disk_type = local.nve_size[var.nve_type].nve_disk_type
    }
  }

  plan {
    publisher = local.nve_image[var.nve_version]["publisher"]
    product   = local.nve_image[var.nve_version]["offer"]
    name      = local.nve_image[var.nve_version]["sku"]

  }


  storage_image_reference {
    publisher = local.nve_image[var.nve_version]["publisher"]
    offer     = local.nve_image[var.nve_version]["offer"]
    sku       = local.nve_image[var.nve_version]["sku"]
    version   = local.nve_image[var.nve_version]["version"]
  }
  os_profile {
    computer_name  = local.nve_name
    admin_username = "sysadmin"
    admin_password = var.nve_initial_password
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.nve.public_key_openssh
      path     = "/home/sysadmin/.ssh/authorized_keys"
    }

  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.nve_diag_storage_account.primary_blob_endpoint
  }

  tags = {
    environment = var.deployment
  }
}
