
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
  --query "NetworkInterfaces[0].PrivateIpAddress" \
  --output text)

get the password with the key from 
```
tfo crjump_ssh_private_key
```

current pass txQoNZydY;3gk$?TqO$9&YMt5gWciXxw

_Profile: crkb-crInstanceProfile-8LoS8y2DASws
_role

### Recreating Profile Policy and Rule for DDVE

aws iam create-instance-profile --instance-profile-name crkb-ddInstanceProfile-FnCWYyfwpWAL
aws iam create-role --role-name cr-kb_ddRole --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}'
aws iam add-role-to-instance-profile --instance-profile-name crkb-ddInstanceProfile-FnCWYyfwpWAL --role-name cr-kb_ddRole
aws iam tag-role --role-name cr-kb_ddRole --tags Key=cr.ddve-role.iam,Value="" Key=Name,Value="cr-kb_PPCR DDVE S3 Role"
aws iam put-role-policy --role-name cr-kb_ddRole --policy-name cr.dds3.policy --policy-document '{"Version":"2012-10-17","Statement":[{"Action":["s3:ListBucket","s3:GetObject","s3:PutObject","s3:DeleteObject"],"Resource":["arn:aws:s3:::crkb-dds3bucket-1i51su4wjvf9n","arn:aws:s3:::crkb-dds3bucket-1i51su4wjvf9n/*"],"Effect":"Allow"}]}'


INSTANCE_PROFILE="crkb-crInstanceProfile-8LoS8y2DASws"
IAM_ROLE="cr-kb_PPCRRole"
aws iam create-instance-profile --instance-profile-name ${INSTANCE_PROFILE}
aws iam create-role --role-name ${IAM_ROLE} --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}'
aws iam add-role-to-instance-profile --instance-profile-name ${INSTANCE_PROFILE} --role-name ${IAM_ROLE}
aws iam tag-role --role-name ${IAM_ROLE} --tags Key=cr.iam-role.iam,Value="" Key=Name,Value="cr-kb_PPCR Role"
aws iam put-role-policy --role-name ${IAM_ROLE} --policy-name cr.automation.policy --policy-document '{"Version":"2012-10-17","Statement":[{"Action":["ec2:RevokeSecurityGroupIngress","ec2:AuthorizeSecurityGroupEgress","ec2:AuthorizeSecurityGroupIngress","ec2:RevokeSecurityGroupEgress","ec2:DeleteNetworkAclEntry","ec2:DescribeNetworkAcls","ec2:CreateNetworkAclEntry","ec2:DescribeSecurityGroups","ec2:DescribeSubnets"],"Resource":["*"],"Effect":"Allow"}]}'



_Polixcy: 


{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::crkb-dds3bucket-1i51su4wjvf9n",
                "arn:aws:s3:::crkb-dds3bucket-1i51su4wjvf9n/*"
            ],
            "Effect": "Allow"
        }
    ]
}

start powershell
notepad ppcr.
copy private key of ppcr ( output of tfo ppcr_ssh_private_key )

ssh -i ppcr ec2-user@10.32.12.248
sudo /opt/dellemc/cr/bin/crsetup.sh --reset
scp -i ppcr ec2-user@10.32.12.248:/home/ec2-user/aws_cr/aws-cis-regedit.exe $HOME
Run as Administrator
.$HOME\aws-cis-regedit.exe enableFileTransfer

secoff1 Change_Me12345_!_
secoff2 Password123!

Change_Me12345_!
Change_Me12345_!_

crso Change_Me12345_!
cradmin Password123!

## Configure DD ( vi cr host )
VAULT_DD="10.32.12.76"
VAULT_DD_NAME="ip-10-32-12-76.eu-central-1.compute.internal"
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
Beware of possible errors:


Ports not open ( 2051 and 3009, ethv1)
**** Error getting CA certificate for ip-10-32-12-76.eu-central-1.compute.internal (**** Error communicating with host ip-10-32-12-76.eu-central-1.compute.internal: the operation timed out.).
```bash
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



aws ec2 create-network-acl-entry \
--network-acl-id ${ACL_ARN##*/} \
--ingress \
--rule-number 500 \
--protocol tcp \
--port-range From=2051,To=2051 \
--cidr-block ${DD_RANGE} \
--rule-action allow 

aws ec2 authorize-security-group-ingress \
    --group-id ${SG_ARN##*/}  \
    --protocol tcp \
    --port 2051 \
    --cidr ${DD_RANGE}


aws ec2 create-network-acl-entry \
--network-acl-id ${ACL_ARN##*/} \
--ingress \
--rule-number 501 \
--protocol tcp \
--port-range From=3009,To=3009 \
--cidr-block ${DD_RANGE} \
--rule-action allow 

aws ec2 authorize-security-group-ingress \
    --group-id ${SG_ARN##*/}  \
    --protocol tcp \
    --port 3009 \
    --cidr ${DD_RANGE}

### delete
aws ec2 delete-network-acl-entry \
--network-acl-id ${ACL_ARN##*/} \
--ingress \
--rule-number 500

aws ec2 revoke-security-group-ingress \
    --group-id ${SG_ARN##*/} \
    --protocol tcp \
    --port 2051 \
    --cidr ${DD_RANGE}

aws ec2 delete-network-acl-entry \
--network-acl-id ${ACL_ARN##*/} \
--ingress \
--rule-number 501


aws ec2 revoke-security-group-ingress \
    --group-id ${SG_ARN##*/} \
    --protocol tcp \
    --port 3009 \
    --cidr ${DD_RANGE}
```


## set replication context 


#### in vault

#### Setup Host Names 
VAULT_DD_NAME="ip-10-32-12-76.eu-central-1.compute.internal"
SOURCE_DD_PORT="192.168.1.96"
CONNECTION_HOST=sourcedd_ethv1
SSH_EXEC=sysadmin@${VAULT_DD_NAME}
ssh ${SSH_EXEC} net hosts add ${SOURCE_DD_PORT} ${CONNECTION_HOST}
ssh ${SSH_EXEC} net hosts show

cat <<EOF>dd_env.sh
eval \$(ssh-agent)
ssh-add
VAULT_DD_NAME="ip-10-32-12-76.eu-central-1.compute.internal"
SOURCE_DD_NAME=ddve.home.labbuildr.com
CONNECTION_HOST=sourcedd_ethv1
SSH_EXEC=sysadmin@${VAULT_DD_NAME}
EOF
##### setup a repl pair

source dd_env.sh
MTREE=/data/col1/vault_updates_are_so_bogus
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}"_repl"
ssh ${SSH_EXEC} "replication modify mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host ${CONNECTION_HOST} port 2051"




#### at source

#### once off
DDVE_INSTANCE=$(aws resourcegroupstaggingapi get-resources \
  --tag-filters "Key=cr.vault-ddve.ec2" \
  --query "ResourceTagMappingList[0].ResourceARN" \
  --output text)

VAULT_DD_NAME=$(aws ec2 describe-network-interfaces \
  --filters Name=attachment.instance-id,Values=${DDVE_INSTANCE##*/} Name=attachment.device-index,Values=1 \
  --query "NetworkInterfaces[0].PrivateDnsName" \
  --output text)


VAULT_REPL_IP=$(aws ec2 describe-network-interfaces \
--filters Name=attachment.instance-id,Values=${DDVE_INSTANCE##*/} Name=attachment.device-index,Values=1 \
  --query "NetworkInterfaces[0].PrivateIpAddress" \
  --output text)

VAULT_IP=$(aws ec2 describe-network-interfaces \
--filters Name=attachment.instance-id,Values=${DDVE_INSTANCE##*/} Name=attachment.device-index,Values=0 \
  --query "NetworkInterfaces[0].PrivateIpAddress" \
  --output text)

SOURCE_DD_NAME=ddve.home.labbuildr.com
CONNECTION_HOST=awsvault-ethv1
SSH_EXEC=sysadmin@${SOURCE_DD_NAME}
ssh ${SSH_EXEC} "net hosts add ${VAULT_REPL_IP} ${CONNECTION_HOST}"
ssh ${SSH_EXEC} "net hosts add ${VAULT_IP} ${VAULT_DD_NAME}"


cat <<EOF>dd_env.sh
VAULT_DD_NAME=${VAULT_DD_NAME}
SOURCE_DD_NAME=${SOURCE_DD_NAME}
CONNECTION_HOST=${CONNECTION_HOST}
SSH_EXEC=sysadmin@${SOURCE_DD_NAME}
EOF

source ./dd_env.sh
MTREE=/data/col1/vault_updates
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify  mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host awsvault-ethv1 port 2051"
ssh ${SSH_EXEC} "replication initialize mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication watch mtree://${VAULT_DD_NAME}${MTREE}_repl"


MTREE=/data/col1/SysDR_ppdm
MTREE=/data/col1/flrtest-ppdm-8c03e
MTREE=/data/col1/fs_demo-ppdm-45b20
MTREE=/data/col1/win_test-ppdm-22335
MTREE=/data/col1/
ssh ${SSH_EXEC} "replication add source mtree://${SOURCE_DD_NAME}${MTREE} destination mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication modify  mtree://${VAULT_DD_NAME}${MTREE}_repl connection-host awsvault-ethv1 port 2051"
ssh ${SSH_EXEC} "replication initialize mtree://${VAULT_DD_NAME}${MTREE}_repl"
ssh ${SSH_EXEC} "replication watch mtree://${VAULT_DD_NAME}${MTREE}_repl"



ssh ${SSH_EXEC} "nfs export create path /data/col1/vault_updates clients 192.168.1.60/32"


### start // stop crs servers
```bash
OP=start-instances
INSTANCE_ARN=()
for INSTANCE_TAG in cr.vault-ddve.ec2 cr.vault-mgmt-host.ec2 cr.vault-jump-host.ec2
do
INSTANCE_ARN+=$(aws resourcegroupstaggingapi get-resources \
  --tag-filters "Key=${INSTANCE_TAG}" \
  --query "ResourceTagMappingList[0].ResourceARN"\
  --output text)
done
echo Starting Instances ${INSTANCE_ARN[@]##*/}
aws ec2 ${OP} --instance-ids ${INSTANCE_ARN[@]##*/}
```




```bash
```
```json
# who dis tags
aws resourcegroupstaggingapi get-tag-keys --query 'TagKeys[?starts_with(@, `cr.`)]'
[
    "cr.cloud-vault.vpc",
    "cr.private-subnet2.acl",
    "cr.private1-subnet.acl",
    "cr.private1.subnet",
    "cr.private2-subnet.acl",
    "cr.private2.subnet",
    "cr.prod-dd-ip-range.info",
    "cr.route-table.route",
    "cr.vault-ddve.ec2",
    "cr.vault-ddve.sg",
    "cr.vault-ec2-endpoint.sg",
    "cr.vault-jump-host.ec2",
    "cr.vault-jump-host.sg",
    "cr.vault-mgmt-host.ec2",
    "cr.vault-mgmt-host.sg"
]
```
