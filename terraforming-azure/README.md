# terraforming-azure

terrafroming-azure is a set of terraform modules to deploy Dell DPS Products to Azure 

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.94 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ./modules/aks | n/a |
| <a name="module_ave"></a> [ave](#module\_ave) | ./modules/ave | n/a |
| <a name="module_crs_s2s_vpn"></a> [crs\_s2s\_vpn](#module\_crs\_s2s\_vpn) | ./modules/s2s_vpn | n/a |
| <a name="module_ddve"></a> [ddve](#module\_ddve) | ./modules/ddve | n/a |
| <a name="module_linux"></a> [linux](#module\_linux) | ./modules/linux | n/a |
| <a name="module_networks"></a> [networks](#module\_networks) | ./modules/networks | n/a |
| <a name="module_nve"></a> [nve](#module\_nve) | ./modules/nve | n/a |
| <a name="module_ppdm"></a> [ppdm](#module\_ppdm) | ./modules/ppdm | n/a |
| <a name="module_s2s_vpn"></a> [s2s\_vpn](#module\_s2s\_vpn) | ./modules/s2s_vpn | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_LINUX_ADMIN_USERNAME"></a> [LINUX\_ADMIN\_USERNAME](#input\_LINUX\_ADMIN\_USERNAME) | n/a | `string` | `"ubuntu"` | no |
| <a name="input_LINUX_DATA_DISKS"></a> [LINUX\_DATA\_DISKS](#input\_LINUX\_DATA\_DISKS) | n/a | `list(string)` | `[]` | no |
| <a name="input_LINUX_HOSTNAME"></a> [LINUX\_HOSTNAME](#input\_LINUX\_HOSTNAME) | n/a | `string` | `"client1"` | no |
| <a name="input_LINUX_IMAGE"></a> [LINUX\_IMAGE](#input\_LINUX\_IMAGE) | n/a | `map(any)` | <pre>{<br>  "offer": "UbuntuServer",<br>  "publisher": "Canonical",<br>  "sku": "18.04-LTS",<br>  "version": "latest"<br>}</pre> | no |
| <a name="input_LINUX_PRIVATE_IP"></a> [LINUX\_PRIVATE\_IP](#input\_LINUX\_PRIVATE\_IP) | IP for linux instance | `string` | `"10.10.8.12"` | no |
| <a name="input_LINUX_VM_SIZE"></a> [LINUX\_VM\_SIZE](#input\_LINUX\_VM\_SIZE) | n/a | `string` | `"Standard_DS1_v2"` | no |
| <a name="input_aks_count"></a> [aks\_count](#input\_aks\_count) | will deploy AKS Clusters when number greater 0. Number indicates number of AKS Clusters | `number` | `0` | no |
| <a name="input_aks_private_cluster"></a> [aks\_private\_cluster](#input\_aks\_private\_cluster) | Determines weather AKS Cluster is Private, currently not supported | `bool` | `false` | no |
| <a name="input_aks_private_dns_zone_id"></a> [aks\_private\_dns\_zone\_id](#input\_aks\_private\_dns\_zone\_id) | the Zone ID for AKS, currently not supported | `any` | `null` | no |
| <a name="input_aks_subnet"></a> [aks\_subnet](#input\_aks\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.6.0/24"<br>]</pre> | no |
| <a name="input_ave_count"></a> [ave\_count](#input\_ave\_count) | will deploy AVE when number greater 0. Number indicates number of AVE Instances | `number` | `0` | no |
| <a name="input_ave_initial_password"></a> [ave\_initial\_password](#input\_ave\_initial\_password) | n/a | `string` | `"Change_Me12345_"` | no |
| <a name="input_ave_public_ip"></a> [ave\_public\_ip](#input\_ave\_public\_ip) | n/a | `string` | `"false"` | no |
| <a name="input_ave_tcp_inbound_rules_Inet"></a> [ave\_tcp\_inbound\_rules\_Inet](#input\_ave\_tcp\_inbound\_rules\_Inet) | inbound Traffic rule for Security Group from Internet | `list(string)` | <pre>[<br>  "22",<br>  "443"<br>]</pre> | no |
| <a name="input_ave_type"></a> [ave\_type](#input\_ave\_type) | AVE Type, can be: '0.5 TB AVE', '1 TB AVE', '2 TB AVE', '4 TB AVE','8 TB AVE','16 TB AVE' | `string` | `"0.5 TB AVE"` | no |
| <a name="input_ave_version"></a> [ave\_version](#input\_ave\_version) | AVE Version, can be: '19.7.0', '19.4.02', '19.3.03', '19.2.04' | `string` | `"19.7.0"` | no |
| <a name="input_azure_bastion_subnet"></a> [azure\_bastion\_subnet](#input\_azure\_bastion\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.0.224/27"<br>]</pre> | no |
| <a name="input_azure_environment"></a> [azure\_environment](#input\_azure\_environment) | The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment | `string` | `"public"` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | n/a | `any` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | n/a | `any` | n/a | yes |
| <a name="input_create_bastion"></a> [create\_bastion](#input\_create\_bastion) | n/a | `bool` | `false` | no |
| <a name="input_create_crs_s2s_vpn"></a> [create\_crs\_s2s\_vpn](#input\_create\_crs\_s2s\_vpn) | Do you want to create a Cyber Vault | `bool` | `false` | no |
| <a name="input_create_linux"></a> [create\_linux](#input\_create\_linux) | a demo linux client | `bool` | `false` | no |
| <a name="input_create_networks"></a> [create\_networks](#input\_create\_networks) | if set to true, we will create networks in the environment | `bool` | `false` | no |
| <a name="input_create_s2s_vpn"></a> [create\_s2s\_vpn](#input\_create\_s2s\_vpn) | n/a | `bool` | `false` | no |
| <a name="input_crs_network_rg_name"></a> [crs\_network\_rg\_name](#input\_crs\_network\_rg\_name) | name of the existing vnet | `string` | `""` | no |
| <a name="input_crs_tunnel1_preshared_key"></a> [crs\_tunnel1\_preshared\_key](#input\_crs\_tunnel1\_preshared\_key) | the preshared key for teh vpn tunnel when deploying S2S VPN | `string` | `""` | no |
| <a name="input_crs_vnet_name"></a> [crs\_vnet\_name](#input\_crs\_vnet\_name) | name of the existing vnet | `string` | `""` | no |
| <a name="input_crs_vpn_destination_cidr_blocks"></a> [crs\_vpn\_destination\_cidr\_blocks](#input\_crs\_vpn\_destination\_cidr\_blocks) | the cidr blocks as string !!! for the destination route in you local network, when s2s\_vpn is deployed | `list(string)` | `[]` | no |
| <a name="input_crs_vpn_subnet"></a> [crs\_vpn\_subnet](#input\_crs\_vpn\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.150.1.0/24"<br>]</pre> | no |
| <a name="input_crs_wan_ip"></a> [crs\_wan\_ip](#input\_crs\_wan\_ip) | The IP of your VPN Device if S2S VPN | `any` | n/a | yes |
| <a name="input_ddve_count"></a> [ddve\_count](#input\_ddve\_count) | will deploy DDVE when number greater 0. Number indicates number of DDVE Instances | `number` | `0` | no |
| <a name="input_ddve_initial_password"></a> [ddve\_initial\_password](#input\_ddve\_initial\_password) | the initial Password for Datadomain. It will be exposed to output as DDVE\_PASSWORD for further Configuration. <br>As DD will be confiured with SSH, the Password must be changed from changeme | `string` | `"Change_Me12345_"` | no |
| <a name="input_ddve_meta_disks"></a> [ddve\_meta\_disks](#input\_ddve\_meta\_disks) | n/a | `list(string)` | <pre>[<br>  "1023",<br>  "1023"<br>]</pre> | no |
| <a name="input_ddve_public_ip"></a> [ddve\_public\_ip](#input\_ddve\_public\_ip) | Enable Public IP on Datadomain Network Interface | `string` | `"false"` | no |
| <a name="input_ddve_tcp_inbound_rules_Inet"></a> [ddve\_tcp\_inbound\_rules\_Inet](#input\_ddve\_tcp\_inbound\_rules\_Inet) | inbound Traffic rule for Security Group from Internet | `list(string)` | <pre>[<br>  "22",<br>  "443"<br>]</pre> | no |
| <a name="input_ddve_type"></a> [ddve\_type](#input\_ddve\_type) | DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE','16 TB DDVE PERF', '32 TB DDVE PERF', '96 TB DDVE PERF', '256 TB DDVE PERF' | `string` | `"16 TB DDVE"` | no |
| <a name="input_ddve_version"></a> [ddve\_version](#input\_ddve\_version) | DDVE Version, can be: '7.9.000', '7.8.020', '7.7.110', '7.10.000', '7.11.000', '7.2.0060' | `string` | `"7.11.000"` | no |
| <a name="input_dns_suffix"></a> [dns\_suffix](#input\_dns\_suffix) | the DNS suffig when we create a network with internal dns | `any` | n/a | yes |
| <a name="input_enable_aks_subnet"></a> [enable\_aks\_subnet](#input\_enable\_aks\_subnet) | If set to true, create subnet for aks | `bool` | `true` | no |
| <a name="input_enable_tkg_controlplane_subnet"></a> [enable\_tkg\_controlplane\_subnet](#input\_enable\_tkg\_controlplane\_subnet) | If set to true, create subnet for tkg controlplane | `bool` | `false` | no |
| <a name="input_enable_tkg_workload_subnet"></a> [enable\_tkg\_workload\_subnet](#input\_enable\_tkg\_workload\_subnet) | If set to true, create subnet for tkg workload | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_file_uris_cs"></a> [file\_uris\_cs](#input\_file\_uris\_cs) | File uri for custom script extension with linux | `string` | `null` | no |
| <a name="input_infrastructure_subnet"></a> [infrastructure\_subnet](#input\_infrastructure\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.8.0/26"<br>]</pre> | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `any` | n/a | yes |
| <a name="input_network_rg_name"></a> [network\_rg\_name](#input\_network\_rg\_name) | The RG for Network if different is used | `any` | `null` | no |
| <a name="input_networks_aks_subnet_id"></a> [networks\_aks\_subnet\_id](#input\_networks\_aks\_subnet\_id) | The AKS Subnet ID if not deployed from Module | `string` | `""` | no |
| <a name="input_networks_dns_zone_name"></a> [networks\_dns\_zone\_name](#input\_networks\_dns\_zone\_name) | n/a | `any` | `null` | no |
| <a name="input_networks_infrastructure_subnet_id"></a> [networks\_infrastructure\_subnet\_id](#input\_networks\_infrastructure\_subnet\_id) | n/a | `any` | `null` | no |
| <a name="input_networks_resource_group_name"></a> [networks\_resource\_group\_name](#input\_networks\_resource\_group\_name) | n/a | `any` | `null` | no |
| <a name="input_nve_count"></a> [nve\_count](#input\_nve\_count) | will deploy NVE when number greater 0. Number indicates number of NVE Instances | `number` | `0` | no |
| <a name="input_nve_initial_password"></a> [nve\_initial\_password](#input\_nve\_initial\_password) | n/a | `string` | `"Change_Me12345_"` | no |
| <a name="input_nve_public_ip"></a> [nve\_public\_ip](#input\_nve\_public\_ip) | n/a | `string` | `"false"` | no |
| <a name="input_nve_tcp_inbound_rules_Inet"></a> [nve\_tcp\_inbound\_rules\_Inet](#input\_nve\_tcp\_inbound\_rules\_Inet) | inbound Traffic rule for Security Group from Internet | `list(string)` | <pre>[<br>  "22",<br>  "443"<br>]</pre> | no |
| <a name="input_nve_type"></a> [nve\_type](#input\_nve\_type) | NVE Type, can be: 'SMALL', 'MEDIUM', 'HIGH', , see Networker Virtual Edition Deployment Guide for more | `string` | `"SMALL"` | no |
| <a name="input_nve_version"></a> [nve\_version](#input\_nve\_version) | NVE Version, can be: '19.7.0', '19.6.49', '19.5.154' | `string` | `"19.6.49"` | no |
| <a name="input_ppdm_count"></a> [ppdm\_count](#input\_ppdm\_count) | will deploy PPDM when number greater 0. Number indicates number of PPDM Instances | `number` | `0` | no |
| <a name="input_ppdm_initial_password"></a> [ppdm\_initial\_password](#input\_ppdm\_initial\_password) | for use only if ansible playbooks shall hide password | `string` | `"Change_Me12345_"` | no |
| <a name="input_ppdm_public_ip"></a> [ppdm\_public\_ip](#input\_ppdm\_public\_ip) | must we assign a public ip to ppdm | `bool` | `false` | no |
| <a name="input_ppdm_version"></a> [ppdm\_version](#input\_ppdm\_version) | PPDM Version, can be: '19.11.0', '19.12.1', '19.13.0' | `string` | `"19.13.0"` | no |
| <a name="input_storage_account_cs"></a> [storage\_account\_cs](#input\_storage\_account\_cs) | Storage account when using custom script extension with linux | `string` | `null` | no |
| <a name="input_storage_account_key_cs"></a> [storage\_account\_key\_cs](#input\_storage\_account\_key\_cs) | Storage account key when using custom script extension with linux | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | n/a | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `any` | n/a | yes |
| <a name="input_tkg_controlplane_subnet"></a> [tkg\_controlplane\_subnet](#input\_tkg\_controlplane\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.2.0/24"<br>]</pre> | no |
| <a name="input_tkg_workload_subnet"></a> [tkg\_workload\_subnet](#input\_tkg\_workload\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.4.0/24"<br>]</pre> | no |
| <a name="input_tunnel1_preshared_key"></a> [tunnel1\_preshared\_key](#input\_tunnel1\_preshared\_key) | n/a | `any` | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | n/a | `list(any)` | <pre>[<br>  "10.10.0.0/16",<br>  "fd00:db8:deca:daed::/64"<br>]</pre> | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | n/a | `any` | `null` | no |
| <a name="input_vpn_destination_cidr_blocks"></a> [vpn\_destination\_cidr\_blocks](#input\_vpn\_destination\_cidr\_blocks) | the cidr blocks as string !!! for the destination route in you local network, when s2s\_vpn is deployed | `list(string)` | `[]` | no |
| <a name="input_vpn_subnet"></a> [vpn\_subnet](#input\_vpn\_subnet) | n/a | `list(string)` | <pre>[<br>  "10.10.12.0/24"<br>]</pre> | no |
| <a name="input_wan_ip"></a> [wan\_ip](#input\_wan\_ip) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AKS_KUBE_API"></a> [AKS\_KUBE\_API](#output\_AKS\_KUBE\_API) | first API Seyrver |
| <a name="output_AKS_KUBE_CONFIG"></a> [AKS\_KUBE\_CONFIG](#output\_AKS\_KUBE\_CONFIG) | first cluster kubeconfig |
| <a name="output_AVE_PASSWORD"></a> [AVE\_PASSWORD](#output\_AVE\_PASSWORD) | n/a |
| <a name="output_AVE_PRIVATE_FQDN"></a> [AVE\_PRIVATE\_FQDN](#output\_AVE\_PRIVATE\_FQDN) | the private FQDN of the first AVE |
| <a name="output_AVE_PRIVATE_IP"></a> [AVE\_PRIVATE\_IP](#output\_AVE\_PRIVATE\_IP) | The private ip address for the first AVE Instance |
| <a name="output_AVE_PUBLIC_FQDN"></a> [AVE\_PUBLIC\_FQDN](#output\_AVE\_PUBLIC\_FQDN) | we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work |
| <a name="output_AVE_PUBLIC_IP"></a> [AVE\_PUBLIC\_IP](#output\_AVE\_PUBLIC\_IP) | we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work |
| <a name="output_AVE_SSH_PRIVATE_KEY"></a> [AVE\_SSH\_PRIVATE\_KEY](#output\_AVE\_SSH\_PRIVATE\_KEY) | The ssh private key for the AVE Instance |
| <a name="output_AVE_SSH_PUBLIC_KEY"></a> [AVE\_SSH\_PUBLIC\_KEY](#output\_AVE\_SSH\_PUBLIC\_KEY) | The ssh public key for the AVE Instance |
| <a name="output_AZURE_SUBSCRIPTION_ID"></a> [AZURE\_SUBSCRIPTION\_ID](#output\_AZURE\_SUBSCRIPTION\_ID) | n/a |
| <a name="output_DDVE_ATOS_CONTAINER"></a> [DDVE\_ATOS\_CONTAINER](#output\_DDVE\_ATOS\_CONTAINER) | n/a |
| <a name="output_DDVE_ATOS_STORAGE_ACCOUNT"></a> [DDVE\_ATOS\_STORAGE\_ACCOUNT](#output\_DDVE\_ATOS\_STORAGE\_ACCOUNT) | n/a |
| <a name="output_DDVE_PASSWORD"></a> [DDVE\_PASSWORD](#output\_DDVE\_PASSWORD) | n/a |
| <a name="output_DDVE_PRIVATE_FQDN"></a> [DDVE\_PRIVATE\_FQDN](#output\_DDVE\_PRIVATE\_FQDN) | the private FQDN of the first DDVE |
| <a name="output_DDVE_PRIVATE_IP"></a> [DDVE\_PRIVATE\_IP](#output\_DDVE\_PRIVATE\_IP) | The private ip address for the first DDVE Instance |
| <a name="output_DDVE_PUBLIC_FQDN"></a> [DDVE\_PUBLIC\_FQDN](#output\_DDVE\_PUBLIC\_FQDN) | we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work |
| <a name="output_DDVE_SSH_PRIVATE_KEY"></a> [DDVE\_SSH\_PRIVATE\_KEY](#output\_DDVE\_SSH\_PRIVATE\_KEY) | The ssh private key for the DDVE Instance |
| <a name="output_DDVE_SSH_PUBLIC_KEY"></a> [DDVE\_SSH\_PUBLIC\_KEY](#output\_DDVE\_SSH\_PUBLIC\_KEY) | The ssh public key for the DDVE Instance |
| <a name="output_DEPLOYMENT_DOMAIN"></a> [DEPLOYMENT\_DOMAIN](#output\_DEPLOYMENT\_DOMAIN) | n/a |
| <a name="output_K8S_CLUSTER_NAME"></a> [K8S\_CLUSTER\_NAME](#output\_K8S\_CLUSTER\_NAME) | The Name of the K8S Cluster |
| <a name="output_K8S_FQDN"></a> [K8S\_FQDN](#output\_K8S\_FQDN) | the FQDN of the AKS Cluster |
| <a name="output_NVE_PASSWORD"></a> [NVE\_PASSWORD](#output\_NVE\_PASSWORD) | n/a |
| <a name="output_NVE_PRIVATE_FQDN"></a> [NVE\_PRIVATE\_FQDN](#output\_NVE\_PRIVATE\_FQDN) | the private FQDN of the first NVE |
| <a name="output_NVE_PRIVATE_IP"></a> [NVE\_PRIVATE\_IP](#output\_NVE\_PRIVATE\_IP) | The private ip address for the first NVE Instance |
| <a name="output_NVE_PUBLIC_FQDN"></a> [NVE\_PUBLIC\_FQDN](#output\_NVE\_PUBLIC\_FQDN) | we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work |
| <a name="output_NVE_PUBLIC_IP"></a> [NVE\_PUBLIC\_IP](#output\_NVE\_PUBLIC\_IP) | we will use the Priovate IP as FQDN if no pubblic is registered, so api calls can work |
| <a name="output_NVE_SSH_PRIVATE_KEY"></a> [NVE\_SSH\_PRIVATE\_KEY](#output\_NVE\_SSH\_PRIVATE\_KEY) | The ssh private key for the NVE Instance |
| <a name="output_NVE_SSH_PUBLIC_KEY"></a> [NVE\_SSH\_PUBLIC\_KEY](#output\_NVE\_SSH\_PUBLIC\_KEY) | The ssh public key for the NVE Instance |
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
| <a name="output_ave_private_fqdn"></a> [ave\_private\_fqdn](#output\_ave\_private\_fqdn) | the private FQDN of the AVE´s |
| <a name="output_ave_private_ip"></a> [ave\_private\_ip](#output\_ave\_private\_ip) | The private ip addresses for the AVE Instances |
| <a name="output_ave_public_fqdn"></a> [ave\_public\_fqdn](#output\_ave\_public\_fqdn) | the private FQDN of the AVE´s |
| <a name="output_ave_ssh_private_key"></a> [ave\_ssh\_private\_key](#output\_ave\_ssh\_private\_key) | The ssh private key´s for the AVE Instances |
| <a name="output_ave_ssh_public_key"></a> [ave\_ssh\_public\_key](#output\_ave\_ssh\_public\_key) | The ssh public keys for the AVE Instances |
| <a name="output_crs_vpn_public_ip"></a> [crs\_vpn\_public\_ip](#output\_crs\_vpn\_public\_ip) | The IP of the VPN Vnet Gateway |
| <a name="output_ddve_private_fqdn"></a> [ddve\_private\_fqdn](#output\_ddve\_private\_fqdn) | the private FQDN of the DDVE´s |
| <a name="output_ddve_private_ip"></a> [ddve\_private\_ip](#output\_ddve\_private\_ip) | The private ip addresses for the DDVE Instances |
| <a name="output_ddve_public_fqdn"></a> [ddve\_public\_fqdn](#output\_ddve\_public\_fqdn) | the private FQDN of the DDVE´s |
| <a name="output_ddve_ssh_private_key"></a> [ddve\_ssh\_private\_key](#output\_ddve\_ssh\_private\_key) | The ssh private key´s for the DDVE Instances |
| <a name="output_ddve_ssh_public_key"></a> [ddve\_ssh\_public\_key](#output\_ddve\_ssh\_public\_key) | The ssh public keys for the DDVE Instances |
| <a name="output_k8s_fqdn"></a> [k8s\_fqdn](#output\_k8s\_fqdn) | FQDN´s of the All AKS Clusters |
| <a name="output_nve_private_fqdn"></a> [nve\_private\_fqdn](#output\_nve\_private\_fqdn) | the private FQDN of the NVE´s |
| <a name="output_nve_private_ip"></a> [nve\_private\_ip](#output\_nve\_private\_ip) | The private ip addresses for the NVE Instances |
| <a name="output_nve_public_fqdn"></a> [nve\_public\_fqdn](#output\_nve\_public\_fqdn) | the private FQDN of the NVE´s |
| <a name="output_nve_ssh_private_key"></a> [nve\_ssh\_private\_key](#output\_nve\_ssh\_private\_key) | The ssh private key´s for the NVE Instances |
| <a name="output_nve_ssh_public_key"></a> [nve\_ssh\_public\_key](#output\_nve\_ssh\_public\_key) | The ssh public keys for the NVE Instances |
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




# After Deploment


### Configure using CLI via SSH:
for an ssh connection, use:
```bash
export DDVE_PRIVATE_FQDN=$(terraform output -raw ddve_private_ip)
terraform output ddve_ssh_private_key > ~/.ssh/ddve_key
chmod 0600 ~/.ssh/ddve_key
ssh -i ~/.ssh/ddve_key sysadmin@${DDVE_PRIVATE_FQDN}
```
Proceed with CLi configuration

#### configure using ansible
export outputs from terraform into environment variables:
```bash
export DDVE_PUBLIC_FQDN=$(terraform output -json DDVE_PRIVATE_IP  | jq -r  '.[0]')
export DDVE_USERNAME=sysadmin
export DDVE_INITIAL_PASSWORD=changeme
export DDVE_PASSWORD=Change_Me12345_
export PPDD_PASSPHRASE=Change_Me12345_!
export DDVE_PRIVATE_FQDN=$(terraform output -json DDVE_PRIVATE_IP | jq -r  '.[0]')
export PPDD_TIMEZONE="Europe/Berlin"
export DDVE_ATOS_STORAGEACCOUNT=$(terraform output -json DDVE_ATOS_STORAGE_ACCOUNT  | jq -r  '.[0]')
export DDVE_ATOS_CONTAINER=$(terraform output -json DDVE_ATOS_CONTAINER  | jq -r  '.[0]')
```


set the Initial DataDomain Password
```bash
ansible-playbook ~/workspace/ansible_ppdd/1.0-Playbook-configure-initial-password.yml
```
![image](https://user-images.githubusercontent.com/8255007/232750620-df339f28-bdac-4db2-984f-a2df1d14b38e.png)
If you have a valid dd license, set the variable PPDD_LICENSE, example:
```bash
export PPDD_LICENSE=$(cat ~/workspace/internal.lic)
ansible-playbook ~/workspace/ansible_ppdd/3.0-Playbook-set-dd-license.yml
```

next, we set the passphrase, as export it is required for ATOS
then, we will set the Timezone and the NTP to GCP NTP link local  Server
```bash
ansible-playbook ~/workspace/ansible_ppdd/2.1-Playbook-configure-ddpassphrase.yml
ansible-playbook ~/workspace/ansible_ppdd/2.1.1-Playbook-set-dd-timezone-and-ntp-azure.yml
```

Albeit there is a *ansible-playbook ~/workspace/ansible_ppdd/2.2-Playbook-configure-dd-atos-aws.yml* , we cannot use it, as the RestAPI Call to create Active Tier on Object is not available now for GCP...
Therefore us the UI Wizard

![image](https://github.com/bottkars/terraforming-dps/assets/8255007/25184d50-c0a9-48e6-a4d4-6a9b421f3b08)


use the container name and storageaccount from
```bash
echo $DDVE_ATOS_CONTAINER
echo $DDVE_ATOS_STORAGEACCOUNT
```


Add the Metadata Disks:

![image](https://github.com/bottkars/terraforming-dps/assets/8255007/b1a63be3-ac5e-4865-b44f-0392b5bc2a30)

Finish:

![image](https://github.com/bottkars/terraforming-dps/assets/8255007/fb3eefe9-5273-401e-b7a5-7824898deddd)
![image](https://github.com/bottkars/terraforming-dps/assets/8255007/4f110c2f-2d71-4146-94a4-2ad790dec72b)
once the FIlesystem is enabled, we go ahead and enable the boost Protocol ...
( below runbook will cerate filesystem on atos  in future once api is ready )
```bash
ansible-playbook ~/workspace/ansible_ppdd/2.2-Playbook-configure-dd-atos-azure.yml
```


# module_ppdm
set ppdm_count to desired number
```bash
terraform plan
```


when everything meets your requirements, run the deployment with

```bash
terraform apply --auto-approve
```


## PPDM

Similar to the DDVE Configuration, we will set Environment Variables for Ansible to Automatically Configure PPDM

```bash
# Refresh you Environment Variables if Multi Step !
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^PP+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
export PPDM_INITIAL_PASSWORD=Change_Me12345_
export PPDM_NTP_SERVERS='["time.windows.com"]'
export PPDM_SETUP_PASSWORD=admin          # default password on the Cloud PPDM rest API
export PPDM_TIMEZONE="Europe/Berlin"
export PPDM_POLICY=PPDM_GOLD


```
Set the initial Configuration:    
```bash

ansible-playbook ~/workspace/ansible_ppdm/1.0-playbook_configure_ppdm.yml
```
verify the config:

```bash
ansible-playbook ~/workspace/ansible_ppdm/1.1-playbook_get_ppdm_config.yml
```
we add the DataDomain:  

```bash
ansible-playbook ~/workspace/ansible_ppdm/2.0-playbook_set_ddve.yml 
```
we can get the sdr config after Data Domain Boost auto-configuration for primary source  from PPDM

```bash
ansible-playbook ~/workspace/ansible_ppdm/3.0-playbook_get_sdr.yml
```
and see the dr jobs status
```bash
ansible-playbook ~/workspace/ansible_ppdm/31.1-playbook_get_activities.yml --extra-vars "filter='category eq \"DISASTER_RECOVERY\"'"
```


## Appendix

### nth DD

#### configure using ansible
export outputs from terraform into environment variables:
```bash
export DDVE_PUBLIC_FQDN=$(terraform output -json DDVE_PRIVATE_IP  | jq -r  '.[1]')
export DDVE_USERNAME=sysadmin
export DDVE_INITIAL_PASSWORD=changeme
export DDVE_PASSWORD=Change_Me12345_
export PPDD_PASSPHRASE=Change_Me12345_!
export DDVE_PRIVATE_FQDN=$(terraform output -json DDVE_PRIVATE_IP | jq -r  '.[1]')
export PPDD_TIMEZONE="Europe/Berlin"
export DDVE_ATOS_STORAGEACCOUNT=$(terraform output -json DDVE_ATOS_STORAGE_ACCOUNT  | jq -r  '.[1]')
export DDVE_ATOS_CONTAINER=$(terraform output -json DDVE_ATOS_CONTAINER  | jq -r  '.[1]')
```