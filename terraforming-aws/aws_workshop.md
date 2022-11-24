### jump on bastion
install latest powershell get
```powershell
install-module powershellget -force
```
### re open powershell
```powershell
install-module ppdd-pwsh -AllowPrerelease
```


### connect to dd with sysadmin and instance id terraform output ddve_instance_id
```powershell
$DD_IP=""
$PPDM_IP=""
Get-DDtoken -trustCert -DD_BaseURI $DD_IP -force
Connect-DDapiEndpoint -force -trustCert -DD_BaseURI $DD_IP
```
### new password
```powershell
$NewPassword = ("Change_Me12345_" | ConvertTo-SecureString -AsPlainText -force)
Get-DDUsers -id sysadmin | Set-DDUserPassword -NewPassword $NewPassword 
```
### set passphrase
```Powershell
$NewPassphrase = ("Change_Me12345_#" | ConvertTo-SecureString -AsPlainText -force)
Set-DDSystems -set_pphrase -NewPassphrase $NewPassphrase
```
### Create Security Officer
```powershell
New-DDUser -Name security_officer -UserRole security -password $NewPassphrase
```

### time zone
```powershell
[string]$myTZ=(Get-DDSettings).supported_time_zones -match "Berlin"
Set-DDSettings -timezone $myTZ
Set-DDSettings -admin_email Karsten.Bott@dell.com
Set-DDntpservice -servers 169.254.169.123  -add
Set-DDntpservice -enable
```


### get current atos info
```powershell
Get-DDAtos
Get-DDAtos -provider aws
```
### apply ATos from  terraform output atos_bucket
```powershell
$disk=(Get-DDDisks -body @{filter = "status=UNKNOWN and tierType=OTHER" }).device
Set-DDFileSystemsObjectStorage -devices $disk -bucket #your bucket here
```

```powershell
Get-DDAtos
```

```powershell
Set-DDFileSystems -create
Set-DDFileSystems -enable
```

### enable boost
```powershell
Set-DDboostservice -enable
```

## Configure PPDM
### connect with admin / admin
```powershell
Connect-PPDMapiEndpoint  -trustCert -force  -PPDM_API_URI $PPDM_IP
```

```powershell
Approve-PPDMEula
$timezone=(Get-PPDMTimezones | Where-Object id -match Berlin).id
$SecurePassword = Read-Host -Prompt "Enter new Password for user 'admin'" -AsSecureString
Set-PPDMconfigurations -NTPservers 169.254.169.123 -Timezone $timezone -admin_Password $SecurePassword
Get-PPDMconfigurations | Get-PPDMconfigstatus
```


### add the DataDomain
```powershell
Get-PPDMcertificates -newhost $DD_IP -Port 3009 | Approve-PPDMcertificates
$creds=New-PPDMcredentials -name sysadmin -type DATADOMAIN
$creds | Add-PPDMinventory_sources -Hostname $DD_IP -Type EXTERNALDATADOMAIN -Name $DD_IP -port 3009 
```