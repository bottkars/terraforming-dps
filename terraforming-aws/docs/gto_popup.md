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
ssh-keygen -t rsa -b 4096
```
```bash
eval $(ssh-agent)
```
```bash

```
```bash

```

```bash

# 

ssh-add
ssh sysadmin@10.32.12.76

# *hint: if non passphrase is used, set with 
# ssh-keygen -p
```
