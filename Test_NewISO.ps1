<#
Use this script to create a new vm using the new .iso.  The script does not
power on the vm.  This way you can connect to the console in Hyper-V, power on
the vm and watch the boot process :)
#>
Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"

$VMSettings = @{
    Name               = "TestRHEL-ISO"
    MemoryStartupBytes = 2GB
    NewVHDPath         = ".\RHEL_Hyperv\VirtualHardDisk\HDD01.vhdx"
    NewVHDSizeBytes    = 60GB
    SwitchName         = "Default Switch"
    path               = ".\RHEL_HyperV"
}

if (test-path -Path $VMSettings.NewVHDPath) {
    remove-item -Path $VMSettings.NewVHDPath -Force
}

$vm = New-VM @VMSettings

# Load the dvd drive with the RedHat Kickstart image
Set-VMDvdDrive -VMName $VMSettings.Name -Path ".\rhel-ks.iso"

# Turn off the automatic Checkpoints, annoying me when I restart the vm :)
Set-VM -Name $VMSettings.Name -AutomaticCheckpointsEnabled $false

# Turn on the Guest Service Interface.  It's disabled by default
$vm | Enable-VMIntegrationService -name "Guest Service Interface"
