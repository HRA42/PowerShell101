# PowerShell Script Collection
This repository contains a collection of PowerShell scripts for various tasks on Microsoft Windows (Server).

## Scripts
### Filesystem
1. [createNewFolder.ps1](fileSystem/createNewFolder.ps1): This script prompts the user for a folder path and creates a new folder at that location if it doesn't already exist.

### testing PowerShell Scripts
2. [PSScriptAnalyzerScript.ps1](psScriptAnalyzer/PSScriptAnalyzerScript.ps1): This script allows the user to run the PSScriptAnalyzer on a script and settings file. If the script or settings file paths are not provided, the script will prompt the user to enter them.

    2.1 [PSScriptAnalyzerSettings.psd1](psScriptAnalyzer/PSScriptAnalyzerSettings.psd1): This file contains settings for the PSScriptAnalyzer invocation.

### Terminal Server Clients
3. [deactivateUDPforRDP.ps1](terminalServerClient/deactivateUDPforRDP.ps1): This script deactivates UDP for RDP.

### Template for new PowerShell Scripts
4. [template.ps1](template/template.ps1): This is a template for creating new PowerShell scripts.

## Usage
Each script can be run from the PowerShell command line. Some scripts may require additional parameters or user input.