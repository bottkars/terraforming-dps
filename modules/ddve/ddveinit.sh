#!/bin/bash
cat << "EOF" > /var/tmp/boot_deploy.sh
#!/bin/bash
/usr/bin/echo '${DDVE_PASSWORD}' | /usr/bin/passwd sysadmin --stdin
echo "Waiting for Appliance Fresh Install to become ready, this can take up to 10 Minutes"
until [[ 200 == $(curl -k --write-out "%%{http_code}\n" --silent --output /dev/null "https://localhost:3009/rest/v2.0/dd-systems") ]] ; do
    printf '.'
    sleep 5
done

/ddr/bin/ddsh -a adminaccess disable https
/ddr/bin/ddsh -a storage add tier active dev4 dev5
/ddr/bin/ddsh -a filesys create
/ddr/bin/ddsh -a filesys enable
/ddr/bin/ddsh -a ddboost enable
/ddr/bin/ddsh -a net set dns '${DDVE_DOMAIN}'
/ddr/bin/ddsh -a net set hostname '${DDVE_HOSTNAME}'.'${DDVE_DOMAIN}'
/ddr/bin/ddsh -a net set searchdomain '${DDVE_DOMAIN}'
/ddr/bin/ddsh -a user password aging set sysadmin max-days-between-change 99999
/ddr/bin/ddsh -a user password strength set passwords-remembered 0
/ddr/bin/reg_cmd set system.eula_presented true
/ddr/bin/reg_cmd set system.eula_permanent_presented true
/ddr/bin/reg_cmd set config_master.setup.complete_date $(date)
/ddr/bin/reg_cmd set config_master.setup.complete true
/ddr/bin/reg_cmd set config_master.setup.displayed true
/usr/bin/echo '${DDVE_PASSWORD}'  | /usr/bin/passwd sysadmin --stdin
/ddr/bin/ddsh -a adminaccess enable https
EOF

chmod +X /var/tmp/boot_deploy.sh
chmod 755 /var/tmp/boot_deploy.sh
nohup /var/tmp/boot_deploy.sh >/dev/null 2>&1 &

