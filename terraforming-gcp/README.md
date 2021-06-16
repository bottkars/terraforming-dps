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


### minimum deployment variables example from shell vars

minimum deployment variables will use the defaul net and default subnet in the region
```bash
TF_VAR_gcp_project=xxx-project
TF_VAR_gcp_credentials={"type":"service_account","project_id":"xxx-project","private_key_id":"13fc765f0d0a2fb459eef6eb25fabdd397462a5f","private_key":"-----BEGIN PRIVATE KEY-----\nMIIE\n-----END PRIVATE KEY-----\n","client_email":"tfaccount@xxx-project.iam.gserviceaccount.com","client_id":"xxx","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_x509_cert_url":"https://www.googleapis.com/robot/v1/metadata/x509/tfaccount%40xxx-project.iam.gserviceaccount.com"}
```
or use 

[terraform.tfvars.json](./terraform.tfvars.json.example)
## Validation
Parameters will be Validated where applicable

![image](https://user-images.githubusercontent.com/8255007/122246622-fe495f80-cec6-11eb-9e3a-8cf696c7e7c2.png)
