# Walktrugh GTO Popup  "CRS on AWS ... what they didn´t tell you"
## show `em Tags !
```bash
aws resourcegroupstaggingapi get-tag-keys --query 'TagKeys[?starts_with(@, `cr.`)]'
```
## staring by vault, us local terminal

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
## rdp into crs host and open powershell

```powershell
# Powershell (run-as admin )
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent

# Powershell user
# created a .ssh/ppcr file from cf provided private key
ssh-add -L
ssh-add .\.ssh\ppcr
ssh -i ppcr ec2-user@ip-10-32-12-248

# *hint: if non passphrase is used, set with 
# ssh-keygen -p .\ppcr
```

## on crs from jump rdp
```bash
# create id_rsa if not exist
[[ -f ~/.ssh/id_rsa.pub ]] && echo "ssh key already exists" || ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

```
## ssh into datadomain, add keyfile
```bash

# ssh into dd as sysadmin 
ssh sysadmin@10.32.12.76

```

```bash
# add key file in vault dd
adminaccess add ssh-keys user sysadmin

```
## only first time, add host enties for name to ip resolution ( don't call it dns :-) 
```bash
# from vault crs host
VAULT_DD_NAME="ip-10-32-12-76.eu-central-1.compute.internal"
SOURCE_DD_PORT="192.168.1.96" 
CONNECTION_HOST=sourcedd_ethv1
SSH_EXEC=sysadmin@${VAULT_DD_NAME}
ssh ${SSH_EXEC} net hosts add ${SOURCE_DD_PORT} ${CONNECTION_HOST}
ssh ${SSH_EXEC} net hosts show

```

