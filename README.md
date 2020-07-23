# Just a dirty Hack readme
- create a serice prinziple for terraform
- login with sp
- accept T&C´s form SP


Export the Env for Terraform:
```bash
ARM_CLIENT_SECRET=yoursecret
ARM_TENANT_ID=your tenantid
ARM_CLIENT_ID=you clientid
ARM_SUBSCRIPTION_ID=your sub
```
Accepting Plan SKU´s T&C´s

```bash
az vm image list --all --publisher dellemc --query '[].urn'
az vm image accept-terms --urn {one urn from above}
```
accept all
```bash
az vm image list --all --publisher dellemc --query '[].urn'  --output tsv | xargs -L1 az vm image accept-terms --urn
```


resource "azurerm_marketplace_agreement" "barracuda" {
  publisher = "barracudanetworks"
  offer     = "waf"
  plan      = "hourly"
}