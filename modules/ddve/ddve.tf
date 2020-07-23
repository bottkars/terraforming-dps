

### diagnostic account
resource "azurerm_storage_account" "ddve_diag_storage_account" {
    name                        = "${random_string.ddve_diag_storage_account_name.result}"
    resource_group_name         = "${var.resource_group_name}"
    location                    = "${var.location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "${var.deployment}"
        autodelete = "${var.autodelete}"
    }
}

resource "azurerm_marketplace_agreement" "ddve" {
        publisher = "${var.ddve_image["publisher"]}"
        offer     = "${var.ddve_image["offer"]}"
        plan   = "${var.ddve_image["sku"]}"
}
# DNS

#resource "azurerm_dns_a_record" "ddve_dns" {
#  name                = "${var.ddve_hostname}"
#  zone_name           = "${var.dns_zone_name}"
#  resource_group_name = "${var.resource_group_name}"
#  ttl                 = "60"
#  records             = ["${azurerm_private_ip.ddve_private_ip.ip_address}"]
#}


# VMs


## network interface
resource "azurerm_network_interface" "ddve_nic" {
  name                      = "${var.env_name}-ddve-nic"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  count                     = "${local.ddve_vm}"

  ip_configuration {
    name                          = "${var.env_name}-ddve-ip-config"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "ddve" {
    name                  = "${var.env_name}-ddve"
    location              = "${var.location}"
    resource_group_name   = "${var.resource_group_name}"
    depends_on            = ["azurerm_network_interface.ddve_nic"]
    network_interface_ids = ["${azurerm_network_interface.ddve_nic.id}"]
    vm_size                       = "${var.ddve_vm_size}"
    delete_os_disk_on_termination = "true"
    storage_os_disk {
        name              = "DDVEOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"        
        managed_disk_type = "${var.ddve_disk_type}"
    }
    storage_data_disk {
        name                    = "datadisk1"
        disk_size_gb            = "10"
        create_option           = "FromImage"
        managed_disk_type       = "${var.ddve_disk_type}"
        lun                     = "0"    
    }    
    storage_data_disk {
        name                    = "datadisk2"
        disk_size_gb  = "1023"
        create_option = "empty"
        managed_disk_type = "${var.ddve_disk_type}"
        lun                     = "1"    
    }
    storage_data_disk {
        name                    = "datadisk3"
        disk_size_gb  = "1023"
        create_option = "empty"
        managed_disk_type = "${var.ddve_disk_type}"
        lun                     = "2"    
    }    
    plan {
        name = "${var.ddve_image["sku"]}"
        publisher = "${var.ddve_image["publisher"]}"
        product = "${var.ddve_image["offer"]}"  
    }

    storage_image_reference  {
        publisher = "${var.ddve_image["publisher"]}"
        offer     = "${var.ddve_image["offer"]}"
        sku       = "${var.ddve_image["sku"]}"
        version   = "${var.ddve_image["version"]}"
    }
  os_profile {
#    computer_name  = "replace(${var.env_name}-ddve, "_", "-")"
    computer_name  = "ddve"
    admin_username = "sysadmin"
    admin_password = "Change_Me12345_"
    }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys     = {
      key_data = "${tls_private_key.ddve.public_key_openssh}"
      path= "/home/sysadmin/.ssh/authorized_keys"
    }   
  }

  boot_diagnostics {
      enabled = "true"
      storage_uri = "${azurerm_storage_account.ddve_diag_storage_account.primary_blob_endpoint}"
    }

    tags = {
        environment = "${var.deployment}"
    }
}