# PSScriptAnalyzerSettings.psd1
# Settings for PSScriptAnalyzer invocation.
@{  
    Rules = @{
        PSUseCompatibleSyntax = @{
            Enable = $true
            TargetVersions = @('5.1')
            Serverity = 'Error'
        }
        PSUseCompatibleCommands = @{
            Enable = $true
            TargetProfiles = @(
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework',   # Windows Server 2016 - PowerShell 5.1
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',    # Windows Server 2019 - PowerShell 5.1
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework'    # Windows 10 - PowerShell 5.1
            )
            Serverity = 'Error'
        }
    }
}
