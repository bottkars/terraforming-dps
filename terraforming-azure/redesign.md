## Configuration

## Configure DataDomain
```bash
export DDVE_PUBLIC_FQDN=$(terraform output -raw ddve_private_ip)
export DDVE_USERNAME=sysadmin
export DDVE_INITIAL_PASSWORD=changeme
export DDVE_PASSWORD=Change_Me12345_
export PPDD_PASSPHRASE=Change_Me12345_!
export DDVE_PRIVATE_FQDN=$(terraform output -raw ddve_private_fqdn)
export PPDD_LICENSE=$(cat ~/workspace/ansible_dps/ppdd/internal.lic)
export PPDD_TIMEZONE="Europe/Berlin"
export DEPLOYMENT_DOMAIN=$(terraform output -raw DEPLOYMENT_DOMAIN)
```



``bash
ansible-playbook ~/workspace/ansible_dps/ppdd/1.0-Playbook-configure-initial-password.yml
```

```bash
ansible-playbook ~/workspace/ansible_dps/ppdd/3.0-Playbook-set-dd-license.yml
```

```bash
ansible-playbook ~/workspace/ansible_dps/ppdd/2.1-Playbook-configure-ddpassphrase.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/2.2-Playbook-configure-dd-block.yml
```



```bash
ansible-playbook ~/workspace/ansible_dps/ppdd/3.1-Playbook-set-dd-networks.yml \
--extra-vars "ppdd_hostname=${DDVE_PRIVATE_FQDN}" \
--extra-vars "ppdd_dns_1=168.63.129.16" 
```


## Configure PowerProtect DataManager

```bash
export PPDM_PRIVATE_IP=$(terraform output -raw PPDM_PRIVATE_IP)
export PPDM_HOSTNAME=$(terraform output -raw PPDM_HOSTNAME)
export PPDM_PASSWORD=Change_Me12345_
```


Set the initial Configuration:  
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/1.0-playbook_configure_ppdm.yml \
--extra-vars "ppdm_fqdn=https://${PPDM_PRIVATE_IP}" \
--extra-vars "ppdm_setup_password=admin" \
--extra-vars "ppdm_new_password=Change_Me12345_" \
--extra-vars 'ppdm_ntp_server=["129.70.132.36"]'
```


```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/2.0-playbook_set_ddve.yml \
--extra-vars "ppdm_fqdn=https://${PPDM_PRIVATE_IP}" \
--extra-vars "ppdm_new_password=${PPDM_PASSWORD}" \
--extra-vars "ddve_fqdn=${DDVE_PRIVATE_FQDN}" \
--extra-vars "ddve_username=sysadmin" \
--extra-vars "ddve_password=${DDVE_PASSWORD}"
```

```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/3.0-playbook_get_sdr.yml \
--extra-vars "ppdm_fqdn=https://${PPDM_PRIVATE_IP}" \
--extra-vars "ppdm_new_password=${PPDM_PASSWORD}" 
```
Setting 

```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/3.0-playbook_set_sdr.yml \
--extra-vars "ppdm_fqdn=https://${PPDM_PRIVATE_IP}" \
--extra-vars "ppdm_new_password=${PPDM_PASSWORD}"
```


## AKS Stuff
```bash
export K8S_CLUSTER_NAME=$(terraform output -raw AKS_KUBE_NAME)
export K8S_FQDN=$(terraform output -raw AKS_KUBE_FQDN)

terraform output -raw AKS_KUBE_CONFIG > ~/.kube/${K8S_CLUSTER_NAME}_KUBECONFIG
export KUBECONFIG=~/.kube/${KUBE_NAME}_KUBECONFIG


kubectl apply -f https://raw.githubusercontent.com/bottkars/dps-modules/main/ci/templates/ppdm/ppdm-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/bottkars/dps-modules/main/ci/templates/ppdm/ppdm-admin.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/snapshot/storageclass-azuredisk-snapshot.yaml

export PPDM_K8S_TOKEN=$(kubectl get secret "$(kubectl -n kube-system get secret | grep ppdm-admin | awk '{print $1}')" \
-n kube-system --template={{.data.token}} | base64 -d)


ansible-playbook ~/workspace/ansible_dps/ppdm/playbook_add_k8s.yml \
--extra-vars "ppdm_fqdn=https://${PPDM_PRIVATE_IP}" \
--extra-vars "ppdm_new_password=${PPDM_PASSWORD}" 
```





```bash
cd ./templates/wordpress
export PPDM_POLICY=ppdm_gold
export NAMESPACE=wordpress
export WP_PASSWORD=Change_Me12345_
cat <<EOF >./kustomization.yaml
secretGenerator:
- name: mysql-pass
  literals:
  - password=${WP_PASSWORD}
resources:
  - namespace.yaml  
  - mysql-deployment.yaml
  - wordpress-deployment.yaml
EOF

cat <<EOF >./namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: ${NAMESPACE}
  labels: 
    ppdm_policy: ${PPDM_POLICY}
EOF



```