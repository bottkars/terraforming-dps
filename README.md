# Deploying DellEMC DPS Appliances in Azure using Terraform
- requirements
- create a service principal for terraform
- login with sp
- create a terraform.tfvars

---
# requirements
- terraform 0.12
- bash ( preferred )
- az cli
# create a service principal

Example Bash

```bash
SERVICE_PRINCIPAL=$(az ad sp create-for-rbac --name ServicePrincipalforTerraform --output json)
## SET the Following Secrets from the temporary Variables
export ARM_CLIENT_ID=$(echo $SERVICE_PRINCIPAL | jq -r .appId)
export ARM_TENANT_ID=$(echo $SERVICE_PRINCIPAL | jq -r .tenant)
export ARM_CLIENT_SECRET=$(echo $SERVICE_PRINCIPAL | jq -r .password)
export ARM_SUBSCRIPTION_ID=<your subscription id>
unset SERVICE_PRINCIPAL
```
Make the SP at least contributor to the subscription

```bash
az role assignment create --role Contributor --assignee-object-id ${ARM_CLIENT_ID} --assignee-principal-type ServicePrincipal --scope /subscriptions/${ARM_SUBSCRIPTION_ID}
```

If a SP and Assignmnet already exists:
Export the Env for Terraform:
```bash
export ARM_CLIENT_SECRET=yoursecret
export ARM_TENANT_ID=your tenantid
export ARM_CLIENT_ID=you clientid
export ARM_SUBSCRIPTION_ID=your sub
```


--> when using vars for provider:

```bash
export TF_VAR_client_secret=yoursecret
export TF_VAR_tenant_id=your tenantid
export TF_VAR_client_id=you clientid
export TF_VAR_subscription_id=your sub
``` 
# preparing terraform deployment

clone the repository
```bash
git clone git@github.com:bottkars/terraforming-dps.git
```



```bash
cd terraforming-dps/
```
create a [terraform.tfvars](./terraforming_ddve/terraform.tfvars.example) file 
or [terraform.tfvars.json](./terraform.tfvars.json.example) file 
with the minimum content:
```bash
cat << EOF > terraform.tfvars
ENV_NAME            = "dpsdemo"
location            = "West Europe"
dns_suffix          = "dpslab.labbuildr.com"
DDVE_HOSTNAME       = "ddve1"
DDVE_META_DISKS =  ["250","250"]
DDVE_VM_SIZE = "Standard_F4"
DDVE_INITIAL_PASSWORD = "Change_Me12345_"
EOF
```

edit [main.tf](./main.tf) to enable only your desired Modules ( will enable programmatic module selection once i can fully run on terraform 0.13)
Optionally, create a [backend.tf](./backend.tf.example) file to meet your needs
# Run Terraform Init

```bash
terraform init
```
if all looks good:

# Run Terraform deployment
run terraform apply to view and execute the deployment
```bash
terraform apply # -target=module.ddve when AVE is already deployed
```



alternatively, you may use terraform plan -out=.tfplan and terraform apply .tfplan

# DeleteTerraform deployment
run terraform destroy to delete the deployment
```bash
terraform destroy
```


## Marketplace Item
Befor applying for the first time:

Marketplace SKU´s T&C´s are applied using
module.ddve.azurerm_marketplace_agreement.ddve if you have already applied the terms and conditions, you can import the resource with
if you previously Accepted T&C´s
```bash
terraform import module.ddve.azurerm_marketplace_agreement.ddve /subscriptions/${ARM_SUBSCRIPTION_ID}/providers/Microsoft.MarketplaceOrdering/agreements/dellemc/offers/dell-emc-datadomain-virtual-edition-v4/plans/ddve-60-ver-7305
```

```bash
terraform import module.ddve.azurerm_marketplace_agreement.ddve /subscriptions/${ARM_SUBSCRIPTION_ID}/providers/Microsoft.MarketplaceOrdering/agreements/dellemc/offers/ppdm_0_0_1/plans/powerprotect-data-manager-19-6-0
```
the resource / agreement will be deleted for that instance after terraform destroy

If you want to manually work with the SKU´s here are some hints :-)
Manually Accepting Plan SKU´s T&C´s (should be done automatically from template)

```bash
az vm image list --all --publisher dellemc --query '[].urn'
az vm image accept-terms --urn {one urn from above}
```
accept all
```bash
az vm image list --all --publisher dellemc --query '[].urn'  --output tsv | xargs -L1 az vm image terms accept --urn
```
cancel all

accept all
```bash
az vm image list --all --publisher dellemc --query '[].urn'  --output tsv | xargs -L1 az vm image terms cancel --urn
```
show all
```bash
az vm image list --all --publisher dellemc --query '[].urn'  --output tsv | xargs -L1 az vm image terms show --urn
```
---



# Delete Single Terraform deployment module (AVE/DDVE)
run terraform destroy to delete the deployment
```bash
terraform destroy -target=module.ddve
```



# After Deployment

Connect to the DDVE using the Bastion Host:
getting output for ssh_private_key into a file
```bash
terraform output ddve_ssh_private_key >> bastion.key
```

you can now use the key upload method on azure bastion to access the ddve

---
Configuration:

Follow the [DDVE on Azure Installation and Administration_Guide](https://dl.dell.com/content/docu98496_DD_Virtual_Edition_5.0_with_DD_OS_7.2.0.5_in_Azure_Installation_and_Administration_Guide.pdf?language=en_US&source=Coveo) to configure your newly created DDVE


---


## TBD
 - Hot Blob vs. Disks
 - evaluation of machine types


# CI Pipelines

there are Concourse Pipelines for automated builsd leveraging snapkittches concourse terraform resource

the Pipelines are examples, and leverage S3 for Backend Config an Gitub for my Concourse Modules


### example

an auto.tfvars file will be fetched with a semver resource,
eg terraform_2020.10.03-1.auto.tfvars
```tfvars
ENV_NAME            = "tfdemmo"
location            = "West Europe"
dns_suffix          = "dpslab.labbuildr.com"
DDVE_HOSTNAME       = "ddve1"
DDVE_META_DISKS =  ["256","256"]
DDVE_INITIAL_PASSWORD = "Change_Me12345_"
DDVE_VM_SIZE = "Standard_F4"
```

```bash
fly -t asdk set-pipeline -c terraforming_ddve/ci/pipeline-ddve.yml -l ../dpslab_labbuildr_local/vars_powerprotect.yml -p ddve-from-terraform
```


post configs 

mtree create /data/col1/powerprotect
nfs export create path /data/col1/powerprotect clients ppdm11.tfdemo.dpslab.labbuildr.com  options sec=sys,rw,no_root_squash,no_all_squash,secure,version=3

## Evaluating tfvars.json as VARS from lpass 
```bash
eval $(lpass show dps\\azure_dell_msdn/tf_vars_json --notes | jq -r 'keys[] as $key | "export TF_VAR_\($key)='\''\(.[$key])'\''"')
lpass show dps\\azure_dell_msdn/tf_vars_json --notes | jq -r 'keys[] as $key | "export TF_VAR_\($key)='\''\(.[$key])'\''"'
```



## avamar exports for ANSIBLE
```
export AVE_PRIVATE_IP=$(terraform output AVE_PRIVATE_IP)
export AVE_PUBLIC_IP=$(terraform output AVE_PUBLIC_IP)
```