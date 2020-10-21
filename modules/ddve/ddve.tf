data "template_file" "ddve_init" {
  template = file("${path.module}/ddveinit.sh")
  vars = {
    DDVE_DOMAIN   = var.dns_zone_name
    DDVE_PASSWORD = var.ddve_initial_password
    DDVE_HOSTNAME = var.ddve_hostname
    PPDD_NFS_PATH = var.ddve_ppdd_nfs_path
    PPDD_NFS_CLIENT = var.ddve_ppdd_nfs_client
  }
}
#  - /ddr/bin/ddsh net set searchdomain ${PPDD_DOMAIN}
### diagnostic account
/*
 - until /ddr/bin/ddsh net config ethV0 dhcp yes ; do printf .; sleep 5 ; done
 - /usr/bin/echo '${DDVE_PASSWORD}' | /usr/bin/passwd sysadmin --stdin
 - /ddr/bin/ddsh elicense reset restore-evaluation
*/
resource "azurerm_storage_account" "ddve_diag_storage_account" {
  name                     = random_string.ddve_diag_storage_account_name.result
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = var.deployment
    autodelete  = var.autodelete
  }
}

resource "azurerm_marketplace_agreement" "ddve" {
  publisher = var.ddve_image["publisher"]
  offer     = var.ddve_image["offer"]
  plan      = var.ddve_image["sku"]
}
# DNS

resource "azurerm_private_dns_a_record" "ddve_dns" {
  name                = var.ddve_hostname
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = "60"
  records             = [azurerm_network_interface.ddve_nic.ip_configuration[0].private_ip_address]
}

## dynamic NSG
resource "azurerm_network_security_group" "ddve_security_group" {
  name                = "${var.env_name}-ddve-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.ddve_tcp_inbound_rules_Vnet
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
    for_each = var.ddve_tcp_inbound_rules_Inet
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


resource "azurerm_network_interface_security_group_association" "ddve_security_group" {
  network_interface_id      = azurerm_network_interface.ddve_nic.id
  network_security_group_id = azurerm_network_security_group.ddve_security_group.id
}

# VMs
## network interface
resource "azurerm_network_interface" "ddve_nic" {
  name                = "${var.env_name}-ddve-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.env_name}-ddve-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.public_ip == "true" ? azurerm_public_ip.publicip.0.id : null
  }
}
resource "azurerm_public_ip" "publicip" {
  count               = var.public_ip == "true" ? 1 : 0
  name                = "${var.env_name}-ddve-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}
resource "azurerm_virtual_machine" "ddve" {
  name                          = "${var.env_name}-ddve"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  depends_on                    = [azurerm_network_interface.ddve_nic]
  network_interface_ids         = [azurerm_network_interface.ddve_nic.id]
  vm_size                       = var.ddve_vm_size
  delete_os_disk_on_termination = "true"
  delete_data_disks_on_termination ="true"
  storage_os_disk {
    name              = "DDVEOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.ddve_disk_type
  }
  storage_data_disk {
    name              = "nvr-disk"
    disk_size_gb      = "10"
    create_option     = "FromImage"
    managed_disk_type = var.ddve_disk_type
    lun               = "0"
  }

  dynamic "storage_data_disk" {
    for_each = var.ddve_meta_disks
    content {
      name              = "Metadata-${storage_data_disk.key + 1}"
      lun               = storage_data_disk.key + 1
      disk_size_gb      = storage_data_disk.value
      create_option     = "empty"
      managed_disk_type = var.ddve_disk_type
    }
  }

  plan {
    name      = var.ddve_image["sku"]
    publisher = var.ddve_image["publisher"]
    product   = var.ddve_image["offer"]
  }

  storage_image_reference {
    publisher = var.ddve_image["publisher"]
    offer     = var.ddve_image["offer"]
    sku       = var.ddve_image["sku"]
    version   = var.ddve_image["version"]
  }
  os_profile {
    computer_name  = var.ddve_hostname
    admin_username = "sysadmin"
    admin_password = var.ddve_initial_password
    custom_data    = base64encode(data.template_file.ddve_init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ddve.public_key_openssh
      path     = "/home/sysadmin/.ssh/authorized_keys"
    }

  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.ddve_diag_storage_account.primary_blob_endpoint
  }

  tags = {
    environment = var.deployment
  }
}
