
# Create a Parameter file
example
```json
[
    "PrivateSubnet1CIDR=10.32.11.0/24",	
    "productionDdIpAddress=192.168.1.96/32",
    "VpcCIDR=10.32.0.0/16",	
    "PrivateSubnet2CIDR=10.32.12.0/24",	
    "ddInstanceKeyPairName=dps-kb-ddcr-key",	
    "jhInstanceKeyPairName=dps-kb-crjump-key",	
    "DdveModel=m5.xlarge--up-to-16TB",	
    "VpcPrefix=cr-kb",	
    "productionClientIpAddress=192.168.1.0/24",	
    "crInstanceKeyPairName=dps-kb-ppcr-key",	
    "DdveMetadataDiskNumber=Default"
]
```







Deploy the Template ( requires an existing bucket)

```aws
aws cloudformation deploy --template-file /mnt/c/Users/Karsten_Bott/Downloads/template1_cr.cform \
--stack-name crkb \
--parameter-overrides file://cformation.tfvars.json \
--s3-bucket cf-templates-96rf3yk41dpj-eu-central-1 \
--capabilities CAPABILITY_NAMED_IAM
```
```bash
aws cloudformation describe-stacks \
--stack-name crkb \
--query "Stacks[0].Outputs[*]" --output json --no-paginate 2>&1| jq -r 'to_entries[] |  "\(.value.OutputKey)=\(.value.OutputValue)"'
```

# export outputs to terrafrom vaiables
```bash
eval $(aws cloudformation describe-stacks \
--stack-name crkb \
--query "Stacks[0].Outputs[*]" --output json --no-paginate 2>&1| jq -r 'to_entries[] |  "export TF_VAR_\(.value.OutputKey)=\(.value.OutputValue)"')
```




CR_ROUTETABLE=$(aws resourcegroupstaggingapi get-resources \
  --tag-filters "Key=cr.route-table.route" \
  --query "ResourceTagMappingList[0].ResourceARN" \
  --output text)

VPC=$(aws resourcegroupstaggingapi get-resources \
  --tag-filters "Key=cr.cloud-vault.vpc" \
  --query "ResourceTagMappingList[0].ResourceARN" \
  --output text)

export TF_VAR_crs_private_route_table=${CR_ROUTETABLE##*/}
export TF_VAR_crs_vpc_id=${VPC##*/}
export TF_VAR_create_crs_s2s_vpn=true

add the tunnel ip to vpn server on premises



DDVE_INSTANCE=$(aws resourcegroupstaggingapi get-resources \
  --tag-filters "Key=cr.vault-ddve.ec2" \
  --query "ResourceTagMappingList[0].ResourceARN" \
  --output text)


export VAULT_DD_NAME=$(aws ec2 describe-network-interfaces \
  --filters Name=attachment.instance-id,Values=${DDVE_INSTANCE##*/} Name=attachment.device-index,Values=1 \
  --query "NetworkInterfaces[0].PrivateDnsName" \
  --output text)


VAULT_REPL_IP=$(aws ec2 describe-network-interfaces \
--filters Name=attachment.instance-id,Values=${DDVE_INSTANCE##*/} Name=attachment.device-index,Values=1 \
  --query "NetworkInterfaces[0]."PrivateIpAddress" \
  --output text)

get the password with the key from 
```
tfo crjump_ssh_private_key
```

current pass txQoNZydY;3gk$?TqO$9&YMt5gWciXxw

start powershell
notepad ppcr.
copy private key of ppcr ( output of tfo ppcr_ssh_private_key )

ssh -i ppcr ec2-user@10.32.12.248
sudo /opt/dellemc/cr/bin/crsetup.sh --reset
scp -i ppcr ec2-user@10.32.12.248:/home/ec2-user/aws_cr/aws-cis-regedit.exe $HOME
Run as Administrator
.$HOME\aws-cis-regedit.exe enableFileTransfer

secoff1 Change_Me12345_!_
Change_Me12345_!




## Configure DD ( vi cr host )
VAULT_DD="10.32.12.76"
ssh-keygen -t rsa -b 4096
ssh -i ppcr ec2-user@10.32.12.76

VAULT_DD="10.32.12.76"
ssh-keygen -t rsa -b 4096
ssh sysadmin@10.32.12.
adminaccess add ssh-keys user sysadmin
user add cradmin role admin
user add secoff1 role security

exit
ssh secoff1@${VAULT_DD}
authorization policy set security-officer enabled
user add secoff2 role security
exit
ssh cradmin@${VAULT_DD}
net host add 192.168.1.96 sourcedd_ethv1

system passphrase set
storage object-store enable
storage object-store profile set
storage add dev3, dev4 tier active
ddboost enable



###

open sesame:

ACL_ARN=$(aws resourcegroupstaggingapi get-resources \
  --tag-filters "Key=cr.private2-subnet.acl" \
  --query "ResourceTagMappingList[0].ResourceARN"\
  --output text)

SG_ARN=$(aws resourcegroupstaggingapi get-resources \
  --tag-filters "Key=cr.vault-ddve.sg" \
  --query "ResourceTagMappingList[0].ResourceARN" \
  --output text)
DD_RANGE=$(aws resourcegroupstaggingapi get-resources \
  --tag-filters "Key=cr.prod-dd-ip-range.info" \
  --query 'ResourceTagMappingList[].Tags[?Key==`cr.prod-dd-ip-range.info`].Value[]' \
  --output text)



CREATE_ACL=$(aws ec2 create-network-acl-entry \
--network-acl-id ${ACL_ARN##*/} \
--ingress \
--rule-number 500 \
--protocol tcp \
--port-range From=2051,To=2051 \
--cidr-block ${DD_RANGE} \
--rule-action allow )


ALLOW=$(aws ec2 authorize-security-group-ingress \
    --group-id ${SG_ARN##*/}  \
    --protocol tcp \
    --port 2051 \
    --cidr ${DD_RANGE})

DELETE_ACL=$(aws ec2 delete-network-acl-entry \
--network-acl-id ${ACL_ARN##*/} \
--ingress \
--rule-number 500)

REVOKE=$(aws ec2 revoke-security-group-ingress \
    --group-id ${SG_ARN##*/} \
    --protocol tcp \
    --port 2051 \
    --cidr ${DD_RANGE})



## set replication context 
#### in vault
cat <<EOF
VAULT_DD_PORT=10.32.12.71
SSH_EXEC=sysadmin@${VAULT_DD_NAME}
SOURCE_DD_NAME=ddve.home.labbuildr.com
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host sourcedd_ethv1 port 2051"
EOF



#### at source
SSH_EXEC=sysadmin@ddve.home.labbuildr.com
VAULT_DD_PORT=${VAULT_REPL_IP}
SOURCE_DD_NAME=ddve.home.labbuildr.com
ssh ${SSH_EXEC} "net hosts add ${VAULT_DD_PORT} vault-ethv1"  


MTREE=/data/col1/SysDR_ppdm
MTREE=/data/col1/flrtest-ppdm-8c03e
MTREE=/data/col1/fs_demo-ppdm-45b20
MTREE=/data/col1/win_test-ppdm-22335
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify  mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host vault-ethv1 port 2051"
ssh ${SSH_EXEC} "replication initialize mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication watch mtree://${VAULT_DD_NAME}${MTREE}_repl"





