<#
    Author:     FirstName LastName
    GitHub:     https://GitHub.com/Username
    Date:       01.01.2042
    Version:    1.0
    .Synopsis
        short description of the script
    .DESCRIPTION
        long description of the script - what it does, how it works, etc. - optional
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

<#
----------------------------------
Definition of functions
----------------------------------
#>

<#
----------------------------------
Execution of functions
----------------------------------
#>

Stop-Transcript