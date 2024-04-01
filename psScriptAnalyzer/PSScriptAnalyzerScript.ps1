<#
    Author:     Henry Rausch
    GitHub:     https://GitHub.com/HRA42
    Date:       01.04.2024
    Version:    1.0
    .Synopsis
        Allow the user to run the PSScriptAnalyzer on a script and settings file
#>
param(
    [Parameter(Mandatory=$false)]
    [string]$scriptPath,

    [Parameter(Mandatory=$false)]
    [string]$settingsPath
)

# If the folder C:\TEMP does not exist, it must be created
$tempFolder = "C:\tmp\"
If (!(Test-Path $tempFolder)) {
    Write-Output "The folder $tempFolder does not exist. It will be created."
    New-Item -ItemType Directory -Path $tempFolder
}

$currentScript = ($MyInvocation.MyCommand.Name) -replace ".ps1", ""
Start-Transcript "$tempFolder\$(Split-Path -Leaf $currentScript).log"

# If the scriptPath or settingsPath are not provided, prompt the user to enter them
if (-not $scriptPath) {
    $scriptPath = Read-Host "Enter the path to the script you want to analyze"
} else {
    Write-Output "The script path is $scriptPath"
}

if (-not $settingsPath) {
    $settingsPath = Read-Host "Enter the path to the settings file you want to use"
} else {
    Write-Output "The settings path is $settingsPath"
}

# Invoke the PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path $scriptPath -Settings $settingsPath

Stop-Transcript