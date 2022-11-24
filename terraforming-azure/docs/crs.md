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
notepad ppcr.
ssh azureuser@10.150.0.30
sudo /opt/dellemc/cr/bin/crsetup.sh --reset
scp -i ppcr ec2-user@10.32.12.248:/home/ec2-user/aws_cr/aws-cis-regedit.exe $HOME
Run as Administrator
.$HOME\aws-cis-regedit.exe enableFileTransfer

secoff1 Change_Me12345_!_
Change_Me12345_!




## Configure DD ( vi cr host )

ssh sysadmin@10.150.0.20
net route show tables ipversion ipv4
net route add gateway 10.150.0.25 interface ethV1


VAULT_DD="10.150.0.20"
ssh-keygen -t rsa -b 4096
ssh sysadmin@10.32.12.
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
storage add dev3, dev4 tier active
filesys create
filesys enable
ddboost enable



###

open sesame:





## set replication context 
#### in vault
MTREE=/data/col1/SysDR_ppdm_repl
VAULT_DD_NAME=PPCR-DDVE.local
VAULT_DD_PORT=10.32.12.71
SSH_EXEC=sysadmin@${VAULT_DD_NAME}
SOURCE_DD_NAME=ddve.home.labbuildr.com


cat <<EOF
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host sourcedd_ethv1 port 2051"
EOF



#### at source
SSH_EXEC=sysadmin@ddve.home.labbuildr.com
VAULT_DD_NAME=PPCR-DDVE.local
VAULT_DD_PORT=10.150.0.25
SOURCE_DD_NAME=ddve.home.labbuildr.com
ssh ${SSH_EXEC} "net hosts add azure${VAULT_DD_PORT} vault-ethv1"  


MTREE=/data/col1/SysDR_ppdm
MTREE=/data/col1/flrtest-ppdm-8c03e
MTREE=/data/col1/fs_demo-ppdm-45b20
MTREE=/data/col1/win_test-ppdm-22335
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify  mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host azurevault-ethv1 port 2051"
ssh ${SSH_EXEC} "replication initialize mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication watch mtree://${VAULT_DD_NAME}${MTREE}_repl"
