# Demo Time !
Can we beat 30 Minutes to first (client) Backup


## Deploy ppdm

```bash
tfp -var ppdm_count=1
```
deploy
```bash
tfa -var ppdm_count=1 --auto-approve
```
check for the instance Logs
```bash
aws ec2 get-console-output --instance-id $(terraform output -raw ppdm_instance_id)
```
## Configure PowerProtect DataManager

Similar to the DDVE Configuration, we will set Environment Variables for Ansible to Automatically Configure PPDM
# Refresh you Environment Variables if Multi Step !
```bash
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^PP+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
export PPDM_INITIAL_PASSWORD=Change_Me12345_
export PPDM_NTP_SERVERS='["13.40.30.100","52.56.60.39"]'
export PPDM_SETUP_PASSWORD=admin          # default password on the GKE PPDM
export PPDM_TIMEZONE="Europe/Berlin"
export PPDM_POLICY=PPDM_GOLD
```


Set the initial Configuration:    
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/1.0-playbook_configure_ppdm.yml
```
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/2.0-playbook_set_ddve.yml 
ansible-playbook ~/workspace/ansible_dps/ppdm/3.0-playbook_get_sdr.yml
```
add the cluster to powerprotect
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/playbook_set_k8s_root_cert.yml --extra-vars "certificateChain=$(eksctl get cluster tfeks1 -o yaml | awk '/Cert/{getline; print $2}')"
ansible-playbook ~/workspace/ansible_dps/ppdm/playbook_rbac_add_k8s_to_ppdm.yml
```
and we add a PPDM Policy / Rule
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/playbook_add_k8s_policy_and_rule.yml
```

## trigger a ppdm discovery
the ppdm discovery should invoke the protection rule for the newly discovered namespaces and add the to teh policy 
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/playbook_start_k8s_discoveries.yml
```

### run the backup ....
Finally, we can stat the Policy AdHoc:

```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/playbook_start_k8s_policy.yml
```



#### some adwanced talks

```bash
kubectl api-resources --verbs=list --namespaced -o name
```

```bash
kubectl get backupjobs -n powerprotect
```

```bash
./restore_to_new.sh
```








