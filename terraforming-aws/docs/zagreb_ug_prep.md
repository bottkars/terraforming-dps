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









### Set some environment variables for good, reusable code ...
```bash
PPDM_POLICY=PPDM_GOLD
NAMESPACE=gtopopup
RESTORE_NAMESPACE=restore
STORAGECLASS=$(kubectl get storageclass -o=jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io/is-default-class=="true")].metadata.name}')
# for using storageclass.beta.kubernetes.io :
[ -z "$STORAGECLASS" ] && STORAGECLASS="$(kubectl get storageclass -o=jsonpath='{.items[?(@.metadata.annotations.storageclass\.beta\.kubernetes\.io/is-default-class=="true")].metadata.name}')"
```

### create a Namespace
```bash
kubectl apply -f - <<EOF
kind: Namespace
apiVersion: v1
metadata:
  name: ${NAMESPACE:?variable is empty}
  labels:
    ppdm_policy: ${PPDM_POLICY:?variable is empty}
EOF
```

### create PVC
```bash
kubectl apply -f - <<EOF  
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-${NAMESPACE:?variable is empty}
  namespace: ${NAMESPACE:?variable is empty}
  labels:
    usage: pvc-${NAMESPACE:?variable is empty}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Gi
  storageClassName: ${STORAGECLASS:?variable is empty}
EOF
```  

### get the created PV/C
```bash
kubectl get persistentvolumeclaim -n ${NAMESPACE:?variable is empty}
```

### Create a Pod with the above PVC
```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-${NAMESPACE:?variable is empty}
  namespace: ${NAMESPACE:?variable is empty}
spec:
  volumes:
    - name: pvc-${NAMESPACE:?variable is empty}
      persistentVolumeClaim:
        claimName: pvc-${NAMESPACE:?variable is empty}
  containers:
    - name: container-${NAMESPACE:?variable is empty}
      image: bottkars/dps-automation-image-alpine
      command: ["/bin/sh"]
      args: ["-c", "sleep 100000"]
      volumeMounts:
        - mountPath: "/data"
          name: pvc-${NAMESPACE:?variable is empty}
EOF
```
### wait for pods created
```bash
kubectl wait -n ${NAMESPACE:?variable is empty} pod/pod-${NAMESPACE:?variable is empty} --for condition=Ready --timeout=200s
```
### lets connect to container

```bash
kubectl -n ${NAMESPACE:?variable is empty} exec -it pods/pod-${NAMESPACE:?variable is empty} -- /bin/bash
```
### Creates a 1 GB File:
```bash
head -c 1024m  /dev/zero | openssl enc -aes-128-cbc -pbkdf2 -pass pass:"$(head -c 20 /dev/urandom | base64)"  > /data/my1GBfile
```

## run ppdm setup

[Zagreb_UG_Demo](./zagreb_ug_demo.md)