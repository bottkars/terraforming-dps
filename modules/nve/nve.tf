### diagnostic account
resource "azurerm_storage_account" "nve_diag_storage_account" {
  name                     = random_string.nve_diag_storage_account_name.result
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.deployment
    autodelete  = var.autodelete
  }
}

resource "azurerm_marketplace_agreement" "nve" {
  publisher = var.nve_image["publisher"]
  offer     = var.nve_image["offer"]
  plan      = var.nve_image["sku"]

}
# DNS

resource "azurerm_private_dns_a_record" "nve_dns" {
  name                = var.nve_hostname
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.nve_nic.ip_configuration[0].private_ip_address]

}
## nsg


resource "azurerm_network_security_group" "nve_security_group" {
  name                = "${var.env_name}-nve-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

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
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
  }

  dynamic "security_rule" {
    for_each = var.nve_tcp_inbound_rules_Inet
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
  name                = "${var.env_name}-nve-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.env_name}-nve-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
#ä    private_ip_address            = var.nve_private_ip
  }
}
resource "azurerm_virtual_machine" "nve" {
  name                          = "${var.env_name}-nve"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  depends_on                    = [azurerm_network_interface.nve_nic]
  network_interface_ids         = [azurerm_network_interface.nve_nic.id]
  vm_size                       = var.nve_vm_size
  delete_os_disk_on_termination = "true"
  storage_os_disk {
    name              = "NVEOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.nve_disk_type
  }
  dynamic "storage_data_disk" {
    for_each = var.nve_data_disks
    content {
      name              = "datadisk-${storage_data_disk.key}"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value
      create_option     = "empty"
      managed_disk_type = var.nve_disk_type
    }
 }

  plan {
    name      = var.nve_image["sku"]
    publisher = var.nve_image["publisher"]
    product   = var.nve_image["offer"]
  }

  storage_image_reference {
    publisher = var.nve_image["publisher"]
    offer     = var.nve_image["offer"]
    sku       = var.nve_image["sku"]
    version   = var.nve_image["version"]
  }
  os_profile {
    computer_name  = "${var.nve_hostname}.${var.dns_zone_name}"
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