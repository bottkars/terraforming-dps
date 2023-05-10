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
```
if that worked ... api ok
```bash
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
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.18"
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/examples/kubernetes/dynamic-provisioning/manifests/storageclass.yaml
kubectl get sc
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


## run ppdm setup

[PPDM_K8S_Demo](./zagreb_ug_demo.md)