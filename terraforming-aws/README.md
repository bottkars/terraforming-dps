# Terraforming AWS: deploy AVE, DDVE and more from GCP Marketplace

## getting started
this deployment is used and tested with terraform v0.15 and 1.1.3
simply clone the repo and create a *tfvars* file or use *TF_VAR_* environment variables from below examples
the repo is split ito modules
the variable create_ddve and create_ppdm can be set to true or false to indicate which components to deploy

### prerequisites for AWS
following the Hashi Documentation to create 
 - [The Terrafrom CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
 - [The AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
 - [An AWS account](https://aws.amazon.com/free/)
 - [access_keys_for_terraform](https://console.aws.amazon.com/iam/home?#/security_credentials)  


### prepare tf environment

after cloning the Repo to you local Machine, cd to terraforming-gcp
```bash
cd terraforming-dps/terraforming-gcp
```


## edit Deployment Variables
i tried to keep the structure modular, given the many variations vvp´s may be designed.
You can always in or exclude a module by setting it´s use_xxx variable to true or false.
Also, when set to fale, required ID´s like vpc, default sg´s or subnet, must be provided via variable 

```hcl
AVE_HOSTNAME      = "ave_terraform"
DDVE_HOSTNAME     = "ddve_terraform"
availability_zone = "eu-central-1a"
create_ave        = false
create_ddve       = false
create_networks   = false
create_s2s_vpn    = false
default_sg_id     = ""
environment       = ""
ingress_cidr_blocks = [
  "0.0.0.0/0"
]
private_route_table         = ""
private_subnets_cidr        = ""
public_subnets_cidr         = ""
region                      = ""
subnet_id                   = ""
tunnel1_preshared_key       = ""
vpc_cidr                    = ""
vpc_id                      = ""
vpn_destination_cidr_blocks = "[]"
wan_ip                      = ""
```

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
this assumes that you use my ansible Playbooks for AVE, PPDM and DDVE from [ansible-dps]()
Set the Required Variables: (don´t worry about the "Public" notations / names)


### Configuring DDVE
when the deployment is finished, you can connect and configure DDVE in multiple ways.
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
export AWS_ATOS_BUCKET=$(terraform output -raw atos_bucket)
export PPDD_LICENSE=$(cat ~/workspace/ansible_dps/ppdd/internal.lic)
export PPDD_TIMEZONE="Europe/Berlin"
```
Configure DataDomain

set the Initial DataDomain Password
```bash
ansible-playbook ~/workspace/ansible_dps/ppdd/1.0-Playbook-configure-initial-password.yml
```

If you have a valid dd license, set the variable PPDD_LICENSE, example:
```bash
export PPDD_LICENSE=$(cat ~/workspace/ansible_dps/ppdd/internal.lic)
ansible-playbook ~/workspace/ansible_dps/ppdd/3.0-Playbook-set-dd-license.yml
```

next, we set the passphrase, as it is required for ATOS
then, we will set the Timezone and the NTP to AWS NTP link local  Server
```bash
ansible-playbook ~/workspace/ansible_dps/ppdd/2.1-Playbook-configure-ddpassphrase.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/2.1.1-Playbook-set-dd-timezone-and-ntp-aws.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/2.2-Playbook-configure-dd-atos-aws.yml
```

Optionally, create a ddboost user for Avamar:
```bash
export AVAMAR_DDBOOST_USER=ddboostave
ansible-playbook ../../ansible_dps/ppdd/3.2-Playbook-set-boost_avamar.yml \
--extra-vars "ppdd_password=${DDVE_PASSWORD}" \
--extra-vars "ava_dd_boost_user=${AVAMAR_DDBOOST_USER}"
```

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
--extra-vars "ava_dd_boost_user_pwd=${DDVE_PASSWORD}"
--extra-vars "ava_dd_boost_user=${AVAMAR_DDBOOST_USER}"

### check deployment:
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



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.27 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ave"></a> [ave](#module\_ave) | ./modules/ave | n/a |
| <a name="module_ddve"></a> [ddve](#module\_ddve) | ./modules/ddve | n/a |
| <a name="module_networks"></a> [networks](#module\_networks) | ./modules/networks | n/a |
| <a name="module_s2s_vpn"></a> [s2s\_vpn](#module\_s2s\_vpn) | ./modules/s2s_vpn | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AVE_HOSTNAME"></a> [AVE\_HOSTNAME](#input\_AVE\_HOSTNAME) | n/a | `string` | `"ave_terraform"` | no |
| <a name="input_DDVE_HOSTNAME"></a> [DDVE\_HOSTNAME](#input\_DDVE\_HOSTNAME) | n/a | `string` | `"ddve_terraform"` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | availability\_zone to use | `string` | `"eu-central-1a"` | no |
| <a name="input_create_ave"></a> [create\_ave](#input\_create\_ave) | n/a | `bool` | `false` | no |
| <a name="input_create_ddve"></a> [create\_ddve](#input\_create\_ddve) | n/a | `bool` | `false` | no |
| <a name="input_create_networks"></a> [create\_networks](#input\_create\_networks) | n/a | `bool` | `false` | no |
| <a name="input_create_s2s_vpn"></a> [create\_s2s\_vpn](#input\_create\_s2s\_vpn) | n/a | `bool` | `false` | no |
| <a name="input_default_sg_id"></a> [default\_sg\_id](#input\_default\_sg\_id) | n/a | `any` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | will be added to many Resource Names / Tags, should be in lower case, abc123 and - | `any` | n/a | yes |
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | n/a | `list(any)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_private_route_table"></a> [private\_route\_table](#input\_private\_route\_table) | n/a | `string` | `""` | no |
| <a name="input_private_subnets_cidr"></a> [private\_subnets\_cidr](#input\_private\_subnets\_cidr) | cidr of the private subnets cidrs when creating the vpc | `list(string)` | n/a | yes |
| <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr) | cidr of the public subnets cidrs when creating the vpc | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | the region for deployment | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | the subnet to deploy the machines in if vpc is not deployed automatically | `string` | `""` | no |
| <a name="input_tunnel1_preshared_key"></a> [tunnel1\_preshared\_key](#input\_tunnel1\_preshared\_key) | n/a | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | cidr of the vpc when creating the vpc | `any` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `""` | no |
| <a name="input_vpn_destination_cidr_blocks"></a> [vpn\_destination\_cidr\_blocks](#input\_vpn\_destination\_cidr\_blocks) | the cidr blocks as string !!! for the destination route in you local network, when s2s\_vpn is deployed | `string` | `"[]"` | no |
| <a name="input_wan_ip"></a> [wan\_ip](#input\_wan\_ip) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_atos_bucket"></a> [atos\_bucket](#output\_atos\_bucket) | The S3 Bucket Name created for ATOS configuration |
| <a name="output_ave_private_ip"></a> [ave\_private\_ip](#output\_ave\_private\_ip) | The sprivate ip address for the AVE Instance |
| <a name="output_ave_ssh_private_key"></a> [ave\_ssh\_private\_key](#output\_ave\_ssh\_private\_key) | The ssh private key for the AVE Instance |
| <a name="output_ave_ssh_public_key"></a> [ave\_ssh\_public\_key](#output\_ave\_ssh\_public\_key) | The ssh public key for the AVE Instance |
| <a name="output_ave_ssh_public_key_name"></a> [ave\_ssh\_public\_key\_name](#output\_ave\_ssh\_public\_key\_name) | The ssh public key Name for the AVE Instance |
| <a name="output_ddve_instance_id"></a> [ddve\_instance\_id](#output\_ddve\_instance\_id) | The instance id (initial password) for the DDVE Instance |
| <a name="output_ddve_private_ip"></a> [ddve\_private\_ip](#output\_ddve\_private\_ip) | The private ip address for the DDVE Instance |
| <a name="output_ddve_ssh_private_key"></a> [ddve\_ssh\_private\_key](#output\_ddve\_ssh\_private\_key) | The ssh private key for the DDVE Instance |
| <a name="output_ddve_ssh_public_key"></a> [ddve\_ssh\_public\_key](#output\_ddve\_ssh\_public\_key) | The ssh public key for the DDVE Instance |
| <a name="output_ddve_ssh_public_key_name"></a> [ddve\_ssh\_public\_key\_name](#output\_ddve\_ssh\_public\_key\_name) | The ssh public key name  for the DDVE Instance |
| <a name="output_private_route_table"></a> [private\_route\_table](#output\_private\_route\_table) | The VPC private route table |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The VPC subnet id´s |
| <a name="output_tunnel1_address"></a> [tunnel1\_address](#output\_tunnel1\_address) | The address for the VPN tunnel to configure your local device |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC id |
