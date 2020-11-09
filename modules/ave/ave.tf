### diagnostic account
resource "azurerm_storage_account" "ave_diag_storage_account" {
  name                     = random_string.ave_diag_storage_account_name.result
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.deployment
    autodelete  = var.autodelete
  }
}

resource "azurerm_marketplace_agreement" "ave" {
  publisher = var.ave_image["publisher"]
  offer     = var.ave_image["offer"]
  plan      = var.ave_image["sku"]

}
# DNS

resource "azurerm_private_dns_a_record" "ave_dns" {
  name                = var.ave_hostname
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.ave_nic.ip_configuration[0].private_ip_address]

}
## nsg


resource "azurerm_network_security_group" "ave_security_group" {
  name                = "${var.ENV_NAME}-ave-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.ave_tcp_inbound_rules
    content {
      name                       = "TCP_inbound_rule_${security_rule.key}"
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
  name                = "${var.ENV_NAME}-ave-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.ENV_NAME}-ave-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ave_private_ip
  }
}
resource "azurerm_virtual_machine" "ave" {
  name                          = "${var.ENV_NAME}-ave"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  depends_on                    = [azurerm_network_interface.ave_nic]
  network_interface_ids         = [azurerm_network_interface.ave_nic.id]
  vm_size                       = var.ave_vm_size
  delete_os_disk_on_termination = "true"
  storage_os_disk {
    name              = "AVEOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.ave_disk_type
  }
  dynamic "storage_data_disk" {
    for_each = var.ave_gsan_disks
    content {
      name              = "GSAN-${storage_data_disk.key}"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value
      create_option     = "empty"
      managed_disk_type = var.ave_disk_type
    }
  }

  plan {
    name      = var.ave_image["sku"]
    publisher = var.ave_image["publisher"]
    product   = var.ave_image["offer"]
  }

  storage_image_reference {
    publisher = var.ave_image["publisher"]
    offer     = var.ave_image["offer"]
    sku       = var.ave_image["sku"]
    version   = var.ave_image["version"]
  }
  os_profile {
    computer_name  = var.ave_hostname
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