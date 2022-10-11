## jump on bastion
install latest powershell get
```powershell
install-module powershellget -force
```
## re open powershell
```powershell
install-module ppdd-pwsh -AllowPrerelease
```


# connect to dd with sysadmin and instance id terraform output ddve_instance_id
```powershell
Get-DDtoken -trustCert -DD_BaseURI 10.31.11.203 -force
Connect-DDapiEndpoint -force -trustCert -DD_BaseURI 10.31.11.143
```
## new password
```powershell
$NewPassword = ("Change_Me12345_" | ConvertTo-SecureString -AsPlainText -force)
Get-DDUsers -id sysadmin | Set-DDUserPassword -NewPassword $NewPassword 
```
## set passphrase
```Powershell
$NewPassphrase = ("Change_Me12345_#" | ConvertTo-SecureString -AsPlainText -force)
Set-DDSystems -set_pphrase -NewPassphrase $NewPassphrase
```
## get current atos info
```powershell
Get-DDAtos
Get-DDAtos -provider aws
```
# terraform output atos_bucket
```powershell
$disk=(Get-DDDisks -body @{filter = "status=UNKNOWN and tierType=OTHER" }).device
Set-DDFileSystemsObjectStorage -devices $disk -bucket dps-kb-atos-bucket-86935
Get-DDAtos
Set-DDFileSystems -create
Set-DDFileSystems -enable
```