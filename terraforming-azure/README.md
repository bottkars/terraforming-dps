# terraforming-azure

terrafroming-azure is a set of terraform modules to deply DellEMC DPS Products to Azure 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ./modules/aks | n/a |
| <a name="module_ave"></a> [ave](#module\_ave) | ./modules/ave | n/a |
| <a name="module_ddve"></a> [ddve](#module\_ddve) | ./modules/ddve | n/a |
| <a name="module_linux"></a> [linux](#module\_linux) | ./modules/linux | n/a |
| <a name="module_networks"></a> [networks](#module\_networks) | ./modules/networks | n/a |
| <a name="module_nve"></a> [nve](#module\_nve) | ./modules/nve | n/a |
| <a name="module_ppdm"></a> [ppdm](#module\_ppdm) | ./modules/ppdm | n/a |
| <a name="module_s2s_vpn"></a> [s2s\_vpn](#module\_s2s\_vpn) | ./modules/s2s_vpn | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AVE_HOSTNAME"></a> [AVE\_HOSTNAME](#input\_AVE\_HOSTNAME) | n/a | `string` | `"ave1"` | no |
| <a name="input_AVE_IMAGE"></a> [AVE\_IMAGE](#input\_AVE\_IMAGE) | n/a | `map(any)` | <pre>{<br>  "offer": "dell-emc-avamar-virtual-edition",<br>  "publisher": "dellemc",<br>  "sku": "avamar-virtual-edition-1930",<br>  "version": "19.3.01"<br>}</pre> | no |
| <a name="input_AVE_PUBLIC_IP"></a> [AVE\_PUBLIC\_IP](#input\_AVE\_PUBLIC\_IP) | n/a | `string` | `"true"` | no |
| <a name="input_DDVE_PPDD_NFS_PATH"></a> [DDVE\_PPDD\_NFS\_PATH](#input\_DDVE\_PPDD\_NFS\_PATH) | n/a | `string` | `"/data/col1/powerprotect"` | no |
| <a name="input_LINUX_ADMIN_USERNAME"></a> [LINUX\_ADMIN\_USERNAME](#input\_LINUX\_ADMIN\_USERNAME) | n/a | `string` | `"ubuntu"` | no |
| <a name="input_LINUX_DATA_DISKS"></a> [LINUX\_DATA\_DISKS](#input\_LINUX\_DATA\_DISKS) | n/a | `list(string)` | `[]` | no |
| <a name="input_LINUX_HOSTNAME"></a> [LINUX\_HOSTNAME](#input\_LINUX\_HOSTNAME) | n/a | `string` | `"client1"` | no |
| <a name="input_LINUX_IMAGE"></a> [LINUX\_IMAGE](#input\_LINUX\_IMAGE) | n/a | `map(any)` | <pre>{<br>  "offer": "UbuntuServer",<br>  "publisher": "Canonical",<br>  "sku": "18.04-LTS",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_LINUX_PRIVATE_IP"></a> [LINUX\_PRIVATE\_IP](#input\_LINUX\_PRIVATE\_IP) | IP for linux instance | `string` | `"10.10.8.12"` | no |
| <a name="input_LINUX_VM_SIZE"></a> [LINUX\_VM\_SIZE](#input\_LINUX\_VM\_SIZE) | n/a | `string` | `"Standard_DS1_v2"` | no |
| <a name="input_NVE_DATA_DISKS"></a> [NVE\_DATA\_DISKS](#input\_NVE\_DATA\_DISKS) | n/a | `list(string)` | <pre>[<br>  "600"<br>]</pre> | no |
| <a name="input_NVE_HOSTNAME"></a> [NVE\_HOSTNAME](#input\_NVE\_HOSTNAME) | n/a | `string` | `"nve1"` | no |
| <a name="input_NVE_IMAGE"></a> [NVE\_IMAGE](#input\_NVE\_IMAGE) | n/a | `map(any)` | <pre>{<br>  "offer": "dell-emc-networker-virtual-edition",<br>  "publisher": "dellemc",<br>  "sku": "dell-emc-networker-virtual-edition",<br>  "version": "19.4.25"<br>}</pre> | no |
| <a name="input_NVE_INITIAL_PASSWORD"></a> [NVE\_INITIAL\_PASSWORD](#input\_NVE\_INITIAL\_PASSWORD) | n/a | `string` | `"Change_Me12345_"` | no |
| <a name="input_NVE_PRIVATE_IP"></a> [NVE\_PRIVATE\_IP](#input\_NVE\_PRIVATE\_IP) | IP for NVE instance | `string` | `"10.10.8.10"` | no |
| <a name="input_NVE_PUBLIC_IP"></a> [NVE\_PUBLIC\_IP](#input\_NVE\_PUBLIC\_IP) | n/a | `string` | `"false"` | no |
| <a name="input_NVE_TCP_INBOUND_RULES_INET"></a> [NVE\_TCP\_INBOUND\_RULES\_INET](#input\_NVE\_TCP\_INBOUND\_RULES\_INET) | n/a | `list(string)` | `[]` | no |
| <a name="input_NVE_VM_SIZE"></a> [NVE\_VM\_SIZE](#input\_NVE\_VM\_SIZE) | n/a | `string` | `"Standard_D8s_v3"` | no |
| <a name="input_aks_count"></a> [aks\_count](#input\_aks\_count) | will deploy AKS Clusters when number greater 0. Number indicates number of AKS Clusters | `number` | `0` | no |
| <a name="input_aks_private_cluster"></a> [aks\_private\_cluster](#input\_aks\_private\_cluster) | Determines weather AKS Cluster is Private, currently not supported | `bool` | `false` | no |
| <a name="input_aks_private_dns_zone_id"></a> [aks\_private\_dns\_zone\_id](#input\_aks\_private\_dns\_zone\_id) | the Zone ID for AKS, currently not supported | `any` | `null` | no |
| <a name="input_aks_subnet"></a> [aks\_subnet](#input\_aks\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.6.0/24"<br>]</pre> | no |
| <a name="input_ave_gsan_disks"></a> [ave\_gsan\_disks](#input\_ave\_gsan\_disks) | n/a | `list` | <pre>[<br>  "250",<br>  "250",<br>  "250"<br>]</pre> | no |
| <a name="input_ave_initial_password"></a> [ave\_initial\_password](#input\_ave\_initial\_password) | n/a | `string` | `"Change_Me12345_"` | no |
| <a name="input_ave_private_ip"></a> [ave\_private\_ip](#input\_ave\_private\_ip) | IP for AVE instance | `string` | `"10.10.8.5"` | no |
| <a name="input_ave_vm_size"></a> [ave\_vm\_size](#input\_ave\_vm\_size) | n/a | `string` | `"Standard_D4s_v3"` | no |
| <a name="input_azure_bastion_subnet"></a> [azure\_bastion\_subnet](#input\_azure\_bastion\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.0.224/27"<br>]</pre> | no |
| <a name="input_azure_environment"></a> [azure\_environment](#input\_azure\_environment) | The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment | `string` | `"public"` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `any` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | n/a | `any` | n/a | yes |
| <a name="input_create_ave"></a> [create\_ave](#input\_create\_ave) | n/a | `bool` | `false` | no |
| <a name="input_create_linux"></a> [create\_linux](#input\_create\_linux) | a demo linux client | `bool` | `false` | no |
| <a name="input_create_networks"></a> [create\_networks](#input\_create\_networks) | if set to true, we will create networks in the environment | `bool` | `false` | no |
| <a name="input_create_nve"></a> [create\_nve](#input\_create\_nve) | n/a | `bool` | `false` | no |
| <a name="input_create_s2s_vpn"></a> [create\_s2s\_vpn](#input\_create\_s2s\_vpn) | n/a | `bool` | `false` | no |
| <a name="input_ddve_count"></a> [ddve\_count](#input\_ddve\_count) | will deploy DDVE when number greater 0. Number indicates number of DDVE Instances | `number` | `0` | no |
| <a name="input_ddve_password"></a> [ddve\_initial\_password](#input\_ddve\_initial\_password) | n/a | `string` | `"Change_Me12345_"` | no |
| <a name="input_ddve_meta_disks"></a> [ddve\_meta\_disks](#input\_ddve\_meta\_disks) | n/a | `list(string)` | <pre>[<br>  "1023",<br>  "250",<br>  "250"<br>]</pre> | no |
| <a name="input_ddve_public_ip"></a> [ddve\_public\_ip](#input\_ddve\_public\_ip) | n/a | `string` | `"false"` | no |
| <a name="input_ddve_tcp_inbound_rules_Inet"></a> [ddve\_tcp\_inbound\_rules\_Inet](#input\_ddve\_tcp\_inbound\_rules\_Inet) | n/a | `list(string)` | <pre>[<br>  "22",<br>  "2049",<br>  "2051",<br>  "3009",<br>  "443"<br>]</pre> | no |
| <a name="input_ddve_type"></a> [ddve\_type](#input\_ddve\_type) | DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE','16 TB DDVE PERF', '32 TB DDVE PERF', '96 TB DDVE PERF', '256 TB DDVE PERF' | `string` | `"16 TB DDVE"` | no |
| <a name="input_ddve_version"></a> [ddve\_version](#input\_ddve\_version) | DDVE Version, can be: '7.7.007', '7.6.007', '7.6.005', '7.5.010' | `string` | `"7.7.007"` | no |
| <a name="input_dns_suffix"></a> [dns\_suffix](#input\_dns\_suffix) | the DNS suffig when we create a network with internal dns | `any` | n/a | yes |
| <a name="input_enable_aks_subnet"></a> [enable\_aks\_subnet](#input\_enable\_aks\_subnet) | If set to true, create subnet for aks | `bool` | `true` | no |
| <a name="input_enable_tkg_controlplane_subnet"></a> [enable\_tkg\_controlplane\_subnet](#input\_enable\_tkg\_controlplane\_subnet) | If set to true, create subnet for tkg controlplane | `bool` | `false` | no |
| <a name="input_enable_tkg_workload_subnet"></a> [enable\_tkg\_workload\_subnet](#input\_enable\_tkg\_workload\_subnet) | If set to true, create subnet for tkg workload | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_file_uris_cs"></a> [file\_uris\_cs](#input\_file\_uris\_cs) | n/a | `string` | n/a | yes |
| <a name="input_infrastructure_subnet"></a> [infrastructure\_subnet](#input\_infrastructure\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.8.0/26"<br>]</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `any` | n/a | yes |
| <a name="input_network_rg_name"></a> [network\_rg\_name](#input\_network\_rg\_name) | The RG for Network if different is used | `any` | `null` | no |
| <a name="input_networks_aks_subnet_id"></a> [networks\_aks\_subnet\_id](#input\_networks\_aks\_subnet\_id) | The AKS Subnet ID if not deployed from Module | `string` | `""` | no |
| <a name="input_networks_dns_zone_name"></a> [networks\_dns\_zone\_name](#input\_networks\_dns\_zone\_name) | n/a | `any` | `null` | no |
| <a name="input_networks_infrastructure_subnet_id"></a> [networks\_infrastructure\_subnet\_id](#input\_networks\_infrastructure\_subnet\_id) | n/a | `any` | `null` | no |
| <a name="input_networks_resource_group_name"></a> [networks\_resource\_group\_name](#input\_networks\_resource\_group\_name) | n/a | `any` | `null` | no |
| <a name="input_ppdm_count"></a> [ppdm\_count](#input\_ppdm\_count) | will deploy PPDM when number greater 0. Number indicates number of PPDM Instances | `number` | `0` | no |
| <a name="input_ppdm_initial_password"></a> [ppdm\_initial\_password](#input\_ppdm\_initial\_password) | for use only if ansible playbooks shall hide password | `string` | `"Change_Me12345_"` | no |
| <a name="input_ppdm_public_ip"></a> [ppdm\_public\_ip](#input\_ppdm\_public\_ip) | must we assign a public ip to ppdm | `bool` | `false` | no |
| <a name="input_ppdm_version"></a> [ppdm\_version](#input\_ppdm\_version) | PPDM Version, can be: '19.9.0', '19.8.0', '19.6.0' | `string` | `"19.9.0"` | no |
| <a name="input_storage_account_cs"></a> [storage\_account\_cs](#input\_storage\_account\_cs) | n/a | `any` | n/a | yes |
| <a name="input_storage_account_key_cs"></a> [storage\_account\_key\_cs](#input\_storage\_account\_key\_cs) | n/a | `any` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | n/a | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `any` | n/a | yes |
| <a name="input_tkg_controlplane_subnet"></a> [tkg\_controlplane\_subnet](#input\_tkg\_controlplane\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.2.0/24"<br>]</pre> | no |
| <a name="input_tkg_workload_subnet"></a> [tkg\_workload\_subnet](#input\_tkg\_workload\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.4.0/24"<br>]</pre> | no |
| <a name="input_tunnel1_preshared_key"></a> [tunnel1\_preshared\_key](#input\_tunnel1\_preshared\_key) | n/a | `any` | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | n/a | `list(any)` | <pre>[<br>  "10.10.0.0/16"<br>]</pre> | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | n/a | `any` | `null` | no |
| <a name="input_vpn_destination_cidr_blocks"></a> [vpn\_destination\_cidr\_blocks](#input\_vpn\_destination\_cidr\_blocks) | the cidr blocks as string !!! for the destination route in you local network, when s2s\_vpn is deployed | `list(string)` | `[]` | no |
| <a name="input_vpn_subnet"></a> [vpn\_subnet](#input\_vpn\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.12.0/24"<br>]</pre> | no |
| <a name="input_wan_ip"></a> [wan\_ip](#input\_wan\_ip) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AKS_KUBE_API"></a> [AKS\_KUBE\_API](#output\_AKS\_KUBE\_API) | first API Seyrver |
| <a name="output_AKS_KUBE_CONFIG"></a> [AKS\_KUBE\_CONFIG](#output\_AKS\_KUBE\_CONFIG) | first cluster kubeconfig |
| <a name="output_AZURE_SUBSCRIPTION_ID"></a> [AZURE\_SUBSCRIPTION\_ID](#output\_AZURE\_SUBSCRIPTION\_ID) | n/a |
| <a name="output_DDVE_PRIVATE_FQDN"></a> [DDVE\_PRIVATE\_FQDN](#output\_DDVE\_PRIVATE\_FQDN) | the private FQDN of the first DDVE |
| <a name="output_DDVE_PRIVATE_IP"></a> [DDVE\_PRIVATE\_IP](#output\_DDVE\_PRIVATE\_IP) | The private ip address for the first DDVE Instance |
| <a name="output_DDVE_PUBLIC_FQDN"></a> [DDVE\_PUBLIC\_FQDN](#output\_DDVE\_PUBLIC\_FQDN) | we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work |
| <a name="output_DDVE_SSH_PRIVATE_KEY"></a> [DDVE\_SSH\_PRIVATE\_KEY](#output\_DDVE\_SSH\_PRIVATE\_KEY) | The ssh private key for the DDVE Instance |
| <a name="output_DDVE_SSH_PUBLIC_KEY"></a> [DDVE\_SSH\_PUBLIC\_KEY](#output\_DDVE\_SSH\_PUBLIC\_KEY) | The ssh public key for the DDVE Instance |
| <a name="output_DEPLOYMENT_DOMAIN"></a> [DEPLOYMENT\_DOMAIN](#output\_DEPLOYMENT\_DOMAIN) | n/a |
| <a name="output_K8S_CLUSTER_NAME"></a> [K8S\_CLUSTER\_NAME](#output\_K8S\_CLUSTER\_NAME) | The Name of the K8S Cluster |
| <a name="output_K8S_FQDN"></a> [K8S\_FQDN](#output\_K8S\_FQDN) | the FQDN of the AKS Cluster |
| <a name="output_NVE_PRIVATE_IP"></a> [NVE\_PRIVATE\_IP](#output\_NVE\_PRIVATE\_IP) | n/a |
| <a name="output_NVE_PUBLIC_FQDN"></a> [NVE\_PUBLIC\_FQDN](#output\_NVE\_PUBLIC\_FQDN) | n/a |
| <a name="output_PPDM_FQDN"></a> [PPDM\_FQDN](#output\_PPDM\_FQDN) | we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work |
| <a name="output_PPDM_HOSTNAME"></a> [PPDM\_HOSTNAME](#output\_PPDM\_HOSTNAME) | The private ip address for the first ppdm Instance |
| <a name="output_PPDM_PRIVATE_FQDN"></a> [PPDM\_PRIVATE\_FQDN](#output\_PPDM\_PRIVATE\_FQDN) | n/a |
| <a name="output_PPDM_PRIVATE_IP"></a> [PPDM\_PRIVATE\_IP](#output\_PPDM\_PRIVATE\_IP) | The private ip address for the first ppdm Instance |
| <a name="output_PPDM_PUBLIC_IP_ADDRESS"></a> [PPDM\_PUBLIC\_IP\_ADDRESS](#output\_PPDM\_PUBLIC\_IP\_ADDRESS) | n/a |
| <a name="output_PPDM_SSH_PRIVATE_KEY"></a> [PPDM\_SSH\_PRIVATE\_KEY](#output\_PPDM\_SSH\_PRIVATE\_KEY) | n/a |
| <a name="output_PPDM_SSH_PUBLIC_KEY"></a> [PPDM\_SSH\_PUBLIC\_KEY](#output\_PPDM\_SSH\_PUBLIC\_KEY) | n/a |
| <a name="output_RESOURCE_GROUP"></a> [RESOURCE\_GROUP](#output\_RESOURCE\_GROUP) | n/a |
| <a name="output_aks_cluster_name"></a> [aks\_cluster\_name](#output\_aks\_cluster\_name) | all Kubernetes Cluster Names |
| <a name="output_aks_kube_api"></a> [aks\_kube\_api](#output\_aks\_kube\_api) | all API Servers |
| <a name="output_aks_kube_config"></a> [aks\_kube\_config](#output\_aks\_kube\_config) | all kubeconfigs |
| <a name="output_ave_private_ip"></a> [ave\_private\_ip](#output\_ave\_private\_ip) | The sprivate ip address for the AVE Instance |
| <a name="output_ave_ssh_private_key"></a> [ave\_ssh\_private\_key](#output\_ave\_ssh\_private\_key) | The ssh private key for the AVE Instance |
| <a name="output_ave_ssh_public_key"></a> [ave\_ssh\_public\_key](#output\_ave\_ssh\_public\_key) | The ssh public key for the AVE Instance |
| <a name="output_ddve_private_fqdn"></a> [ddve\_private\_fqdn](#output\_ddve\_private\_fqdn) | the private FQDN of the DDVE´s |
| <a name="output_ddve_private_ip"></a> [ddve\_private\_ip](#output\_ddve\_private\_ip) | The private ip addresses for the DDVE Instances |
| <a name="output_ddve_public_fqdn"></a> [ddve\_public\_fqdn](#output\_ddve\_public\_fqdn) | the private FQDN of the DDVE´s |
| <a name="output_ddve_ssh_private_key"></a> [ddve\_ssh\_private\_key](#output\_ddve\_ssh\_private\_key) | The ssh private key´s for the DDVE Instances |
| <a name="output_ddve_ssh_public_key"></a> [ddve\_ssh\_public\_key](#output\_ddve\_ssh\_public\_key) | The ssh public keys for the DDVE Instances |
| <a name="output_k8s_fqdn"></a> [k8s\_fqdn](#output\_k8s\_fqdn) | FQDN´s of the All AKS Clusters |
| <a name="output_nve_ssh_private_key"></a> [nve\_ssh\_private\_key](#output\_nve\_ssh\_private\_key) | n/a |
| <a name="output_nve_ssh_public_key"></a> [nve\_ssh\_public\_key](#output\_nve\_ssh\_public\_key) | n/a |
| <a name="output_ppdm_fqdn"></a> [ppdm\_fqdn](#output\_ppdm\_fqdn) | n/a |
| <a name="output_ppdm_hostname"></a> [ppdm\_hostname](#output\_ppdm\_hostname) | The private ip address for the first ppdm Instance |
| <a name="output_ppdm_initial_password"></a> [ppdm\_initial\_password](#output\_ppdm\_initial\_password) | n/a |
| <a name="output_ppdm_private_ip"></a> [ppdm\_private\_ip](#output\_ppdm\_private\_ip) | The private ip address for all ppdm Instances |
| <a name="output_ppdm_public_ip_address"></a> [ppdm\_public\_ip\_address](#output\_ppdm\_public\_ip\_address) | n/a |
| <a name="output_ppdm_ssh_private_key"></a> [ppdm\_ssh\_private\_key](#output\_ppdm\_ssh\_private\_key) | n/a |
| <a name="output_ppdm_ssh_public_key"></a> [ppdm\_ssh\_public\_key](#output\_ppdm\_ssh\_public\_key) | n/a |
| <a name="output_vpn_public_ip"></a> [vpn\_public\_ip](#output\_vpn\_public\_ip) | The IP of the VPN Vnet Gateway |


## usage




```bash
cd terraforming-dps/terraforming-azure
```
create a [terraform.tfvars](./terraforming_ddve/terraform.tfvars.example) file 
or [terraform.tfvars.json](./terraform.tfvars.json.example) file 
with the minimum content: