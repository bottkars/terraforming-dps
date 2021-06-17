# Terraforming GCP deploy PPDM, DDVE from GCP Marketplace

## getting started
this deployment is used and tested with terraform v0.13,v0.14,v0.15 and 1.0
simly clone the repo and create a tfvars file from below examples
the repo is devided ito modules
the variable deploy_ddve and deploy_ppdm can be set to true or false to indicate wich components to deploy

## create an iam serviceaccount for terraform
follow the Hashi Documentation to create a TF Serviceaccount for GCP
[service_account_for_terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials)  

the CONTENT of downloaded json file can be directly inserted as the variable value of "gcp_credentials"

## deploy

after cloning the Repo to you local Machine, cd to terraforming-gcp
```bash
cd terraforming-dps/terraforming-gcp
```
initialize Terraform Providers and Modules
```bash
terraform init
```

## Edit Deployment Variables 
to start with a default deployment, just  create the below variables
the default deployment will create a DDVE and PPDM in europe-west3 in the default network/subnet in the region  
the TF_VAR_gcp_credentials essentially is the content of the service account in json format.
```bash
export TF_VAR_gcp_project=xxx-project
export TF_VAR_gcp_credentials="$(cat ~/<path_to_account_json>.json)"
```

do a dry run with 
```bash
terraform plan
```
everything looks good ? run 

```bash
terraform apply --auto-approve
```

### add a site2site vpn configuration to the system (ubiquiti)
on bash you can get you external ip with 
```bash
wget -O - v4.ident.me 2>/dev/null && echo
```
and this should be the value for you S2S connection
```bash
export TF_VAR_create_s2svpn=true
export TF_VAR_vpn_wan_ip=$(wget -O - v4.ident.me 2>/dev/null && echo)
export TF_VAR_s2s_vpn_route_dest=["192.168.1.0/24","100.250.1.0/24"]
export TF_VAR_vpn_shared_secret=<yourverysecretthing>
```

do a dry run with 
```bash
terraform plan
```
everything looks good ? run 

```bash
terraform apply --auto-approve
```


## Example Custom deployment

[terraform.tfvars.json](./terraform.tfvars.json.example)
## Parameter Validation
Most of the Parameters have defaults.
For SOme ( like  DDVE_SIZE ) Parameters will be Validated where applicable

![image](https://user-images.githubusercontent.com/8255007/122246622-fe495f80-cec6-11eb-9e3a-8cf696c7e7c2.png)
