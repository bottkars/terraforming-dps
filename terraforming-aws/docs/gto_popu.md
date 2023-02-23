# walktru GTO Popu  CRS AWS ... what they didn´t tell you
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
echo $RETURN
```
## rdp into crs host and open powershell