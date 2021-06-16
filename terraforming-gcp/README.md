# Terraforming GCP deploy PPDM, DDVE from GCP Marketplace

## getting started
this deployment is used and tested with terraform v0.13,v0.14,v0.15 and 1.0
simly clone the repo and create a tfvars file from below examples
the repo is devided ito modules
the variable deploy_ddve and deploy_ppdm can be set to true or false to indicate wich components to deploy

## create an iam serviceaccount for tf
[service_account_for_terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials)

the CONTENT of downloaded json file can be directly inserted as the variable value of "gcp_credentials"

## deploy




## deployment variables


deployment variables example from shell vars
```bash
TF_VAR_create_ppdm=true
TF_VAR_ENV_NAME=tfdemo
TF_VAR_DDVE_HOSTNAME=ddve1
TF_VAR_DDVE_META_DISKS=[500,500]
TF_VAR_subnetwork_name_1=xxx-subnet-172
TF_VAR_gcp_project=xxx-project
TF_VAR_DDVE_VM_SIZE=custom-8-32768
TF_VAR_gcp_credentials={"type":"service_account","project_id":"xxx-project","private_key_id":"13fc765f0d0a2fb459eef6eb25fabdd397462a5f","private_key":"-----BEGIN PRIVATE KEY-----\nMIIE\n-----END PRIVATE KEY-----\n","client_email":"tfaccount@xxx-project.iam.gserviceaccount.com","client_id":"xxx","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_x509_cert_url":"https://www.googleapis.com/robot/v1/metadata/x509/tfaccount%40xxx-project.iam.gserviceaccount.com"}
TF_VAR_DDVE_PPDM_HOSTNAME=ppdm1
TF_VAR_subnet_cidr_block_1=172.19.0.0/24
TF_VAR_gcp_zone=europe-west3-c
TF_VAR_PPDM_IMAGE={"publisher":"dellemc-ddve-public","offer":"ppdm_0_0_1","sku":"powerprotect","version":"19-8-0-5"}
TF_VAR_PPDM_HOSTNAME=ppdm1
TF_VAR_vpn_wan_ip=your_external_ip_for_vpn
TF_VAR_gcp_network=xxxvpcwest3
TF_VAR_DDVE_IMAGE={"publisher":"dellemc-ddve-public","offer":"ppdm_0_0_1","sku":"ddve-gcp","version":"7-6-0-5-685135"}
TF_VAR_vpn_shared_secret=a_shared_secret_for_vpn_tunnel
TF_VAR_create_ddve=true 
TF_VAR_gcp_region=europe-west3
```
or use 

[terraform.tfvars.json](./terraform.tfvars.json.example)
## Validation
Parameters will be Validated where applicable

![image](https://user-images.githubusercontent.com/8255007/122246622-fe495f80-cec6-11eb-9e3a-8cf696c7e7c2.png)
