
variable "k8s_pool_node_count" {
    default = "2"
    }
variable "k8s_pool_node_size" {
    default = "Standard_D2_v2"
    }
variable "environment" {
  default = ""
}    
variable "aks_instance" {
  default = ""
} 
variable "resource_group_name" {
  default = ""
}
variable "location" {
  default = ""
}    
variable "subnet_id" {
  default = ""
}
variable "autodelete" {
  default = "true"
}
variable "deployment" {
  default = "test"
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
} 
