resource random_string "ppdm_diag_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}
resource random_string "fqdn_name" {
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
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.deployment
    autodelete  = var.autodelete
  }
}

#resource "azurerm_marketplace_agreement" "ppdm" {
#  publisher = var.PPDM_IMAGE["publisher"]
#  offer     = var.PPDM_IMAGE["offer"]
#  plan      = var.PPDM_IMAGE["sku"]
#}
# DNS

resource "azurerm_private_dns_a_record" "ppdm_dns" {
  name                = var.PPDM_HOSTNAME
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.ppdm_nic.ip_configuration[0].private_ip_address]
}

## dynamic NSG
resource "azurerm_network_security_group" "ppdm_security_group" {
  name                = "${var.ENV_NAME}-ppdm-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

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
  name                = "${var.ENV_NAME}-ppdm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.ENV_NAME}-ppdm-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    #    private_ip_address            = var.ppdm_private_ip
    public_ip_address_id = var.public_ip == "true" ? azurerm_public_ip.publicip.0.id : null
  }
}
resource "azurerm_public_ip" "publicip" {
  count               = var.public_ip == "true" ? 1 : 0
  name                = "${var.ENV_NAME}-ppdm-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = "ppdm-${random_string.fqdn_name.result}"
}


resource "azurerm_virtual_machine" "ppdm" {
  name                          = "${var.ENV_NAME}-ppdm"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  depends_on                    = [azurerm_network_interface.ppdm_nic]
  network_interface_ids         = [azurerm_network_interface.ppdm_nic.id]
  vm_size                       = var.PPDM_VM_SIZE
  delete_os_disk_on_termination = "true"
  delete_data_disks_on_termination ="true"
  storage_os_disk {
    name              = "ppdmOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.ppdm_disk_type
  }

  dynamic "storage_data_disk" {
    for_each = var.PPDM_META_DISKS
    content {
      name              = "DataDisk-${storage_data_disk.key + 1}"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value
      create_option     = "FromImage"
      managed_disk_type = var.ppdm_disk_type
    }
  }

  #  plan {
  #    name      = var.PPDM_IMAGE["sku"]
  #    publisher = var.PPDM_IMAGE["publisher"]
  #    product   = var.PPDM_IMAGE["offer"]
  #  }

  storage_image_reference {
    id = var.PPDM_IMAGE["id"]
    #    publisher = var.PPDM_IMAGE["publisher"]
    #    offer     = var.PPDM_IMAGE["offer"]
    #    sku       = var.PPDM_IMAGE["sku"]
    #    version   = var.PPDM_IMAGE["version"]
  }
  os_profile {
    computer_name  = var.PPDM_HOSTNAME
    admin_username = "ppdmadmin"
    #  admin_password = var.PPDM_INITIAL_PASSWORD
    #  custom_data    = base64encode(data.template_file.ppdm_init.rendered)
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
