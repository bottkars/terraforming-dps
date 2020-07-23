# Just a dirty Hack readme
- create a serice prinziple for terraform
- login with sp
- accept T&C´s form SP


# TBD
 - Hot Blob vs. Disks

Export the Env for Terraform:
```bash
ARM_CLIENT_SECRET=yoursecret
ARM_TENANT_ID=your tenantid
ARM_CLIENT_ID=you clientid
ARM_SUBSCRIPTION_ID=your sub
```


Marketplace SKU´s are applied using
module.ddve.azurerm_marketplace_agreement.ddve

As they are only created once ( will try deletion), use
```bash
terraform import module.ddve.azurerm_marketplace_agreement.ddve /subscriptions/${ARM_SUBSCRIPTION_ID}/providers/Microsoft.MarketplaceOrdering/agreements/dellemc/offers/dell-emc-datadomain-virtual-edition-v4/plans/ddve-50-ver-72005
```

Manually Accepting Plan SKU´s T&C´s (should be done automatically from template)

```bash
az vm image list --all --publisher dellemc --query '[].urn'
az vm image accept-terms --urn {one urn from above}
```
accept all
```bash
az vm image list --all --publisher dellemc --query '[].urn'  --output tsv | xargs -L1 az vm image accept-terms --urn
```

# for connection from bastion
getting output for ssh_private_key:
```bash
terraform output ddve_ssh_private_key
```

terraform import azurerm_marketplace_agreement.ddve /subscriptions/a8792c3f-87e1-4399-bb6e-a2ddb09bf582/providers/Microsoft.MarketplaceOrdering/offerTypes/VirtualMachine/publishers/dellemc/offers/dell-emc-datadomain-virtual-edition-v4/plans/ddve-50-ver-72005