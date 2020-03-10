Set-StrictMode -Version Latest

$ErrorActionPreference = "stop"

$HyperVOutput = ".\output-hyperv-iso"
$PackerCache = ".\packer_cache\"
$RHELBox = ".\rhel8-hyperv.box"
$RHELKickStart = ".\rhel-ks.iso"

Write-Host -ForegroundColor Green "Deleting files"
if (test-path -path $PackerCache) {
    Remove-Item -Path $PackerCache -Recurse
}

if (Test-Path -Path $HyperVOutput) {
    Remove-Item -Path $HyperVOutput -Recurse
}

if (Test-Path -Path $RHELBox) {
    Remove-item -Path $RHELBox
}

Write-Host -ForegroundColor Green "Calculating hash"
$hash = (Get-FileHash -Path $RHELKickStart -Algorithm MD5).hash
write-host -ForegroundColor Yellow "hash:" $hash

$cmd = ".\packer.exe build -var `'iso_checksum=" + $hash + "`' .\build.json"
Write-Host -ForegroundColor Green "Running Packer"
Invoke-Expression $cmd

Write-Host -ForegroundColor Green "Adding Box"
vagrant box add -name RHEL8 --force $RHELBox

Write-Host -ForegroundColor Green "Deleting files"
if (test-path -path $PackerCache) {
    Remove-Item -Path $PackerCache -Recurse
}

if (Test-Path -Path $HyperVOutput) {
    Remove-Item -Path $HyperVOutput -Recurse
}

if (Test-Path -Path $RHELBox) {
    Remove-item -Path $RHELBox
}