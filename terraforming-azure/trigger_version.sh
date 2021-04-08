#!/bin/bash
export TF_VARS_FILE=asdk/terraform/terraforming-dps/terraform_'$timestamp'.auto.tfvars.json
export timestamp=$(date "+%Y.%m.%d-%H%M")
export TF_VARS_FILE_BACKEND=$(echo "$TF_VARS_FILE" | envsubst)
lpass show dps\\azure_dell_msdn/tf_vars_json --notes > terraform.tfvars.json
mc mv terraform.tfvars.json $TF_VARS_FILE_BACKEND
