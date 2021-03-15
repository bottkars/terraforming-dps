# RFC for count on AzureRM.Storage_Data_Disk

   storage_data_disk {
        count = 2
        name                    = "MetaDisk-${count.index}"
        disk_size_gb  = "1023"
        create_option = "empty"
        managed_disk_type = var.ddve_disk_type
        lun                     = count.index    
    }