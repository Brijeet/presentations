# stop IIS
iisreset /stop
net stop apphostsvc
 
# copy to F drive
robocopy C:\\inetpub F:\\inetpub /MOVE /S /E /COPYALL /R:0 /W:0
 
# Move default IIS site to F drive & Change Registry/Config
Import-Module WebAdministration
Set-ItemProperty "IIS:\Sites\Default Web Site" -name physicalPath -value "F:\inetpub\wwwroot"
$NewPath = "F:\inetpub"
$OldPath = "%SystemDrive%\inetpub"
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\InetStp" -Name "PathWWWRoot" -Value $NewPath"\wwwroot" -PropertyType ExpandString -Force
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\WAS\Parameters" -Name "ConfigIsolationPath" -Value $NewPath"\temp\appPools" -PropertyType String -Force
      New-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\InetStp" -Name "PathWWWRoot" -Value $NewPath"\wwwroot" -PropertyType ExpandString -Force
      copy-item C:\Windows\System32\inetsrv\config\applicationHost.config C:\Windows\System32\inetsrv\config\applicationHost.config.bak
      (Get-Content C:\Windows\System32\inetsrv\config\applicationHost.config).replace("$OldPath","$NewPath") | Set-Content C:\Windows\System32\inetsrv\config\applicationHost.config
      $UpdateConfig = &C:\Windows\system32\inetsrv\appcmd set config -section:system.applicationhost/configHistory -path:$NewPath\history
 
# Set NTFS permissions for IIS_IUSRS
Write-Host "Setting permissions..."
$acl = Get-Acl $NewPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS","Modify","ContainerInherit,ObjectInherit","None","Allow")
$acl.AddAccessRule($rule)
Set-Acl $NewPath $acl
Write-Host "Permissions applied for IIS_IUSRS."
 
# Cleanup old inetpub directory
# Remove-Item -Path "c:\inetpub" -force
 

# start IIS
iisreset /start
