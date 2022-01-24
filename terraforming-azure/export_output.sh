#!/bin/bash
export ppdm_initial_password="$(terraform output ppdm_initial_password)"
export ddve_initial_password="$(terraform output ddve_initial_password)"
export PPDM_FQDN="$(terraform output PPDM_FQDN)"
export DVE_PRIVATE_FQDN="$(terraform output ddve_private_fqdn)"
export DDVE_FQDN=${ddve_private_fqdn%?}
export ppdd_path=$(terraform output ppdd_path)
export PPDD_FQDN=$(terraform output ddve_public_ip_address)

