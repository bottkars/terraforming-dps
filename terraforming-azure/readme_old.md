
# Deploying DellEMC DPS Appliances in Azure using Terraform
- requirements
- create a service principal for terraform
- login with sp
- create a terraform.tfvars

---
## requirements
- terraform 0.12
- bash ( preferred )
- jq
- az cli
- azure service principal
### create a service principal

in order to use the modules, we require an Azure Service Pricipal

You can either create a new SP:
```bash
SERVICE_PRINCIPAL=$(az ad sp create-for-rbac --name ServicePrincipalforTerraform --output json)
## SET the Following Secrets from the temporary Variables
export ARM_CLIENT_ID=$(echo $SERVICE_PRINCIPAL | jq -r .appId)
export ARM_TENANT_ID=$(echo $SERVICE_PRINCIPAL | jq -r .tenant)
export ARM_CLIENT_SECRET=$(echo $SERVICE_PRINCIPAL | jq -r .password)
export ARM_SUBSCRIPTION_ID=<your subscription id>
unset SERVICE_PRINCIPAL
```

and Make the SP at least contributor to the subscription

```bash
az role assignment create --role Contributor --assignee-object-id ${ARM_CLIENT_ID} --assignee-principal-type ServicePrincipal --scope /subscriptions/${ARM_SUBSCRIPTION_ID}
```

Or use an existing one,if a SP and Assignmnet already exists:
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
## preparing terraform deployment 

clone the repository
```bash
git clone git@github.com:bottkars/terraforming-dps.git
```




edit [main.tf](./main.tf) and edit [outputs.tf](./outputs.tf)  to enable only your desired Modules ( will enable programmatic module selection once i can fully run on terraform >=0.12)
current supported deployments are
- Datadomain DDVE
- Avamar AVE
- Networker NVE
- Bastion Host
- Linux Client Host

Optionally, create a [backend.tf](./backend.tf.example) file to meet your needs
# Run Terraform Init

```bash
terraform init
```
if all looks good:

# Run Terraform deployment
run terraform apply to view and execute the deployment
```bash
terraform apply 
```



alternatively, you may use terraform plan -out=.tfplan and terraform apply .tfplan

# DeleteTerraform deployment
run terraform destroy to delete the deployment
```bash
terraform destroy
```


# Note on Marketplace Item
The terrafrom Deployments are based on the DellEMC Marketplace item

Before applying for the first time, you might have to check if Marketplace Terms are already Confirmed

Marketplace SKU´s T&C´s are confirmed using
*module.ddve[0].azurerm_marketplace_agreement.ddve* 
if you have already applied the terms and conditions, you can import the resource with
if you previously Accepted T&C´s
```bash
terraform import module.ddve[0].azurerm_marketplace_agreement.ddve /subscriptions/${ARM_SUBSCRIPTION_ID}/providers/Microsoft.MarketplaceOrdering/agreements/dellemc/offers/dell-emc-datadomain-virtual-edition-v4/plans/ddve-60-ver-7305
```
```bash
terraform import module.ddve[0].azurerm_marketplace_agreement.ddve /subscriptions/${ARM_SUBSCRIPTION_ID}/providers/Microsoft.MarketplaceOrdering/agreements/dellemc/offers/ppdm_0_0_1/plans/powerprotect-data-manager-19-6-0
```
the resource / agreement will be deleted for that instance after terraform destroy

If you want to manually work with the SKU´s here are some hints :-)
Manually Accepting Plan SKU´s T&C´s (should be done automatically from template:

```bash
az vm image list --all --publisher dellemc --query '[].urn'
az vm image accept-terms --urn {one urn from above}
```
accept all
```bash
az vm image list --all --publisher dellemc --query '[].urn'  --output tsv | xargs -L1 az vm image terms accept --urn
```
cancel all

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
terraform output ddve_ssh_private_key > ~/.ssh/bastion.key
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

there are Concourse Pipelines for automated builds leveraging snapkittchens concourse terraform resource (reason for the modules bound to 0.12 )

the Pipelines are examples, and leverage S3 for Backend Config an Gitub for my Concourse Modules


### example

an auto.tfvars file will be fetched with a semver resource,
eg terraform_2020.10.03-1.auto.tfvars
```tfvars
environment            = "tfdemmo"
location            = "West Europe"
dns_suffix          = "dpslab.labbuildr.com"
ddve_hostname       = "ddve1"
ddve_meta_disks =  ["256","256"]
ddve_password = "Change_Me12345_"
DDVE_VM_SIZE = "Standard_F4"
```

```bash
fly -t asdk set-pipeline -c terraforming_azure/ci/pipeline.yml -l ../dpslab_labbuildr_local/vars_powerprotect.yml -p dps-terraform-ci
```


# Tipps and Tricks

## Evaluating tfvars.json as VARS from lpass 
```bash
eval "$(lpass show dps\\azure_dell_msdn/tf_vars_json --notes | jq -r 'keys[] as $key | "export TF_VAR_\($key)='\''\(.[$key])'\''"')"
lpass show dps\\azure_dell_msdn/tf_vars_json --notes | jq -r 'keys[] as $key | "export TF_VAR_\($key)='\''\(.[$key])'\''"'
```

## evaluating Terrafrom outputs

I use several outputs to control following ansible runbooks.

to evaluate the terraform output, you can use jq:

terraform output -json ddve_private_ip | jq  '.[0]' -r

```bash
terraform output --json | jq -r 'keys[] as $key | "export \($key)=\"\(.[$key].value)\""' 
```
to eval it directly to environment variables:

```bash
eval "$(terraform output --json | jq -r 'keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
```


## Using in combination with my Ansible Roles

eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^[A-Z]+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
First, export vars from terraform:
```bash
eval "$(terraform output --json | jq -r 'keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
```



