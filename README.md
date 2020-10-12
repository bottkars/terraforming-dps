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

Change Directory to "terraforming-dps/terraforming_ddve"


```bash
cd terraforming-dps/terraforming_ddve
```
create a [terraform.tfvars](./terraforming_ddve/terraform.tfvars.example) file 
with the minimum content:
```bash
cat << EOF > terraform.tfvars
env_name            = "dpsdemo"
location            = "West Europe"
dns_suffix          = "dpslab.labbuildr.com"
ddve_hostname       = "ddve1"
ddve_meta_disk_size = 250
ddve_meta_disks =  ["1","2"]
ddve_vm_size = "Standard_F4"
ddve_initial_password = "Change_Me12345_"
EOF

```

# Run Terraform Init
```bash
terraform init
```
## Marketplace Item
Befor applying for the first time:

Marketplace SKU´s T&C´s are applied using
module.ddve.azurerm_marketplace_agreement.ddve if you have already applied the terms and conditions, you can import the resource with
if you previously Accepted T&C´s
```bash
terraform import module.ddve.azurerm_marketplace_agreement.ddve /subscriptions/${ARM_SUBSCRIPTION_ID}/providers/Microsoft.MarketplaceOrdering/agreements/dellemc/offers/dell-emc-datadomain-virtual-edition-v4/plans/ddve-50-ver-72005
```

the resource / agreement will be delted for that instance after terraform destroy

If you want to manually work with the SKU´s here are some hints :-)
Manually Accepting Plan SKU´s T&C´s (should be done automatically from template)

```bash
az vm image list --all --publisher dellemc --query '[].urn'
az vm image accept-terms --urn {one urn from above}
```
accept all
```bash
az vm image list --all --publisher dellemc --query '[].urn'  --output tsv | xargs -L1 az vm image accept-terms --urn
```
---

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
env_name            = "tfdemmo"
location            = "West Europe"
dns_suffix          = "dpslab.labbuildr.com"
ddve_hostname       = "ddve1"
ddve_meta_disks =  ["256","256"]
ddve_initial_password = "Change_Me12345_"
ddve_vm_size = "Standard_F4"
```

```bash
ly -t asdk set-pipeline -c terraforming_ddve/ci/pipeline-ddve.yml -l ../dpslab_labbuildr_local/vars_powerprotect.yml -p ddve-from-terraform
```