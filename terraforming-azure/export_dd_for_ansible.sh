#!/bin/bash
export ppdm_hostname="$(terraform output ppdm_hostname)"
export ddve_initial_password="$(terraform output ddve_initial_password)"
export ppdd_path=$(terraform output ppdd_path)
export PPDD_FQDN=$(terraform output ddve_public_ip_address)

