<#
    Author:     Henry Rausch
    GitHub:     https://GitHub.com/hra42
    Date:       21.04.2024
    Version:    1.0
    .Synopsis
        Upgrade Datev Sicherheitspaket Compact to the latest available version.
    .Description
        This script downloads the latest version of the Datev Sicherheitspaket Compact from the Datev website and installs it.
        Available command line parameters:
        /install:       Installs the software normally
        /repair:         Repairs the software (if already installed)
        /uninstall:     Uninstalls the software
        /passive:       Installs the software in passive mode (no user interaction but visible progress bar)
        /quiet:         Installs the software in the background (no user interaction and no visible progress bar)
        /norestart:     Prevents the system from restarting after installation
        /log log.txt:   Creates a log file in the same folder as the script
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
$downloadURL = "https://download.datev.de/download/sipacompact/sipacompact.exe"
$checkSum = "266C6A4DD810B05768A9DE9601E5210C160A93026D172C5731BCDDBF9DCE0D12"
$scriptParameters = "/install /quiet /norestart /log $tempFolder\$(Split-Path -Leaf $currentScript).datev.log"

<#
----------------------------------
Definition of functions
----------------------------------
#>
function downloadInstaller() {
    Write-Output "Downloading the latest version of the Datev Sicherheitspaket Compact from $downloadURL"
    $ProgressPreference = "SilentlyContinue"
    try {
        Invoke-WebRequest -Uri $downloadURL -OutFile "$tempFolder\sipacompact.exe"
    } catch {
        # Display error message and exit
        Write-Output "An error occurred while downloading the installer!"
        Write-Output "Status Code: $_.Exception.Response.StatusCode.value__"
        Write-Output "Status Description: $_.Exception.Response.StatusDescription"
        # Read the response body
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd()
        Write-Output "Response body: $responseBody"
        Exit 1
    } finally {
        $ProgressPreference = "Continue"
    }
}

function validateChecksum() {
    Write-Output "Validating the checksum of the downloaded installer"
    $hash = Get-FileHash "$tempFolder\sipacompact.exe" -Algorithm SHA256
    if ($hash.Hash -ne $checkSum) {
        # Display error message and exit
        Write-Output "The checksum of the downloaded installer does not match the expected value!"
        Write-Output "Expected checksum: $checkSum"
        Write-Output "Actual checksum: $($hash.Hash)"
        Exit 1
    } else {
        Write-Output "The checksum $hash of the downloaded installer is valid"
    }
}

function installSoftware() {
    Write-Output "Installing the Datev Sicherheitspaket Compact"
    try {
        Start-Process "$tempFolder\sipacompact.exe" -ArgumentList $scriptParameters -Wait
        Write-Output "The Datev Sicherheitspaket Compact has been successfully installed!"
    } catch {
        # Display error message and exit
        Write-Output "An error occurred while installing the Datev Sicherheitspaket Compact!"
        Write-Output "Error code: $LASTEXITCODE"
        Exit 1
    }
}

<#
----------------------------------
Execution of functions
----------------------------------
#>
downloadInstaller
validateChecksum
installSoftware

Stop-Transcript