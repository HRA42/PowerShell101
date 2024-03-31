# Test for compatibility with PowerShell 5.1 and Windows Server 2016, 2010 and Windows 10

$scriptPath = Read-Host "Enter the path to the script inlcuding the script name"

Invoke-ScriptAnalyzer -Path $scriptPath -Settings .\Tests\PSScriptAnalyzerSettings.psd1