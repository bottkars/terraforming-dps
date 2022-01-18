# Terraforming AWS: deploy AVE, DDVE and more from GCP Marketplace

## getting started
this deployment is used and tested with terraform v0.15 and 1.1.3
simply clone the repo and create a *tfvars* file or use *TF_VAR_* environment variables from below examples
the repo is split ito modules
the variable create_ddve and create_ppdm can be set to true or false to indicate which components to deploy

### fprerequisites for AWS f
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
initialize Terraform Providers and Modules
```bash
terraform init
```

## edit Deployment Variables 

```

do a dry run with 
```bash
terraform plan
```
everything looks good ? run 

```bash
terraform apply --auto-approve
```

when finished, you can connect to the DDVE in multiple ways:
```bash
terraform output ddve_ssh_private_key > ~/.ssh/ddve_key
ssh -i ~/.ssh/ddve_key sysadmin@$(terraform output -raw  ddve_private_ip)
```






### add a site2site vpn configuration to the system ( a default coniguartion that matches ubiquiti UDM-Pro)
on bash you can get you external ip with 
```bash
wget -O - v4.ident.me 2>/dev/null && echo
```
and this should be the value for you S2S connection
also, you need to export you target route subnet´s (s2s_vpn_route_dest) 
```bash
export TF_VAR_create_s2s_vpn=true
export TF_VAR_vpn_wan_ip=$(wget -O - v4.ident.me 2>/dev/null && echo)
export TF_VAR_vpn_destination_cidr_blockst=["192.168.1.0/24","100.250.1.0/24"]
export tunnel1_preshared_key=<yourverysecretthing>
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




## Tweak into Ansible ....
this assumes that you use my ansible Playbooks for AVE, PPDM and DDVE from [ansible-dps]()
Set the Required Variables: (don´t worry about the "Public" notations / names)


### Configuring DDVE

```bash
export DDVE_PUBLIC_FQDN=$(terraform output -raw ddve_private_ip)
export DDVE_USERNAME=sysadmin
export DDVE_INITIAL_PASSWORD=$(terraform output -raw ddve_instance_id)
export DDVE_PASSWORD=Change_Me12345_
export PPDD_PASSPHRASE=Change_Me12345_!
export DDVE_PRIVATE_FQDN=$(terraform output -raw ddve_private_ip)
export AWS_ATOS_BUCKET=$(terraform output -raw atos_bucket)
export PPDD_LICENSE=$(cat ~/workspace/ansible_dps/ppdd/internal.lic)
```
Configure Datadomain

set the Initial Datadomain Password
```bash
ansible-playbook ../../ansible_dps/ppdd/1.0-Playbook-configure-initial-password.yml
```

If you have a valid dd license, set the variable PPDD_LICENSE, example:
```bash
export PPDD_LICENSE=$(cat ~/workspace/ansible_dps/ppdd/internal.lic)
ansible-playbook ../../ansible_dps/ppdd/3.0-Playbook-set-dd-license.yml
```
```bash
ansible-playbook ../../ansible_dps/ppdd/2.1-Playbook-configure-ddpassphrase.yml
ansible-playbook ../../ansible_dps/ppdd/2.2-Playbook-configure-dd-atos-aws.yml
```



### Configuring AVE from ansible



```bash
export AVE_PUBLIC_IP=$(terraform output -raw ave_private_ip)
export AVE_PRIVATE_IP=$(terraform output -raw ave_private_ip)

```


aquiring ave ssh key
```bash
terraform output -raw ave_ssh_private_key > ~/.ssh/ave_key_aws
chmod 0600 ~/.ssh/ave_key_aws
ssh -i ~/.ssh/ave_key_aws admin@${AVE_PRIVATE_IP}
```


Configure AVE
```bash

```





