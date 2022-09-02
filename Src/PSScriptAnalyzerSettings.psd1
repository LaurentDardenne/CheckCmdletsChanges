#PSScriptAnalyzerSettings.psd1
# Settings for PSScriptAnalyzer invocation.
@{
    Rules = @{
        PSUseCompatibleCommands = @{
            # Turns the rule on
            Enable = $true

            # Lists the PowerShell platforms we want to check compatibility with
            TargetProfiles = @(
                #  #7.0	Windows Server 2016
                # 'win-8_x64_10.0.14393.0_7.0.0_x64_3.1.2_core',
                #  #7.0	Windows Server 2019
                # 'win-8_x64_10.0.17763.0_7.0.0_x64_3.1.2_core',
                 #7.0	Windows 10 1809 (RS5)
                'win-4_x64_10.0.18362.0_7.0.0_x64_3.1.2_core.json'
            )
        }
        PSUseCompatibleSyntax = @{
            # This turns the rule on (setting it to false will turn it off)
            Enable = $true

            # Simply list the targeted versions of PowerShell here
            TargetVersions = @(
                '7.0'
            )
        }
    }
}