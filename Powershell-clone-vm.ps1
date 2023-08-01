#
## PowerCLI to create VMs
## Version 1.0 12/20/2020
## Tom Fenton
##
#
# Specify vCenter Server, vCenter Server username and vCenter Server user password
$vCenter=”IP or DOMAIN NAME"
$vCenterUser=”username@domain.net"
$vCenterUserPassword=”passwd”
#
# Specify number of VMs you want to create
$vm_count = “9000”
#
# Specify the VM you want to clone
$clone = “cl106308-vm000000-WinStd2019_x64-01”
#
# Specify the Customization Specification to use
# TJF $customspecification=”Win10-customization”
#
# Specify the datastore or datastore cluster placement
$ds = “NL-SAS”
#
# Specify vCenter Server Virtual Machine & Templates folder
$Folder = “Clients”
#
# Specify the vSphere Cluster
$Cluster = “Huawei-X6800”
#
# Specify the prefix for the VMs
$VM_prefix = “cl106308-vm000000-WinStd2019_x64-1”
#
# End of user input parameters
#_______________________________________________________
#
write-host “Connecting to vCenter Server $vCenter” -foreground green
Connect-viserver $vCenter -user $vCenterUser -password $vCenterUserPassword -WarningAction 0
1..$vm_count | foreach {
     $y=”{0:D1}” -f + $_
     $VM_name= $VM_prefix + $y
     $ESXi=Get-Cluster $Cluster | Get-VMHost -state connected | Get-Random
     write-host “Creation of VM $VM_name initiated” -foreground green
     New-VM -Name $VM_Name -VM $clone -VMHost $ESXi -Datastore $ds -Location $Folder -RunAsync

# Uncomment the line below and comment the line above if a cust spec is used.

# New-VM -Name $VM_Name -VM $clone -VMHost $ESXi -Datastore $ds -Location $Folder –       OSCustomizationSpec $customspecification -RunAsync

 

   ## the power function needs a little work as the clones may not be fully created before the power on is attempted.

##   write-host “Power On of the VM $VM_name initiated” -foreground green
##   Start-VM -VM $VM_name -confirm:$false -RunAsync
}
