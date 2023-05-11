#!/bin/bash
set -u
BACKUP_JOB=$1
NEW_NS=$2
BACKUP_CONTENT=$(kubectl get backupjobs/"${BACKUP_JOB}" -n powerprotect -o json)
CREDENTIALID=$(echo "${BACKUP_CONTENT}" | jq  .metadata.annotations.storageUnit)
ASSET=$(echo "${BACKUP_CONTENT}" | jq -r .metadata.annotations.asset)
RESTORE_JOB="restore-${ASSET}-$(date +"%Y-%m-%d-%H-%M-%S")"
cat << EOF | kubectl apply -f -
apiVersion: "powerprotect.dell.com/v1beta1"
kind: RestoreJob
metadata:
  name: ${RESTORE_JOB} 
  namespace: powerprotect
spec:
  recoverType: RestoreToNew #Default is RestoreToOriginal 
  backupJobName: ${BACKUP_JOB} # For e.g. testapp1-2019-11-16-14-15-47 
  namespaces:
  - name: ${ASSET}
    alternateNamespace: ${NEW_NS} # Name for the     
    persistentVolumeClaims:
    - name: "*" #volumes to be recovered. By default all volumes backed up 
EOF

kubectl get restorejob "${RESTORE_JOB}" -n powerprotect -o yaml -w