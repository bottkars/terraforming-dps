#data "template_file" "ppdm_init" {
#  template = file("${path.module}/ppdminit.sh")
#  vars = {
#    ppdm_DOMAIN   = var.dns_zone_name
#    ppdm_PASSWORD = var.ppdm_initial_password
#    ppdm_HOSTNAME = var.ppdm_hostname
#  }
#}

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
#  publisher = var.ppdm_image["publisher"]
#  offer     = var.ppdm_image["offer"]
#  plan      = var.ppdm_image["sku"]
#}
# DNS

resource "azurerm_private_dns_a_record" "ppdm_dns" {
  name                = var.ppdm_hostname
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.ppdm_nic.ip_configuration[0].private_ip_address]
}

## dynamic NSG
resource "azurerm_network_security_group" "ppdm_security_group" {
  name                = "${var.env_name}-ppdm-security-group"
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
  name                = "${var.env_name}-ppdm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.env_name}-ppdm-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    #    private_ip_address            = var.ppdm_private_ip
    public_ip_address_id = var.public_ip == "true" ? azurerm_public_ip.publicip.0.id : null
  }
}
resource "azurerm_public_ip" "publicip" {
  count               = var.public_ip == "true" ? 1 : 0
  name                = "${var.env_name}-ppdm-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}
resource "azurerm_virtual_machine" "ppdm" {
  name                          = "${var.env_name}-ppdm"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  depends_on                    = [azurerm_network_interface.ppdm_nic]
  network_interface_ids         = [azurerm_network_interface.ppdm_nic.id]
  vm_size                       = var.ppdm_vm_size
  delete_os_disk_on_termination = "true"
  storage_os_disk {
    name              = "ppdmOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.ppdm_disk_type
  }

  dynamic "storage_data_disk" {
    for_each = var.ppdm_meta_disks
    content {
      name              = "Metadata-${storage_data_disk.key + 1}"
      lun               = storage_data_disk.key
      disk_size_gb      = storage_data_disk.value
      create_option     = "FromImage"
      managed_disk_type = var.ppdm_disk_type
    }
  }

#  plan {
#    name      = var.ppdm_image["sku"]
#    publisher = var.ppdm_image["publisher"]
#    product   = var.ppdm_image["offer"]
#  }

  storage_image_reference {
#    id = "/subscriptions/29ddc5fa-c72b-4890-beab-42457ce6975b/resourceGroups/sh-ppdm-install-uom/providers/Microsoft.Compute/galleries/installsharedimagegallery/images/ppdm-r6-dev-image-definition/versions/0.7.0"
    id = "/subscriptions/29ddc5fa-c72b-4890-beab-42457ce6975b/resourceGroups/sh-ppdm-install-uom/providers/Microsoft.Compute/galleries/installsharedimagegallery/images/ppdm-r6-dev-image-definition"
#    publisher = var.ppdm_image["publisher"]
#    offer     = var.ppdm_image["offer"]
#    sku       = var.ppdm_image["sku"]
#    version   = var.ppdm_image["version"]
  }
  os_profile {
    computer_name  = var.ppdm_hostname
    admin_username = "sysadmin"
    admin_password = var.ppdm_initial_password
  #  custom_data    = base64encode(data.template_file.ppdm_init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ppdm.public_key_openssh
      path     = "/home/sysadmin/.ssh/authorized_keys"
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
