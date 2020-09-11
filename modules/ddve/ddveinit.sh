#!/bin/bash
cat << "EOF" > /var/tmp/boot_deploy.sh
#!/bin/bash
/usr/bin/echo '${DDVE_PASSWORD}' | /usr/bin/passwd sysadmin --stdin
echo "Waiting for Appliance Fresh Install to become ready, this can take up to 10 Minutes"
until [[ 200 == $(curl -k --write-out "%%{http_code}\n" --silent --output /dev/null "https://localhost:3009/rest/v2.0/dd-systems") ]] ; do
    printf '.'
    sleep 5
done

cp -Rv /ddr/var/home/sysadmin/ /var/tmp
rm -rf /ddr/var/home/sysadmin/EULA_80.txt
/ddr/bin/ddsh -a storage add tier active dev4 dev5
/ddr/bin/ddsh -a filesys create
/ddr/bin/ddsh -a filesys enable
/ddr/bin/ddsh -a ddboost enable
/ddr/bin/ddsh -a adminaccess enable https
EOF

chmod +X /var/tmp/boot_deploy.sh
chmod 755 /var/tmp/boot_deploy.sh
nohup /var/tmp/boot_deploy.sh >/dev/null 2>&1 &
