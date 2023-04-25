## GTO Demo for CSI and PPDM 

### Check Requirements
```bash
kubectl get storageclasses.storage.k8s.io
kubectl get volumesnapshotclasses.snapshot.storage.k8s.io
```
### Set some environment variables for good, reusable code ...
```bash
NAMESPACE=gtopopup
RESTORE_NAMESPACE=restore
```
### Get the default Storageclass
```bash
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
  name: ${NAMESPACE}
  labels:
    ppdm_policy: ${PPDM_POLICY}
EOF
```

### create PVC
```bash
kubectl apply -f - <<EOF  
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-${NAMESPACE}
  namespace: ${NAMESPACE}
  labels:
    usage: pvc-${NAMESPACE}
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Gi
  storageClassName: ${STORAGECLASS}
EOF
```  

### get the created PV/C
```
kubectl get persistentvolume
```

### Create a Pod with the above PVC
```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: pod-${NAMESPACE}
  namespace: ${NAMESPACE}
spec:
  volumes:
    - name: pvc-${NAMESPACE}
      persistentVolumeClaim:
        claimName: pvc-${NAMESPACE}
  containers:
    - name: container-${NAMESPACE}
      image: bottkars/dps-automation-image-alpine
      command: ["/bin/sh"]
      args: ["-c", "sleep 100000"]
      volumeMounts:
        - mountPath: "/data"
          name: pvc-${NAMESPACE}
EOF
```
### wait for pods created
```bash
kubectl wait -n ${NAMESPACE} pod/pod-${NAMESPACE} --for condition=Ready --timeout=200s
```
### lets connect to container

```bash
kubectl -n ${NAMESPACE} exec -it pods/pod-${NAMESPACE} -- /bin/bash
```
### Creates a 1 GB File:
```bash
head -c 1024m  /dev/zero | openssl enc -aes-128-cbc -pbkdf2 -pass pass:"$(head -c 20 /dev/urandom | base64)"  > /data/my1GBfile
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