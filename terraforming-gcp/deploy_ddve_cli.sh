PROJECT=$TF_VAR_gcp_project
ZONE=$TF_VAR_gcp_zone
INSTANCENAME=$TF_VAR_DDVE_HOSTNAME

gcloud compute instances create ${INSTANCENAME} \
    --project=${PROJECT} \
    --zone=${ZONE} \
    --machine-type=e2-standard-4 \
    --network-interface=stack-type=IPV4_ONLY,subnet=default,no-address \
    --metadata=^,@^ATTACHED_DISKS=${INSTANCENAME}-1-nvram,${INSTANCENAME}-metadata-1,${INSTANCENAME}-metadata-2 \
    --provisioning-model=STANDARD \
    --tags=${INSTANCENAME}-1-deployment \
    --create-disk=auto-delete=yes,boot=yes,device-name=${INSTANCENAME}-1-boot-disk,image=projects/dellemc-ddve-public/global/images/ddve-gcp-7-11-0-0-1035502,mode=rw,size=250,type=projects/${PROJECT}/zones/${ZONE}/diskTypes/pd-ssd \
    --create-disk=device-name=${INSTANCENAME}-nvram,mode=rw,name=${INSTANCENAME}-nvram,size=10,type=projects/${PROJECT}/zones/${ZONE}/diskTypes/pd-ssd \
    --create-disk=device-name=${INSTANCENAME}-metadata-1,mode=rw,name=${INSTANCENAME}-metadata-1,size=1000,type=projects/${PROJECT}/zones/${ZONE}/diskTypes/pd-balanced \
    --create-disk=device-name=${INSTANCENAME}-metadata-2,mode=rw,name=${INSTANCENAME}-metadata-2,size=1000,type=projects/${PROJECT}/zones/${ZONE}/diskTypes/pd-balanced \
    --labels=goog-dm=${INSTANCENAME}-1,ec-src=vm_add-gcloud \
    --reservation-affinity=any