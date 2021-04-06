#!/bin/bash
export PPDM_HOSTNAME="$(terraform output PPDM_HOSTNAME)"
export DDVE_INITIAL_PASSWORD="$(terraform output DDVE_INITIAL_PASSWORD)"
export PPDD_PATH=$(terraform output PPDD_PATH)
export PPDD_FQDN=$(terraform output DDVE_PUBLIC_IP_ADDRESS)

