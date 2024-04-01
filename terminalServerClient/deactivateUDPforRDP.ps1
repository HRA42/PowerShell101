<#
    Author:     Henry Rausch
    GitHub:     https://GitHub.com/HRA42
    Date:       01.04.2024
    Version:    1.0
    .Synopsis
        This script deactivates the UDP protocol for RDP sessions
#>

# If the folder C:\TEMP does not exist, it must be created
$tempFolder = "C:\tmp\"
If (!(Test-Path $tempFolder)) {
    Write-Output "The folder $tempFolder does not exist. It will be created."
    New-Item -ItemType Directory -Path $tempFolder
}

$currentScript = ($MyInvocation.MyCommand.Name) -replace ".ps1", ""
Start-Transcript "$tempFolder\$(Split-Path -Leaf $currentScript).log"

<#
----------------------------------
Definition of variables
----------------------------------
#>
# Read the current status of the UDP protocol for RDP sessions
$status = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" -Name "fClientDisableUDP" -ErrorAction SilentlyContinue


<#
----------------------------------
Definition of functions
----------------------------------
#>
function isActivated() {
    if (!$status) {
        Write-Output "The UDP protocol for RDP sessions is activated."
        return $true
    } else {
        Write-Output "The UDP protocol for RDP sessions is deactivated - nothing to do."
        return $false
    }
}

function deactivateUDP() {
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" -Name "fClientDisableUDP" -Value 1 -PropertyType DWORD -Force
    Write-Output "The UDP protocol for RDP sessions has been deactivated."
}

<#
----------------------------------
Execution of functions
----------------------------------
#>
if (isActivated) {
    deactivateUDP
}

Stop-Transcript