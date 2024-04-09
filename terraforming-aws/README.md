# Terraforming AWS: deploy AVE, DDVE and more from AWS Marketplace

This Modules can deploy Dell PowerProtect DataDomain Virtual Edition, PowerProtect DataManager, Networker Virtual Edition and Avamar Virtual edition to AWS using terraform.
Instance Sizes and Disk Count/Size will be automatically evaluated my specifying a ddve_type and ave_type.   

Individual Modules will be called from main by evaluating  Variables

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.34.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ave"></a> [ave](#module\_ave) | ./modules/ave | n/a |
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./modules/bastion | n/a |
| <a name="module_client_vpn"></a> [client\_vpn](#module\_client\_vpn) | ./modules/client_vpn | n/a |
| <a name="module_cr"></a> [cr](#module\_cr) | ./modules/cr | n/a |
| <a name="module_crs_client_vpn"></a> [crs\_client\_vpn](#module\_crs\_client\_vpn) | ./modules/client_vpn | n/a |
| <a name="module_crs_networks"></a> [crs\_networks](#module\_crs\_networks) | ./modules/networks | n/a |
| <a name="module_crs_s2s_vpn"></a> [crs\_s2s\_vpn](#module\_crs\_s2s\_vpn) | ./modules/s2s_vpn | n/a |
| <a name="module_ddmc"></a> [ddmc](#module\_ddmc) | ./modules/ddmc | n/a |
| <a name="module_ddve"></a> [ddve](#module\_ddve) | ./modules/ddve | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./modules/eks | n/a |
| <a name="module_networks"></a> [networks](#module\_networks) | ./modules/networks | n/a |
| <a name="module_nve"></a> [nve](#module\_nve) | ./modules/nve | n/a |
| <a name="module_ppdm"></a> [ppdm](#module\_ppdm) | ./modules/ppdm | n/a |
| <a name="module_s2s_vpn"></a> [s2s\_vpn](#module\_s2s\_vpn) | ./modules/s2s_vpn | n/a |
| <a name="module_vault_nve"></a> [vault\_nve](#module\_vault\_nve) | ./modules/nve | n/a |
| <a name="module_vault_ppdm"></a> [vault\_ppdm](#module\_vault\_ppdm) | ./modules/ppdm | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AVE_HOSTNAME"></a> [AVE\_HOSTNAME](#input\_AVE\_HOSTNAME) | Hotname of the AVE Machine | `string` | `"ave_terraform"` | no |
| <a name="input_BASTION_HOSTNAME"></a> [BASTION\_HOSTNAME](#input\_BASTION\_HOSTNAME) | Hotname of the PPDM Machine | `string` | `"bastion_terraform"` | no |
| <a name="input_DDMC_HOSTNAME"></a> [DDMC\_HOSTNAME](#input\_DDMC\_HOSTNAME) | Hotname of the DDMC Machine | `string` | `"ddmc_terraform"` | no |
| <a name="input_DDVE_HOSTNAME"></a> [DDVE\_HOSTNAME](#input\_DDVE\_HOSTNAME) | Hotname of the DDVE Machine | `string` | `"ddve_terraform"` | no |
| <a name="input_NVE_HOSTNAME"></a> [NVE\_HOSTNAME](#input\_NVE\_HOSTNAME) | Hostname of the nve Machine | `string` | `"nve_terraform"` | no |
| <a name="input_PPDM_HOSTNAME"></a> [PPDM\_HOSTNAME](#input\_PPDM\_HOSTNAME) | Hotname of the PPDM Machine | `string` | `"ppdm_terraform"` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | availability\_zone to use | `string` | `"eu-central-1a"` | no |
| <a name="input_ave_count"></a> [ave\_count](#input\_ave\_count) | How many AVE(s) you want to create .... | `number` | `0` | no |
| <a name="input_ave_type"></a> [ave\_type](#input\_ave\_type) | AVE Type, can be '0.5 TB AVE','1 TB AVE','2 TB AVE','4 TB AVE','8 TB AVE','16 TB AVE' | `string` | `"0.5 TB AVE"` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | n/a | `any` | n/a | yes |
| <a name="input_cr_sg_id"></a> [cr\_sg\_id](#input\_cr\_sg\_id) | id of default security group when using existing networks | `any` | `null` | no |
| <a name="input_create_bastion"></a> [create\_bastion](#input\_create\_bastion) | Do you want to create an PPDM | `bool` | `false` | no |
| <a name="input_create_client_vpn"></a> [create\_client\_vpn](#input\_create\_client\_vpn) | Create a pre-conig site2client | `bool` | `false` | no |
| <a name="input_create_crs_client_vpn"></a> [create\_crs\_client\_vpn](#input\_create\_crs\_client\_vpn) | Do you want to create a Cyber Vault | `bool` | `false` | no |
| <a name="input_create_crs_networks"></a> [create\_crs\_networks](#input\_create\_crs\_networks) | Do you want to create a VPC | `bool` | `false` | no |
| <a name="input_create_crs_s2s_vpn"></a> [create\_crs\_s2s\_vpn](#input\_create\_crs\_s2s\_vpn) | Do you want to create a Cyber Vault | `bool` | `false` | no |
| <a name="input_create_networks"></a> [create\_networks](#input\_create\_networks) | Do you want to create a VPC | `bool` | `false` | no |
| <a name="input_create_s2s_vpn"></a> [create\_s2s\_vpn](#input\_create\_s2s\_vpn) | Do you want to create a Site 2 Site VPN for default VPN Device ( e.g. UBNT-UDM Pro) | `bool` | `false` | no |
| <a name="input_create_vault"></a> [create\_vault](#input\_create\_vault) | Do you want to create a Cyber Vault | `bool` | `false` | no |
| <a name="input_crs_environment"></a> [crs\_environment](#input\_crs\_environment) | will be added to many Resource Names / Tags, should be in lower case, abc123 and - | `string` | `"crs"` | no |
| <a name="input_crs_open_sesame"></a> [crs\_open\_sesame](#input\_crs\_open\_sesame) | open 2051 to vault for creating replication context | `bool` | `false` | no |
| <a name="input_crs_private_route_table"></a> [crs\_private\_route\_table](#input\_crs\_private\_route\_table) | Private Routing table for S2S VPN | `string` | `""` | no |
| <a name="input_crs_private_subnets_cidr"></a> [crs\_private\_subnets\_cidr](#input\_crs\_private\_subnets\_cidr) | cidr of the private subnets cidrs when creating the vpc | `list(any)` | n/a | yes |
| <a name="input_crs_public_subnets_cidr"></a> [crs\_public\_subnets\_cidr](#input\_crs\_public\_subnets\_cidr) | cidr of the public subnets cidrs when creating the vpc | `list(any)` | n/a | yes |
| <a name="input_crs_subnet_id"></a> [crs\_subnet\_id](#input\_crs\_subnet\_id) | n/a | `any` | n/a | yes |
| <a name="input_crs_tunnel1_preshared_key"></a> [crs\_tunnel1\_preshared\_key](#input\_crs\_tunnel1\_preshared\_key) | the preshared key for teh vpn tunnel when deploying S2S VPN | `string` | `""` | no |
| <a name="input_crs_vault_subnet_id"></a> [crs\_vault\_subnet\_id](#input\_crs\_vault\_subnet\_id) | n/a | `any` | n/a | yes |
| <a name="input_crs_vpc_cidr"></a> [crs\_vpc\_cidr](#input\_crs\_vpc\_cidr) | n/a | `any` | n/a | yes |
| <a name="input_crs_vpc_id"></a> [crs\_vpc\_id](#input\_crs\_vpc\_id) | id of the vpc when using existing networks/vpc | `string` | `""` | no |
| <a name="input_crs_vpn_destination_cidr_blocks"></a> [crs\_vpn\_destination\_cidr\_blocks](#input\_crs\_vpn\_destination\_cidr\_blocks) | the cidr blocks as string !!! for the destination route in you local network, when s2s\_vpn is deployed | `string` | `"[]"` | no |
| <a name="input_crs_wan_ip"></a> [crs\_wan\_ip](#input\_crs\_wan\_ip) | The IP of your VPN Device if S2S VPN | `any` | n/a | yes |
| <a name="input_ddmc_count"></a> [ddmc\_count](#input\_ddmc\_count) | Do you want to create a DDMC | `number` | `0` | no |
| <a name="input_ddmc_type"></a> [ddmc\_type](#input\_ddmc\_type) | DDMC Type, can be: '12.5 Gigabit Ethernet DDMC', '10 Gigabit Ethernet DDMC' | `string` | `"12.5 Gigabit Ethernet DDMC"` | no |
| <a name="input_ddmc_version"></a> [ddmc\_version](#input\_ddmc\_version) | DDMC Version, can be: '7.13.0.10', '7.12.0.0', '7.10.1.20', '7.7.5.30','7.7.5.25' | `string` | `"7.13.0.10"` | no |
| <a name="input_ddve_count"></a> [ddve\_count](#input\_ddve\_count) | Do you want to create a DDVE | `number` | `0` | no |
| <a name="input_ddve_type"></a> [ddve\_type](#input\_ddve\_type) | DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE' | `string` | `"16 TB DDVE"` | no |
| <a name="input_ddve_version"></a> [ddve\_version](#input\_ddve\_version) | DDVE Version, can be: '7.13.0.20','7.10.1.20', '7.7.5.30' | `string` | `"7.13.0.20"` | no |
| <a name="input_default_sg_id"></a> [default\_sg\_id](#input\_default\_sg\_id) | id of default security group when using existing networks | `any` | `null` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | the name ( prefix ) of the eks cluster | `string` | `"tfeks"` | no |
| <a name="input_eks_count"></a> [eks\_count](#input\_eks\_count) | the cout of eks clusters | `number` | `0` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | will be added to many Resource Names / Tags, should be in lower case, abc123 and - | `any` | n/a | yes |
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | Machines to allow ingress, other than default SG ingress | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_nve_count"></a> [nve\_count](#input\_nve\_count) | How many nve(s) you want to create .... | `number` | `0` | no |
| <a name="input_nve_type"></a> [nve\_type](#input\_nve\_type) | nve Type, can be 'small','medium','large' | `string` | `"small"` | no |
| <a name="input_nve_version"></a> [nve\_version](#input\_nve\_version) | nve Version, can be '19.10.0.1', '19.9.0.0' | `string` | `"19.10.0.1"` | no |
| <a name="input_ppdm_count"></a> [ppdm\_count](#input\_ppdm\_count) | Do you want to create an PPDM | `number` | `0` | no |
| <a name="input_ppdm_version"></a> [ppdm\_version](#input\_ppdm\_version) | VERSION Version, can be: '19.14.0', '19.15.0', '19.16.0' | `string` | `"19.16.0"` | no |
| <a name="input_private_route_table"></a> [private\_route\_table](#input\_private\_route\_table) | Private Routing table for S2S VPN | `string` | `""` | no |
| <a name="input_private_subnets_cidr"></a> [private\_subnets\_cidr](#input\_private\_subnets\_cidr) | cidr of the private subnets cidrs when creating the vpc | `list(any)` | n/a | yes |
| <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr) | cidr of the public subnets cidrs when creating the vpc. Public Cidr´(s) are most likely used for Bastion´s | `list(any)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | the region for deployment | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | the subnet to deploy the machines in if vpc is not deployed automatically | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key/value tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_tags_all"></a> [tags\_all](#input\_tags\_all) | Key/value for TopLevel Tagsntags to assign to all resources. | `map(string)` | `{}` | no |
| <a name="input_tunnel1_preshared_key"></a> [tunnel1\_preshared\_key](#input\_tunnel1\_preshared\_key) | the preshared key for teh vpn tunnel when deploying S2S VPN | `string` | `""` | no |
| <a name="input_vault_ingress_cidr_blocks"></a> [vault\_ingress\_cidr\_blocks](#input\_vault\_ingress\_cidr\_blocks) | n/a | `any` | n/a | yes |
| <a name="input_vault_nve_count"></a> [vault\_nve\_count](#input\_vault\_nve\_count) | n/a | `number` | `0` | no |
| <a name="input_vault_ppdm_count"></a> [vault\_ppdm\_count](#input\_vault\_ppdm\_count) | n/a | `number` | `0` | no |
| <a name="input_vault_sg_id"></a> [vault\_sg\_id](#input\_vault\_sg\_id) | id of default security group when using existing networks | `any` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | cidr of the vpc when creating the vpc | `any` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | id of the vpc when using existing networks/vpc | `string` | `""` | no |
| <a name="input_vpn_destination_cidr_blocks"></a> [vpn\_destination\_cidr\_blocks](#input\_vpn\_destination\_cidr\_blocks) | the cidr blocks as string !!! for the destination route in you local network, when s2s\_vpn is deployed | `string` | `"[]"` | no |
| <a name="input_wan_ip"></a> [wan\_ip](#input\_wan\_ip) | The IP of your VPN Device if S2S VPN | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_PPDM_FQDN"></a> [PPDM\_FQDN](#output\_PPDM\_FQDN) | The private ip address for the DDVE Instance |
| <a name="output_VAULT_PPDM_FQDN"></a> [VAULT\_PPDM\_FQDN](#output\_VAULT\_PPDM\_FQDN) | The private ip address for the DDVE Instance |
| <a name="output_atos_bucket"></a> [atos\_bucket](#output\_atos\_bucket) | The S3 Bucket Name created for ATOS configuration |
| <a name="output_ave_instance_id"></a> [ave\_instance\_id](#output\_ave\_instance\_id) | The instance id (initial password) for the DDVE Instance |
| <a name="output_ave_private_ip"></a> [ave\_private\_ip](#output\_ave\_private\_ip) | The sprivate ip address for the AVE Instance |
| <a name="output_ave_ssh_private_key"></a> [ave\_ssh\_private\_key](#output\_ave\_ssh\_private\_key) | The ssh private key for the AVE Instance |
| <a name="output_ave_ssh_public_key"></a> [ave\_ssh\_public\_key](#output\_ave\_ssh\_public\_key) | The ssh public key for the AVE Instance |
| <a name="output_ave_ssh_public_key_name"></a> [ave\_ssh\_public\_key\_name](#output\_ave\_ssh\_public\_key\_name) | The ssh public key Name for the AVE Instance |
| <a name="output_bastion_instance_id"></a> [bastion\_instance\_id](#output\_bastion\_instance\_id) | The instance id (initial password) for the DDVE Instance |
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | The private ip address for the DDVE Instance |
| <a name="output_bastion_ssh_private_key"></a> [bastion\_ssh\_private\_key](#output\_bastion\_ssh\_private\_key) | The ssh private key for the DDVE Instance |
| <a name="output_bastion_ssh_public_key"></a> [bastion\_ssh\_public\_key](#output\_bastion\_ssh\_public\_key) | The ssh public key for the DDVE Instance |
| <a name="output_bastion_ssh_public_key_name"></a> [bastion\_ssh\_public\_key\_name](#output\_bastion\_ssh\_public\_key\_name) | The ssh public key name  for the DDVE Instance |
| <a name="output_crjump_ssh_private_key"></a> [crjump\_ssh\_private\_key](#output\_crjump\_ssh\_private\_key) | The ssh public key name  for the DDVE Instance |
| <a name="output_crs_tunnel1_address"></a> [crs\_tunnel1\_address](#output\_crs\_tunnel1\_address) | The address for the VPN tunnel to configure your local device |
| <a name="output_ddcr_ssh_private_key"></a> [ddcr\_ssh\_private\_key](#output\_ddcr\_ssh\_private\_key) | The ssh private key for the DDVE Instance |
| <a name="output_ddmc_instance_id"></a> [ddmc\_instance\_id](#output\_ddmc\_instance\_id) | The instance id (initial password) for the ddmc Instance |
| <a name="output_ddmc_private_ip"></a> [ddmc\_private\_ip](#output\_ddmc\_private\_ip) | The private ip address for the ddmc Instance |
| <a name="output_ddmc_ssh_private_key"></a> [ddmc\_ssh\_private\_key](#output\_ddmc\_ssh\_private\_key) | The ssh private key for the ddmc Instance |
| <a name="output_ddmc_ssh_public_key"></a> [ddmc\_ssh\_public\_key](#output\_ddmc\_ssh\_public\_key) | The ssh public key for the ddmc Instance |
| <a name="output_ddmc_ssh_public_key_name"></a> [ddmc\_ssh\_public\_key\_name](#output\_ddmc\_ssh\_public\_key\_name) | The ssh public key name  for the ddmc Instance |
| <a name="output_ddve_instance_id"></a> [ddve\_instance\_id](#output\_ddve\_instance\_id) | The instance id (initial password) for the DDVE Instance |
| <a name="output_ddve_private_ip"></a> [ddve\_private\_ip](#output\_ddve\_private\_ip) | The private ip address for the DDVE Instance |
| <a name="output_ddve_ssh_private_key"></a> [ddve\_ssh\_private\_key](#output\_ddve\_ssh\_private\_key) | The ssh private key for the DDVE Instance |
| <a name="output_ddve_ssh_public_key"></a> [ddve\_ssh\_public\_key](#output\_ddve\_ssh\_public\_key) | The ssh public key for the DDVE Instance |
| <a name="output_ddve_ssh_public_key_name"></a> [ddve\_ssh\_public\_key\_name](#output\_ddve\_ssh\_public\_key\_name) | The ssh public key name  for the DDVE Instance |
| <a name="output_kubernetes_cluster_host"></a> [kubernetes\_cluster\_host](#output\_kubernetes\_cluster\_host) | EKS Cluster Host |
| <a name="output_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#output\_kubernetes\_cluster\_name) | EKS Cluster Name |
| <a name="output_nve_instance_id"></a> [nve\_instance\_id](#output\_nve\_instance\_id) | The instance id (initial password) for the DDVE Instance |
| <a name="output_nve_instance_ids"></a> [nve\_instance\_ids](#output\_nve\_instance\_ids) | The instance id (initial password) for the DDVE Instance |
| <a name="output_nve_private_ip"></a> [nve\_private\_ip](#output\_nve\_private\_ip) | The sprivate ip address for the nve Instance |
| <a name="output_nve_private_ips"></a> [nve\_private\_ips](#output\_nve\_private\_ips) | The sprivate ip address for the nve Instance |
| <a name="output_nve_ssh_private_key"></a> [nve\_ssh\_private\_key](#output\_nve\_ssh\_private\_key) | The ssh private key for the nve Instance |
| <a name="output_nve_ssh_private_keys"></a> [nve\_ssh\_private\_keys](#output\_nve\_ssh\_private\_keys) | The ssh private key for the nve Instance |
| <a name="output_nve_ssh_public_key"></a> [nve\_ssh\_public\_key](#output\_nve\_ssh\_public\_key) | The ssh public key for the nve Instance |
| <a name="output_nve_ssh_public_key_name"></a> [nve\_ssh\_public\_key\_name](#output\_nve\_ssh\_public\_key\_name) | The ssh public key Name for the nve Instance |
| <a name="output_ppcr_ssh_private_key"></a> [ppcr\_ssh\_private\_key](#output\_ppcr\_ssh\_private\_key) | The ssh private key for the DDVE Instance |
| <a name="output_ppdm_instance_id"></a> [ppdm\_instance\_id](#output\_ppdm\_instance\_id) | The instance id (initial password) for the DDVE Instance |
| <a name="output_ppdm_ssh_private_key"></a> [ppdm\_ssh\_private\_key](#output\_ppdm\_ssh\_private\_key) | The ssh private key for the DDVE Instance |
| <a name="output_ppdm_ssh_public_key"></a> [ppdm\_ssh\_public\_key](#output\_ppdm\_ssh\_public\_key) | The ssh public key for the DDVE Instance |
| <a name="output_ppdm_ssh_public_key_name"></a> [ppdm\_ssh\_public\_key\_name](#output\_ppdm\_ssh\_public\_key\_name) | The ssh public key name  for the DDVE Instance |
| <a name="output_private_route_table"></a> [private\_route\_table](#output\_private\_route\_table) | The VPC private route table |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The VPC subnet id´s |
| <a name="output_tunnel1_address"></a> [tunnel1\_address](#output\_tunnel1\_address) | The address for the VPN tunnel to configure your local device |
| <a name="output_vault_nve_instance_id"></a> [vault\_nve\_instance\_id](#output\_vault\_nve\_instance\_id) | The instance id (initial password) for the DDVE Instance |
| <a name="output_vault_nve_instance_ids"></a> [vault\_nve\_instance\_ids](#output\_vault\_nve\_instance\_ids) | The instance id (initial password) for the DDVE Instance |
| <a name="output_vault_nve_private_ip"></a> [vault\_nve\_private\_ip](#output\_vault\_nve\_private\_ip) | The sprivate ip address for the nve Instance |
| <a name="output_vault_nve_private_ips"></a> [vault\_nve\_private\_ips](#output\_vault\_nve\_private\_ips) | The sprivate ip address for the nve Instance |
| <a name="output_vault_nve_ssh_private_key"></a> [vault\_nve\_ssh\_private\_key](#output\_vault\_nve\_ssh\_private\_key) | The ssh private key for the nve Instance |
| <a name="output_vault_nve_ssh_private_keys"></a> [vault\_nve\_ssh\_private\_keys](#output\_vault\_nve\_ssh\_private\_keys) | The ssh private key for the vault\_nve Instance |
| <a name="output_vault_nve_ssh_public_key"></a> [vault\_nve\_ssh\_public\_key](#output\_vault\_nve\_ssh\_public\_key) | The ssh public key for the vault\_nve Instance |
| <a name="output_vault_nve_ssh_public_key_name"></a> [vault\_nve\_ssh\_public\_key\_name](#output\_vault\_nve\_ssh\_public\_key\_name) | The ssh public key Name for the vault\_nve Instance |
| <a name="output_vault_ppdm_instance_id"></a> [vault\_ppdm\_instance\_id](#output\_vault\_ppdm\_instance\_id) | The instance id (initial password) for the DDVE Instance |
| <a name="output_vault_ppdm_ssh_private_key"></a> [vault\_ppdm\_ssh\_private\_key](#output\_vault\_ppdm\_ssh\_private\_key) | The ssh private key for the DDVE Instance |
| <a name="output_vault_ppdm_ssh_public_key"></a> [vault\_ppdm\_ssh\_public\_key](#output\_vault\_ppdm\_ssh\_public\_key) | The ssh public key for the DDVE Instance |
| <a name="output_vault_ppdm_ssh_public_key_name"></a> [vault\_ppdm\_ssh\_public\_key\_name](#output\_vault\_ppdm\_ssh\_public\_key\_name) | The ssh public key name  for the DDVE Instance |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC id |


## default Variables
I tried to keep the structure modular, given the many variations vvp´s may be designed.
You can always in or exclude a module by setting it´s count / create  variable to >= 0 / true or false.
Also, when set to false, required ID´s like vpc, default sg´s or subnet, must be provided via variable 

```hcl
AVE_HOSTNAME                    = "ave_terraform"
AVE_HOSTNAME                    = "ave_terraform"
BASTION_HOSTNAME                = "bastion_terraform"
DDMC_HOSTNAME                   = "ddmc_terraform"
DDVE_HOSTNAME                   = "ddve_terraform"
NVE_HOSTNAME                    = "nve_terraform"
PPDM_HOSTNAME                   = "ppdm_terraform"
availability_zone               = "eu-central-1a"
ave_count                       = 0
ave_type                        = "0.5 TB AVE"
aws_profile                     = ""
cr_sg_id                        = ""
create_bastion                  = false
create_client_vpn               = false
create_crs_client_vpn           = false
create_crs_networks             = false
create_crs_s2s_vpn              = false
create_networks                 = false
create_s2s_vpn                  = false
create_vault                    = false
crs_environment                 = "crs"
crs_open_sesame                 = false
crs_private_route_table         = ""
crs_private_subnets_cidr        = ""
crs_public_subnets_cidr         = ""
crs_subnet_id                   = ""
crs_tunnel1_preshared_key       = ""
crs_vault_subnet_id             = ""
crs_vpc_cidr                    = ""
crs_vpc_id                      = ""
crs_vpn_destination_cidr_blocks = "[]"
crs_wan_ip                      = ""
ddmc_count                      = 0
ddmc_type                       = "12.5 Gigabit Ethernet DDMC"
ddmc_version                    = "7.13.0.10"
ddve_count                      = 0
ddve_type                       = "16 TB DDVE"
ddve_version                    = "7.13.0.20"
default_sg_id                   = ""
eks_cluster_name                = "tfeks"
eks_count                       = 0
environment                     = ""
ingress_cidr_blocks = [
  "0.0.0.0/0"
]
nve_count                   = 0
nve_type                    = "small"
nve_version                 = "19.10.0.1"
ppdm_count                  = 0
ppdm_version                = "19.16.0"
private_route_table         = ""
private_subnets_cidr        = ""
public_subnets_cidr         = ""
region                      = ""
subnet_id                   = []
tags                        = {}
tags_all                    = {}
tunnel1_preshared_key       = ""
vault_ingress_cidr_blocks   = ""
vault_nve_count             = 0
vault_ppdm_count            = 0
vault_sg_id                 = ""
vpc_cidr                    = ""
vpc_id                      = ""
vpn_destination_cidr_blocks = "[]"
wan_ip                      = ""
```
## usage

initialize Terraform Providers and Modules
```bash
terraform init
```

do a dry run with 
```bash
terraform plan
```
everything looks good ? run 

```bash
terraform apply --auto-approve
```

## Enabling Internet Access for Networks
Per default, machines do not have internet Access / are deployed into a Private VPC.  
I leave this disabled by default, as i do not want do deploy anything to the default network config automatically

## Configuration ....
this assumes that you use my ansible Playbooks for AVE, [PowerProtect DataManager](https://github.com/dell-examples/ansible_ppdm) and [PowerProtect DataDomain](https://github.com/dell-examples/ansible_ppdm)
Set the Required Variables: (don´t worry about the "Public" notations / names)


## module_ddve
when the deployment is finished, you can connect and configure DDVE in multiple ways.
my preferred way is ansible, but depending on needs one might to get into DDVE with ssh

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
export DDVE_PUBLIC_FQDN=$(terraform output -raw ddve_private_ip)
export DDVE_USERNAME=sysadmin
export DDVE_INITIAL_PASSWORD=$(terraform output -raw ddve_instance_id)
export DDVE_PASSWORD=Change_Me12345_
export PPDD_PASSPHRASE=Change_Me12345_!
export DDVE_PRIVATE_FQDN=$(terraform output -raw ddve_private_ip)
export ATOS_BUCKET=$(terraform output -raw atos_bucket)
export PPDD_LICENSE=$(cat ~/workspace/internal.lic)
export PPDD_TIMEZONE="Europe/Berlin"
```
Configure DataDomain

set the Initial DataDomain Password
```bash
ansible-playbook ~/workspace/ansible_ppdd/1.0-Playbook-configure-initial-password.yml
```

If you have a valid dd license, set the variable PPDD_LICENSE, example:
```bash
ansible-playbook ~/workspace/ansible_ppdd/3.0-Playbook-set-dd-license.yml
```

next, we set the passphrase, as it is required for ATOS
then, we will set the Timezone and the NTP to AWS NTP link local  Server
```bash
ansible-playbook ~/workspace/ansible_ppdd/2.1-Playbook-configure-ddpassphrase.yml
ansible-playbook ~/workspace/ansible_ppdd/2.1.1-Playbook-set-dd-timezone-and-ntp-aws.yml
ansible-playbook ~/workspace/ansible_ppdd/2.2-Playbook-configure-dd-atos-aws.yml
```
this concludes basic DDVE Configuration


### Optional task(s)
Optionally, create a ddboost user for Avamar:
```bash
export AVAMAR_DDBOOST_USER=ddboostave
ansible-playbook ../../ansible_ppdd/3.2-Playbook-set-boost_avamar.yml \
--extra-vars "ppdd_password=${DDVE_PASSWORD}" \
--extra-vars "ava_dd_boost_user=${AVAMAR_DDBOOST_USER}"
```


## module_ddmc

when the deployment is finished, you can connect and configure DDMC in multiple ways.
DDMC shares the same set of API´s that can be used to manage a DataDomain as well.
So we reuse the DDVE Methods to configure DDMC
my preferred way is ansible, but depending on needs one might to get into DDVE with ssh

### Configure using CLI via SSH:
for an ssh connection, use:
```bash
export DDVE_PRIVATE_FQDN=$(terraform output -raw ddmc_private_ip)
terraform output ddmc_ssh_private_key > ~/.ssh/ddmc_key
chmod 0600 ~/.ssh/ddmc_key
ssh -i ~/.ssh/ddmc_key sysadmin@${DDVE_PRIVATE_FQDN}
```
Proceed with CLi configuration

#### configure using ansible
export outputs from terraform into environment variables:
```bash
export DDVE_PUBLIC_FQDN=$(terraform output -raw ddmc_private_ip)
export DDVE_USERNAME=sysadmin
export DDVE_INITIAL_PASSWORD=$(terraform output -raw ddmc_instance_id)
export DDVE_PASSWORD=Change_Me12345_
export PPDD_PASSPHRASE=Change_Me12345_!
export DDVE_PRIVATE_FQDN=$(terraform output -raw ddmc_private_ip)
export PPDD_TIMEZONE="Europe/Berlin"
```
Configure DataDomain

set the Initial DataDomain Management Center Password
```bash
ansible-playbook ~/workspace/ansible_ppdd/1.0-Playbook-configure-initial-password.yml
```

If you have a valid dd license, set the variable PPDD_LICENSE, example:
```bash
ansible-playbook ~/workspace/ansible_ppdd/3.0-Playbook-set-dd-license.yml
```

## module_ave

### Configuring Avamar Virtual Edition Software using AVI API

The initial configuration can be made via the avi installer ui or by using the avi rest api
to configure Avamar using the AVI api, you van use my avi Ansible playbook(s) 

#### Export Mandatory Variables:

```bash
export AVA_COMMON_PASSWORD=Change_Me12345_
export AVE_PUBLIC_IP=$(terraform output -raw ave_private_ip)
export AVE_PRIVATE_IP=$(terraform output -raw ave_private_ip)
export AVE_TIMEZONE="Europe/Berlin" # same as PPDD Timezone
```  

#### Run the AVI Configuration Playbook
```bash
ansible-playbook ~/workspace/ansible_dps/avi/playbook-postdeploy_AVE.yml \
--extra-vars "ave_password=${AVA_COMMON_PASSWORD}"
```




#### Configure DataDomain for avamar using avamar api via ansible
```bash
export AVA_FQDN=$(terraform output -raw ave_private_ip)
export AVA_HFS_ADDR=$(terraform output -raw ave_private_ip)
export AVA_DD_HOST=$(terraform output -raw ddve_private_ip)
ansible-playbook ~/workspace/ansible_dps/ava/playbook_add_datadomain.yml \
--extra-vars "ava_password=${AVA_COMMON_PASSWORD}" \
--extra-vars "ava_username=root" \
--extra-vars "ava_dd_host=${DDVE_PUBLIC_FQDN}" \
--extra-vars "ava_dd_boost_user_pwd=${DDVE_PASSWORD}" \
--extra-vars "ava_dd_boost_user=${AVAMAR_DDBOOST_USER}"
```
### check deployment:
```ansible
ansible-playbook ~/workspace/ansible_dps/ava/playbook_get_datadomain.yml \
--extra-vars "ava_username=root" \
--extra-vars "ava_password=${AVA_COMMON_PASSWORD}"
```

#### connect to AVE using ssh
retrieve the ave ssh key
```bash
terraform output -raw ave_ssh_private_key > ~/.ssh/ave_key_aws
chmod 0600 ~/.ssh/ave_key_aws
ssh -i ~/.ssh/ave_key_aws admin@${AVE_PRIVATE_IP}
```



## module_nve

Configuring Networker Virtual Edition Software using AVI API

### lets export all Upper Case Keys:
```bash
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^[A-Z]+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
export NVE_TIMEZONE="Europe/Berlin"
export NVE_FQDN=$(terraform output -raw nve_private_ip)
export NVE_PRIVATE_IP=$(terraform output -raw nve_private_ip)
export NVE_PASSWORD=Change_Me12345_

```
### Run the AVI Configuration Playbook
```
ansible-playbook ~/workspace/ansible_avi/01-playbook-configure-nve.yml
```

### Configure [n] nve

This example configures the 2nd [1] nve as storage node:
```bash
export NVE_TIMEZONE="Europe/Berlin"
export NVE_FQDN=$(terraform output -json nve_private_ips | jq -r '.[1]')
export NVE_PRIVATE_IP=$(terraform output -json nve_private_ips | jq -r '.[1]')
export NVE_PASSWORD=Change_Me12345_
 ansible-playbook ~/workspace/ansible_avi/01-playbook-configure-nve.yml --extra-vars="nve_as_storage_node=true"
```



### getting ssh keys

This example get SSH Keys of 2nd nve ( [1] )
```bash
terraform output -json nve_ssh_private_keys | jq -r '.[1]' > ~/.ssh/nve1
 chmod 0600  ~/.ssh/nve1
  ssh -i ~/.ssh/nve1 admin@${NVE_PRIVATE_IP}
```


## module_ppdm
## Configure PowerProtect DataManager

Similar to the DDVE Configuration, we will set Environment Variables for Ansible to Automatically Configure PPDM

```bash
# Refresh you Environment Variables if Multi Step !
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^PP+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
export PPDM_INITIAL_PASSWORD=Change_Me12345_
export PPDM_NTP_SERVERS='["169.254.169.123"]'
export PPDM_SETUP_PASSWORD=admin          # default password on the EC2 PPDM
export PPDM_TIMEZONE="Europe/Berlin"
export PPDM_POLICY=PPDM_GOLD
```


Set the initial Configuration:    
```bash
ansible-playbook ~/workspace/ansible_ppdm/1.0-playbook_configure_ppdm.yml
```
![image](https://user-images.githubusercontent.com/8255007/232453993-6e96b0f9-2e0f-45a7-af83-d98466eb2d69.png)
we add the DataDomain:  
![image](https://user-images.githubusercontent.com/8255007/232454316-796b819c-220b-47d5-bdc5-3094e57ef336.png)
```bash
ansible-playbook ~/workspace/ansible_ppdm/2.0-playbook_set_ddve.yml 
```
### we can get the sdr config after Data Domain Boost auto-configuration for primary source  from PPDM
![image](https://user-images.githubusercontent.com/8255007/232453058-617c9553-5a36-4f37-9ffb-cd2b29ad1cb2.png)
```bash
ansible-playbook ~/workspace/ansible_ppdm/3.0-playbook_get_sdr.yml
```
![image](https://user-images.githubusercontent.com/8255007/232453484-623912d2-d6b8-4149-9ea9-459ebd0ac0e7.png)



## module_eks
set eks_count to >= 1
```bash
terraform plan
```

when everything meets your requirements, run the deployment with

```bash
terraform apply --auto-approve
```

### EKS configuration

get the context / login
```bash
aws eks update-kubeconfig --name $(terraform output --raw kubernetes_cluster_name)
```

add the cluster to powerprotect
```bash
ansible-playbook ~/workspace/ansible_ppdm/playbook_set_k8s_root_cert.yml --extra-vars "certificateChain=$(eksctl get cluster tfeks1 -o yaml | awk '/Cert/{getline; print $2}')"
ansible-playbook ~/workspace/ansible_ppdm/playbook_rbac_add_k8s_to_ppdm.yml
```
and we add a PPDM Policy / Rule
```bash
ansible-playbook ~/workspace/ansible_ppdm/playbook_add_k8s_policy_and_rule.yml
```

we need to create snapshot crd´s  and snapshotter
```bash
kubectl apply -k "github.com/kubernetes-csi/external-snapshotter/client/config/crd/?ref=release-6.1"
kubectl apply -k "github.com/kubernetes-csi/external-snapshotter/deploy/kubernetes/snapshot-controller/?ref=release-6.1"
```


and then add the CSI Driver:
```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.18"
```


Let´s create and view the Storageclasses

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/examples/kubernetes/dynamic-provisioning/manifests/storageclass.yaml
kubectl get sc
```

We need to create a new default class

```bash
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass ebs-sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl get sc
```
we need to create a Volumesnapshotclass:
```
kubectl apply -f - <<EOF
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: ebs-snapclass
driver: ebs.csi.aws.com
deletionPolicy: Delete
EOF
```

## run ppdm demo

[PPDM_K8S_Demo](../documentation/kubernetes_demo_workload.md)


## getting started with EKS

Note: EKS Changed to version >= 1.24, thus changed the api version for client authentication to 
client.authentication.k8s.io/v1beta1

this requires aws cli >= 2.10, otherwise you might see a failure:

>kubectl cluster-info 
>To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
>error: exec plugin: invalid apiVersion "client.authentication.k8s.io/v1alpha1"




