# Demo Setup.......

#### configure using ansible
export outputs from terraform into environment variables:
```bash
export DDVE_PUBLIC_FQDN=$(terraform output -raw ddve_private_ip)
export DDVE_USERNAME=sysadmin
export DDVE_INITIAL_PASSWORD=$(terraform output -raw ddve_instance_id)
export DDVE_PASSWORD=Change_Me12345_
export PPDD_PASSPHRASE=Change_Me12345_!
export DDVE_PRIVATE_FQDN=$(terraform output -raw ddve_private_ip)
export ATOS_BUCKET=$(terraform output -raw atos_bucket)
export PPDD_LICENSE=$(cat ~/workspace/internal.lic)
export PPDD_TIMEZONE="Europe/Berlin"
```
Configure DataDomain

set the Initial DataDomain Password
```bash
ansible-playbook ~/workspace/ansible_dps/ppdd/1.0-Playbook-configure-initial-password.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/3.0-Playbook-set-dd-license.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/2.1-Playbook-configure-ddpassphrase.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/2.1.1-Playbook-set-dd-timezone-and-ntp-aws.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/2.2-Playbook-configure-dd-atos-aws.yml
```
this concludes basic DDVE Configuration




## eks config

```bash
aws eks update-kubeconfig --name $(terraform output --raw kubernetes_cluster_name)
```

we need to create snapshot crd´s  and snapshotter
```bash
kubectl apply -k "github.com/kubernetes-csi/external-snapshotter/client/config/crd/?ref=release-6.1"
kubectl apply -k "github.com/kubernetes-csi/external-snapshotter/deploy/kubernetes/snapshot-controller/?ref=release-6.1"
```




and then add the CSI Driver:
```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.18"
```


Let´s create and view the Storageclasses

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/examples/kubernetes/dynamic-provisioning/manifests/storageclass.yaml
kubectl get sc
```

We need to create a new default class

```bash
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass ebs-sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl get sc
```
we need to create a Volumesnapshotclass:
```
kubectl apply -f - <<EOF
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: ebs-snapclass
driver: ebs.csi.aws.com
deletionPolicy: Delete
EOF
```

## run ppdm demo

[PPDM_K8S_Demo](../documentation/kubernetes_demo_workload.md)








## Deploy ppdm
set
```bash
export TF_VAR_ppdm_count=1
tfp
```
deploy
```bash
tfa --auto-approve
```
## Configure PowerProtect DataManager

Similar to the DDVE Configuration, we will set Environment Variables for Ansible to Automatically Configure PPDM

```bash
# Refresh you Environment Variables if Multi Step !
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