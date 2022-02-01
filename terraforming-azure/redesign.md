## Configuration
Configuration Sections are Provided for Each VM Type

## Configuring Avamar Virtual Edition Software using AVI API

### lets export all Upper Case Keys:
```bash
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^[A-Z]+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
export AVE_TIMEZONE="Europe/Berlin"
```
### Run the AVI Configuration Playbook
```
ansible-playbook ~/workspace/ansible_dps/avi/playbook-postdeploy_AVE.yml
```
### Configure DataDomain Backend ona  AVE using Avamar api via ansible
export variables from Terraform ...
```bash
export AVA_FQDN=$(terraform output -raw AVE_PRIVATE_IP)
export AVA_HFS_ADDR=$(terraform output -raw AVE_PRIVATE_IP)
ansible-playbook ~/workspace/ansible_dps/ava/playbook_add_datadomain.yml \
--extra-vars "ava_password=${AVE_PASSWORD}" \
--extra-vars "ava_username=root" \
--extra-vars "ava_dd_host=${DDVE_PUBLIC_FQDN}" \
--extra-vars "ava_dd_boost_user_pwd=${DDVE_PASSWORD}"
```
check deployment:
```bash
ansible-playbook ~/workspace/ansible_dps/ava/playbook_get_datadomain.yml \
--extra-vars "ava_username=root" \
--extra-vars "ava_password=${AVE_PASSWORD}"
```
## Configuring Networker Virtual Edition Software using AVI API

### lets export all Upper Case Keys:
```bash
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^[A-Z]+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
export NVE_TIMEZONE="Europe/Berlin"
```
### Run the AVI Configuration Playbook
```
ansible-playbook ~/workspace/ansible_dps/avi/playbook-postdeploy_NVE.yml
```

## Configure DataDomain  ( can be use3d with any of AVE, NVE, PPDM)
the next lines will evaluate the (uppercase) output of terraform to Uppercase Environment Variables used by my ansible playbooks:

```bash
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^[A-Z]+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
export DDVE_USERNAME=sysadmin
export DDVE_INITIAL_PASSWORD=changeme
export PPDD_PASSPHRASE=Change_Me12345_!
export PPDD_LICENSE=$(cat ~/workspace/ansible_dps/ppdd/internal.lic) 
export PPDD_TIMEZONE="Europe/Berlin"
```

now we are setting up the Datadomain

```bash
ansible-playbook ~/workspace/ansible_dps/ppdd/1.0-Playbook-configure-initial-password.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/3.0-Playbook-set-dd-license.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/2.1-Playbook-configure-ddpassphrase.yml
ansible-playbook ~/workspace/ansible_dps/ppdd/2.2-Playbook-configure-dd-block.yml
```

specific to azure we configure the hostname to reflect te correct  
```bash
ansible-playbook ~/workspace/ansible_dps/ppdd/3.1-Playbook-set-dd-networks.yml \
--extra-vars "ppdd_hostname=${DDVE_PRIVATE_FQDN}" \
--extra-vars "ppdd_dns_1=168.63.129.16"  # < set your DNS Server here, this is internal Azure DNS
```

if you want to connect an avamar system to dd you can prepare a boost user for avamar:

```bash
export AVAMAR_DDBOOST_USER=ddboostave
ansible-playbook ../../ansible_dps/ppdd/3.2-Playbook-set-boost_avamar.yml \
--extra-vars "ppdd_password=${DDVE_PASSWORD}" \
--extra-vars "ava_dd_boost_user=${AVAMAR_DDBOOST_USER}"
```

## Configure PowerProtect DataManager

Similar to the DDVE Configuration, we will set Environmant Variables for Ansible to Automatically Configure PPDM

```bash
# Refresh you Environment Variables if Multi Step !
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^[A-Z]+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"
export PPDM_INITIAL_PASSWORD=Change_Me12345_
export PPDM_NTP_SERVERS='["129.70.132.36"]'
export PPDM_SETUP_PASSWORD=admin          # default password on the Azure PPDM
```


Set the initial Configuration:    
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/1.0-playbook_configure_ppdm.yml

```

we add the DataDomain:  

```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/2.0-playbook_set_ddve.yml 
```

We get the Current ( empty ) Server Disaster Recovery Configuration
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/3.0-playbook_get_sdr.yml
```

Next, we will set the PPDM SDR Component to write to DD using DDBoost
```bash
ansible-playbook ~/workspace/ansible_dps/ppdm/3.0-playbook_set_sdr.yml
```


## AKS Stuff
```bash
# Refresh you Environment Variables if Multi Step !
eval "$(terraform output --json | jq -r 'with_entries(select(.key|test("^[A-Z]+"))) | keys[] as $key | "export \($key)=\"\(.[$key].value)\""')"


echo $AKS_KUBE_CONFIG > ~/.kube/${K8S_CLUSTER_NAME}_KUBECONFIG
export KUBECONFIG=~/.kube/${K8S_CLUSTER_NAME}_KUBECONFIG


kubectl apply -f https://raw.githubusercontent.com/bottkars/dps-modules/main/ci/templates/ppdm/ppdm-rbac.yml
kubectl apply -f https://raw.githubusercontent.com/bottkars/dps-modules/main/ci/templates/ppdm/ppdm-admin.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/snapshot/storageclass-azuredisk-snapshot.yaml

export PPDM_K8S_TOKEN=$(kubectl get secret "$(kubectl -n kube-system get secret | grep ppdm-admin | awk '{print $1}')" \
-n kube-system --template={{.data.token}} | base64 -d)


ansible-playbook ~/workspace/ansible_dps/ppdm/playbook_add_k8s.yml 
```

```bash
cd ./templates/wordpress
export PPDM_POLICY=PPDM_GOLD
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

kubectl apply -k ./ --namespace ${NAMESPACE}

```

