# Expand F: drive to use full size of the disk
# Run this inside the VM or via Custom Script Extension

# Get the maximum size available for the partition
$size = (Get-PartitionSupportedSize -DriveLetter 'F')

# Resize the partition to the maximum size
Resize-Partition -DriveLetter 'F' -Size $size.SizeMax

Write-Host "F: drive has been expanded to full size of the provisioned disk."

# Install IIS

Install-WindowsFeature -Name Web-Server -IncludeManagementTools

Write-Host "IIS has been installed on the VM."
