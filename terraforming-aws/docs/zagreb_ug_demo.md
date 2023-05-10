


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








### Set some environment variables for good, reusable code ...
```bash
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
kubectl get persistentvolumeclaim
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











