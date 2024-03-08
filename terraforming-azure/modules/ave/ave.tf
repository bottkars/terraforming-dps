locals {
  ave_size = {
    "0.5 TB AVE" = {
      instance_type = "Standard_A2m_v2"
      ave_disk_type = "Standard_LRS"
      gsan_disks    = ["250", "250", "250"]
    }
    "1 TB AVE" = {
      instance_type = "Standard_A2m_v2"
      ave_disk_type = "Standard_LRS"
      gsan_disks    = ["250", "250", "250", "250", "250", "250"]
    }
    "2 TB AVE" = {
      instance_type = "Standard_A2m_v2"
      ave_disk_type = "Standard_LRS"
      gsan_disks    = ["1000", "1000", "1000"]
    }
    "4 TB AVE" = {
      instance_type = "Standard_A4m_v2"
      ave_disk_type = "Standard_LRS"
      gsan_disks    = ["1000", "1000", "1000", "1000", "1000", "1000"]
    }
    "8 TB AVE" = {
      instance_type = "Standard_A8m_v2"
      ave_disk_type = "Standard_LRS"
      gsan_disks    = ["1000", "1000", "1000", "1000", "1000", "1000", "1000", "1000", "1000", "1000", "1000", "1000"]
    }
    "16 TB AVE" = {
      instance_type = "Standard_D14_v2"
      ave_disk_type = "Standard_LRS"
      gsan_disks    = ["2000", "2000", "2000", "2000", "2000", "2000", "2000", "2000", "2000", "2000", "2000", "2000"]
    }
  }
  ave_image = {
    "19.8.0" = {
      publisher = "dellemc"
      offer     = "dell-emc-avamar-virtual-edition"
      sku       = "avamar-virtual-edition-1980"
      version   = "19.8.0"
    }    
    "19.7.0" = {
      publisher = "dellemc"
      offer     = "dell-emc-avamar-virtual-edition"
      sku       = "avamar-virtual-edition-1970"
      version   = "19.7.0"
    }    
    "19.4.02" = {
      publisher = "dellemc"
      offer     = "dell-emc-avamar-virtual-edition"
      sku       = "avamar-virtual-edition-1940"
      version   = "19.4.02"
    }
    "19.3.03" = {
      publisher = "dellemc"
      offer     = "dell-emc-avamar-virtual-edition"
      sku       = "avamar-virtual-edition-1930"
      version   = "19.3.03"
    }
    "19.2.04" = {
      publisher = "dellemc"
      offer     = "dell-emc-avamar-virtual-edition"
      sku       = "avamar-virtual-edition-1920"
      version   = "19.2.04"
    }
  }
  ave_name           = "ave${var.ave_instance}"
}


data "azurerm_resource_group" "resource_group" {
  name     = var.ave_resource_group_name
}
resource "azurerm_storage_account" "ave_diag_storage_account" {
  name                     = random_string.ave_diag_storage_account_name.result
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  location                 = data.azurerm_resource_group.resource_group.location
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
resource "random_string" "ave_diag_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "tls_private_key" "ave" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "azurerm_marketplace_agreement" "ave" {
  publisher = local.ave_image[var.ave_version]["publisher"]
  offer     = local.ave_image[var.ave_version]["offer"]
  plan      = local.ave_image[var.ave_version]["sku"]
}
# DNS

resource "azurerm_private_dns_a_record" "ave_dns" {
  name                = local.ave_name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.ave_nic.ip_configuration[0].private_ip_address]

}
## nsg


resource "azurerm_network_security_group" "ave_security_group" {
  name                = "${var.environment}-${local.ave_name}-security-group"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  dynamic "security_rule" {
    for_each = var.ave_tcp_inbound_rules_Vnet
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
    for_each = var.ave_tcp_inbound_rules_Inet
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
  security_rule {
    name                       = "UDP_inbound_rule_1"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "161"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  dynamic "security_rule" {
    for_each = var.ave_tcp_outbound_rules
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
  dynamic "security_rule" {
    for_each = var.ave_udp_outbound_rules
    content {
      name                       = "UDP_outbound_rule_${security_rule.key}"
      priority                   = security_rule.key * 10 + 1001
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Udp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
  }

}
resource "azurerm_network_interface_security_group_association" "ave_security_group" {
  network_interface_id      = azurerm_network_interface.ave_nic.id
  network_security_group_id = azurerm_network_security_group.ave_security_group.id

}

# VMs
## network interface
resource "azurerm_network_interface" "ave_nic" {
  name                = "${var.environment}-${local.ave_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.environment}-${local.ave_name}-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip == "true" ? azurerm_public_ip.publicip.0.id : null
  }
}
resource "azurerm_public_ip" "publicip" {
  count               = var.public_ip == "true" ? 1 : 0
  name                = "${var.environment}-${local.ave_name}-pip"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  domain_name_label   = "ppdd-${random_string.fqdn_name.result}"
  allocation_method   = "Dynamic"
}
resource "azurerm_virtual_machine" "ave" {
  name                          = "${var.environment}-${local.ave_name}"
  location                      = data.azurerm_resource_group.resource_group.location
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  depends_on                    = [azurerm_network_interface.ave_nic]
  network_interface_ids         = [azurerm_network_interface.ave_nic.id]
  vm_size                       = local.ave_size[var.ave_type].instance_type
  delete_os_disk_on_termination = "true"
  delete_data_disks_on_termination = "true"
  storage_os_disk {
    name              = "AVEOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = local.ave_size[var.ave_type].ave_disk_type
  }
  dynamic "storage_data_disk" {
    for_each = local.ave_size[var.ave_type].gsan_disks
    content {
      name              = "GSAN-${storage_data_disk.key}"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value
      create_option     = "empty"
      managed_disk_type = local.ave_size[var.ave_type].ave_disk_type
    }
  }

  plan {
    publisher = local.ave_image[var.ave_version]["publisher"]
    product   = local.ave_image[var.ave_version]["offer"]
    name      = local.ave_image[var.ave_version]["sku"]

  }


  storage_image_reference {
    publisher = local.ave_image[var.ave_version]["publisher"]
    offer     = local.ave_image[var.ave_version]["offer"]
    sku       = local.ave_image[var.ave_version]["sku"]
    version   = local.ave_image[var.ave_version]["version"]
  }
  os_profile {
    computer_name  = local.ave_name
    admin_username = "sysadmin"
    admin_password = var.ave_initial_password
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ave.public_key_openssh
      path     = "/home/sysadmin/.ssh/authorized_keys"
    }

  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.ave_diag_storage_account.primary_blob_endpoint
  }

  tags = {
    environment = var.deployment
  }
}
