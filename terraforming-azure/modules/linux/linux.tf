# custom data
data "template_file" "cloud_init" {
  template = "${file("${path.module}/cloudinit.conf")}"
  vars = { 
    hostname = "${var.linux_hostname}.${var.dns_zone_name}"
  }
}

### diagnostic account
resource "azurerm_storage_account" "linux_diag_storage_account" {
  name                     = random_string.linux_diag_storage_account_name.result
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.deployment
    autodelete  = var.autodelete
  }
}


# DNS

resource "azurerm_private_dns_a_record" "linux_dns" {
  name                = var.linux_hostname
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.linux_nic.ip_configuration[0].private_ip_address]

}
## nsg


resource "azurerm_network_security_group" "linux_security_group" {
  name                = "${var.ENV_NAME}-linux-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.linux_tcp_inbound_rules_Vnet
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
    for_each = var.linux_tcp_inbound_rules_Inet
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
    for_each = var.linux_tcp_outbound_rules
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
resource "azurerm_network_interface_security_group_association" "linux_security_group" {
  network_interface_id      = azurerm_network_interface.linux_nic.id
  network_security_group_id = azurerm_network_security_group.linux_security_group.id

}

# VMs
## network interface
resource "azurerm_network_interface" "linux_nic" {
  name                = "${var.ENV_NAME}-linux-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.ENV_NAME}-linux-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
#ä    private_ip_address            = var.linux_private_ip
  }
}
resource "azurerm_virtual_machine" "linux" {
  name                          = "${var.ENV_NAME}-linux"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  depends_on                    = [azurerm_network_interface.linux_nic]
  network_interface_ids         = [azurerm_network_interface.linux_nic.id]
  vm_size                       = var.linux_vm_size
  delete_os_disk_on_termination = "true"
  storage_os_disk {
    name              = "linuxOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.linux_disk_type
  }
  dynamic "storage_data_disk" {
    for_each = var.linux_data_disks
    content {
      name              = "datadisk-${storage_data_disk.key}"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value
      create_option     = "empty"
      managed_disk_type = var.linux_disk_type
    }
 }

  storage_image_reference {
    publisher = var.linux_image["publisher"]
    offer     = var.linux_image["offer"]
    sku       = var.linux_image["sku"]
    version   = var.linux_image["version"]
  }
  os_profile {
    computer_name  = "${var.linux_hostname}.${var.dns_zone_name}"
    admin_username = var.linux_admin_username
    custom_data = base64encode(data.template_file.cloud_init.rendered)
#    admin_password = var.linux_initial_password
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.linux.public_key_openssh
      path     = "/home/${var.linux_admin_username}/.ssh/authorized_keys"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.linux_diag_storage_account.primary_blob_endpoint
  }
  tags = {
    environment = var.deployment
  }
}
resource "azurerm_virtual_machine_extension" "deploy_nsr" {
  name                 = "${var.ENV_NAME}-deploy_nsr"
  virtual_machine_id   = azurerm_virtual_machine.linux.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  settings = <<SETTINGS
  {
      "timestamp": 1000
  }
  SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
  {
      "commandToExecute": "ls -l",
      "storageAccountName": "${var.storage_account}",
      "storageAccountKey": "${var.storage_account_key}",
      "fileUris": "${var.file_uris}"
  }
  PROTECTED_SETTINGS
  depends_on = [azurerm_virtual_machine.linux]
}
#        "script": "<base64-script-to-execute>"
# cp xzfv nw*_linux_x86_64.tar.gz /home/$username
# cd 
# tar xzfv nw*_linux_x86_64.tar.gz 
# apt install ./linux_x86_64/lgtoclnt_*_amd64.deb 

