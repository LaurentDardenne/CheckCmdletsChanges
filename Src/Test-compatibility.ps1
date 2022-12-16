# cd  C:\Users\1801106\Documents\Projets\CheckCmdletsChanges\Src
#Invoke-ScriptAnalyzer -Path .\Test-compatibility.ps1 -Settings ./PSScriptAnalyzerSettings.psd1
Add-PSSnapIn -Name Microsoft.Exchange, Microsoft.Windows.AD
Get-EventLog -LogName System -Newest 5