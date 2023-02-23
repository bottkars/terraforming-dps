RESOURCE_GROUP=CRS
az group create --name ${RESOURCE_GROUP:?variable is empty} --location germanywestcentral

az deployment group validate --resource-group ${RESOURCE_GROUP:?variable is empty}\
    --template-file $HOME/workspace/201_solution_crs/CRS_template_kb.json \
    --parameters $HOME/workspace/201_solution_crs/CRS_parameters_kb.json


az deployment group create --resource-group ${RESOURCE_GROUP:?variable is empty}\
    --template-file $HOME/workspace/201_solution_crs/CRS_template_kb.json \
    --parameters $HOME/workspace/201_solution_crs/CRS_parameters_kb.json

az group delete --resource-group $RESOURCE_GROUP

start powershell

ssh azureuser@10.50.0.30
sudo /opt/dellemc/cr/bin/crsetup.sh --reset

Run as Administrator
.$HOME\aws-cis-regedit.exe enableFileTransfer

secoff1 Change_Me12345_!
passphrase Change_Me12345_!




## Configure DD ( vi cr host )

ssh sysadmin@10.50.0.20
net route show tables ipversion ipv4
net route add gateway 10.50.0.17 interface ethV1
system reboot

VAULT_DD="10.50.0.20"
ssh-keygen -t rsa -b 4096
ssh sysadmin@${VAULT_DD}
adminaccess add ssh-keys user sysadmin
user add cradmin role admin
user add secoff1 role security
system passphrase set
exit
ssh secoff1@${VAULT_DD}
authorization policy set security-officer enabled
user add secoff2 role security
exit
ssh cradmin@${VAULT_DD}
net host add 192.168.1.96 sourcedd_ethv1


storage object-store enable
storage object-store profile set
storage add dev5 tier active
filesys create
filesys enable
ddboost enable



###

open sesame:


add 2051 to PPCR-ppcr-dd-nsg



## set replication context 
#### in vault
MTREE=/data/col1/SysDR_ppdm
VAULT_DD_NAME=PPCR-DDVE.local
VAULT_DD_PORT=10.50.0.25
VAULT_DD_IP=10.50.0.20
SSH_EXEC=sysadmin@${VAULT_DD_IP}
SOURCE_DD_NAME=ddve.home.labbuildr.com


cat <<EOF
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host sourcedd_ethv1 port 2051"
EOF



#### at source
SSH_EXEC=sysadmin@ddve.home.labbuildr.com
VAULT_DD_NAME=PPCR-DDVE.local
VAULT_DD_PORT=10.50.0.25
VAULT_DD_IP=10.50.0.20
SOURCE_DD_NAME=ddve.home.labbuildr.com
ssh ${SSH_EXEC} "net hosts add ${VAULT_DD_PORT} azurevault-ethv1"  
ssh ${SSH_EXEC} "net hosts add ${VAULT_DD_IP} ${VAULT_DD_NAME}"  

MTREE=/data/col1/SysDR_ppdm
MTREE=/data/col1/flrtest-ppdm-8c03e
MTREE=/data/col1/fs_demo-ppdm-45b20
MTREE=/data/col1/win_test-ppdm-22335
ssh ${SSH_EXEC} "net hosts add ${VAULT_DD_PORT} ${VAULT_DD_NAME}"
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "net hosts add ${VAULT_DD_PORT} azurevault-ethv1" 
ssh ${SSH_EXEC} "replication modify  mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host azurevault-ethv1 port 2051"
ssh ${SSH_EXEC} "replication initialize mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication watch mtree://${VAULT_DD_NAME}${MTREE}_repl"


### ddve.home.labbuildr.com
VAULT_DD_NAME=vaultdd.vault.home.labbuildr.com
VAULT_PORT_NAME=vault-ethv1
MTREE=/data/col1/vault_updates
SOURCE_DD_NAME=ddve.home.labbuildr.com
SSH_EXEC=sysadmin@ddve.home.labbuildr.com
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host ${VAULT_PORT_NAME} port 2051"

#### in vault

SSH_EXEC=sysadmin@${VAULT_DD_NAME}
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host sourcedd_ethv1 port 2051"
