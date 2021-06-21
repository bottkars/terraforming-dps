# Terraforming GCP: deploy PPDM, DDVE and more from GCP Marketplace

## getting started
this deployment is used and tested with terraform v0.13,v0.14,v0.15 and 1.0
simply clone the repo and create a *tfvars* file or use *TF_VAR_* environment variables from below examples
the repo is split ito modules
the variable create_ddve and create_ppdm can be set to true or false to indicate which components to deploy

### create an iam serviceaccount for terraform
follow the Hashi Documentation to create a TF Serviceaccount for GCP
[service_account_for_terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials)  

the CONTENT of downloaded json file can be directly inserted as the variable value of "gcp_credentials"

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

when finished, you can connect to the DDVE in multiple ways:
```bash
terraform output ddve_ssh_private_key > ~/.ssh/ddve_key
ssh -i ~/.ssh/ddve_key sysadmin@$(terraform output -raw  ddve_private_ip)
```






### add a site2site vpn configuration to the system (ubiquiti)
on bash you can get you external ip with 
```bash
wget -O - v4.ident.me 2>/dev/null && echo
```
and this should be the value for you S2S connection
also, you need to export you target route subnet´s (s2s_vpn_route_dest) 
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

## Enabling Internet Access for Networks
Per default, machines do not have internet Access unless you enable Cloud Nat.  
I leave this disabled by default, as i do not want do deploy anything to the default network config automatically

You can enable Cloud Nat for the network by 

```bash
export TF_VAR_create_cloud_nat=true
terraform apply --auto-approve
```



## Enabling GKE
gke can be enabled using 
```bash
export TF_VAR_create_gke=true
```

apply will create a 2-node cluster in the default zone.
as this is a private cluster, 3 ip ranges need to be defined in you network config (unless using infra module)
you can fetch the auth data by running 

```bash
gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw location)
```



### PPDM-k8s

Create a serviceaccount 
```bash
kubectl apply -f https://raw.githubusercontent.com/bottkars/dps-modules/main/ci/templates/ppdm/ppdm-admin.yml
kubectl apply -f https://raw.githubusercontent.com/bottkars/dps-modules/main/ci/templates/ppdm/ppdm-rbac.yml
export PPDM_K8S_TOKEN=$(kubectl get secret "$(kubectl -n kube-system get secret | grep ppdm-admin | awk '{print $1}')" \
-n kube-system --template={{.data.token}} | base64 -d)
```

enable latest CSI 

```bash
gcloud container clusters update $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region) \
   --update-addons=GcePersistentDiskCsiDriver=ENABLED
```

enable snapshot class
```
kubectl apply -f templates/snapshot-class.yml
```

wordpress deployment
```bash
kubectl create namespace wordpress
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install wp bitnami/wordpress \
--set mariadb.volumePermissions.enabled=true \
--set global.storageClass=standard-rwo --set volumePermissions.enabled=true \
--namespace wordpress

```

## Example Custom 




[terraform.tfvars.json](./terraform.tfvars.json.example)
## Parameter Validation
Most of the Parameters have defaults.
For SOme ( like  DDVE_SIZE ) Parameters will be Validated where applicable

![image](https://user-images.githubusercontent.com/8255007/122246622-fe495f80-cec6-11eb-9e3a-8cf696c7e7c2.png)
