#!/bin/bash
export PPDM_INITIAL_PASSWORD="$(terraform output PPDM_INITIAL_PASSWORD)"
export DDVE_INITIAL_PASSWORD="$(terraform output DDVE_INITIAL_PASSWORD)"
export PPDM_FQDN="$(terraform output PPDM_FQDN)"
export DVE_PRIVATE_FQDN="$(terraform output DDVE_PRIVATE_FQDN)"
export DDVE_FQDN=${DDVE_PRIVATE_FQDN%?}
export PPDD_PATH=$(terraform output PPDD_PATH)
export PPDD_FQDN=$(terraform output DDVE_PUBLIC_IP_ADDRESS)

