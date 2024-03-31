<#
    Author:     Henry Rausch
    GitHub:     https://GitHub.com/HRA42
    Date:       31.03.2024
    Version:    1.0
    .Synopsis
        Create a folder if it does not exist.
#>

# If the folder C:\TEMP does not exist, it must be created
$tempFolder = "C:\tmp"
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
$folderPath = Read-Host "Enter the path of the folder to be created and the name of the folder"

<#
----------------------------------
Definition of functions
----------------------------------
#>
function New-Folder {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    if ($PSCmdlet.ShouldProcess($Path, 'Create new folder')) {
        If (!(Test-Path $Path)) {
            Write-Output "The folder $Path does not exist. It will be created."
            New-Item -ItemType Directory -Path $Path
        } else {
            Write-Output "The folder $Path already exists."
        }
    }
}

<#
----------------------------------
Execution of functions
----------------------------------
#>
New-Folder -Path $folderPath

Stop-Transcript