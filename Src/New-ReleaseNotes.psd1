
api public (signature)
https://github.com/ltrzesniewski/dotnet-runtime/blob/master/docs/coding-guidelines/breaking-change-rules.md


voir https://devblogs.microsoft.com/powershell/using-psscriptanalyzer-to-check-powershell-version-compatibility/


 Get-ASTCommand : retrouve toutes les commandes et filtre celles que l'on recherche, sinon chaque recherche de noeud AST va tous les tester.
On peut vouloir tout récupérer et faire produit par produit si un script utilise 2 ou + produits (SCCM et Teams par exemple).
recherche de paramètre, dépend de l'écriture, ex splatting

    [System.Management.Automation.Language.StaticParameterBinder]::BindCommand
    cf module MeasureLocalizedData
	https://github.com/LaurentDardenne/MeasureLocalizedData/blob/master/MeasureLocalizedData.psm1

    voir la doc du change pour PS v7 : https://github.com/PowerShell/PowerShell/blob/master/docs/dev-process/breaking-change-contract.md
    https://github.com/PowerShell/PowerShell/issues?q=is%3Aopen+is%3Aissue+label%3ABreaking-Change
    pour un produit que des cmdlets, le plus souvent, pour PS le langage, variable auto et divers comportement


    '2111',2103,1802,1806,1710 ( remplacement)
     tous fait ici (https://docs.microsoft.com/en-us/powershell/sccm/2103-release-notes?view=sccm-ps)

2103
     -don't support PowerShell version 7
         Import-CMPackage
         Import-CMDriverPackage
         Import-CMTaskSequence
         Export-CMPackage
         Export-CMDriverPackage
         Export-CMTaskSequence

         change: cmdlets now support the Fast parameter.
            Get-CMAlert
        On a une liste de cmdlet pour un paramètre


    Cmdlet changes
    New-CMTSRule - Add parameterValue: ReferencedVariableOperator = NotLike.

    Set-CMCertificateProfileScep - Fix bug for parameter SanType.

    Set-CMFallbackStatusPoint - Fixed an inconsistent parameter name. INCONNU !!

    Set-CMThirdPartyUpdateCategory - bug de valeur de parametre PublishOption= FullContent.

    Set-CMSoftwareUpdateAutoDeploymentRule - Fix bug, changes : You now need to specify a language with a country name.
                                          O365LanguageSelection="English (United States)"


    Add-CMFallbackStatusPoint- Fixed an inconsistent parameter name.  INCONNU !!

    Add-CMSoftwareUpdatePoint - Added new parameter Wledbat

    New-CMTaskSequenceDeployment (plus précis dans la recherche d'impact : ici on précise que le param d'un cmdlet à changé)
        Bugs fixed an issue with the AllowSharedContent parameter


    New-CMTSPartitionSetting changes  - AssignVolumeLetter=Set default value

    Set-CMDeviceVariable changes-  'VariableName'= is now case-insensitive

    New-CMTSStepApplyWindowsSetting Breaking changes: Removed unsupported parameters: MaximumConnection,ServerLicensing


!!!!!! Set-CMSoftwareUpdatePointComponent (TODO recherché dans les précédentes notes si EnableSynchronization est indiqué deprecated) la 1702 référence
        Breaking changes
        Removed the deprecated parameter EnableSynchronization from this cmdlet. To set the synchronization schedule, use the Schedule parameter.

    New-CMCloudManagementGateway
        Breaking changes
        The ServiceCertPassword parameter is now required.

    New-CMSoftwareUpdateDeployment
        Non-breaking changes
        Added Description alias to Comment parameter.

    New-CMTaskSequence
        Non-breaking changes
            Extended the maximum length of the Description parameter to 512 characters.
            Added new parameter HighPerformance to support performance setting.
            The legacy InstallationLicensingMode parameter was removed.
            Removed the NewInstallOSImageVhd parameter set.
            Removed the InstallOperatingSystemImageVhd parameter.

    New-CMTSStepApplyOperatingSystem
        Bugs that were fixed
            Fixed validation issues with the DestinationVariable parameter to allow values that start with an underscore (_).

    Set-CMMsiDeploymentType (2 infos de param ?)
        Bugs that were fixed
            Update the deployment type according to the installer type to avoid resetting the configurations when you change the content location.
        Non-breaking changes
            Add support for specifying a folder path to the ContentLocation parameter.

***********
Changes to multiple cmdlets

The following changes were made across multiple cmdlets of a similar type.
Import and export verbs

This change applies to all cmdlets with import and export verbs. For example, Import-CMAADClientApplication and Export-CMApplication.

Non-breaking changes

To allow for consistent parameter use across these cmdlets, they all have aliases for the parameter to specify the import path: FilePath, FileName, ImportFilePath, Path
Configure application deployment types

This change applies to all cmdlets with set verbs to configure application deployment types. These cmdlet names use the pattern Set-CM*DeploymentType, where * is the application technology. For example, Set-CMMsiDeploymentType.

Bugs that were fixed

Fixed a requirement rule name issue with these cmdlets.
Create requirement rules

This change applies to all cmdlets with the name pattern New-CMRequirementRule*, where * is the type of rule. For example, New-CMRequirementRuleExistential.

Bugs that were fixed

Fixed a requirement rule name issue with these cmdlets.
***************

---------
TEAMS :
https://docs.microsoft.com/en-us/microsoftteams/teams-powershell-release-notes
https://docs.microsoft.com/en-us/microsoftteams/teams-powershell-supported-versions
Deperacted dans une liste mais pas dans l'autre, why ?

Message center post for reference
https://docs.microsoft.com/en-us/microsoft-365/admin/manage/message-center?view=o365-worldwide

---------
L'ancienne structure permet de recherche des string dans le code C#.
    On recherche un mot clé/AST et on rapporte la raison de sa présence dans le résultat
On change le comportement d'un cmdlet en modifiant ou non sa signature ( qui détaille la raison)

une structure stable mais on ajoute des valeurs d'enumération :
Cmdlet=Catégorie de Changement (Peut être présent trois fois, un ajout et deux fois pour un paramètre existant avec break et un sans break, c'est l'usage du paramètre qui indique si c'est un Breaking Change)

(si certains paramètre deviennent obligatoire doivent peut devenir optionnel)
param=Delete,Add,Rename,Deprecated,TypeChange,DefaultValue,ChangeValue,Position,Mandatory,Optionnal,BugFix,RemoveParameterSet.
Attribut

Préconiser d'utiliser une assertion pour vérifier certains bug

#folder product\PSversion\R.Notes
    Produit='SCCM'
    PowershellVersion='5.1'
        #Cmdlet
        Name=@{ParameterName='raison de la présence? type de change '

    LibraryChangesForVersion='2107'

    Url='https://docs.microsoft.com/en-us/powershell/sccm/2107-release-notes?view=sccm-ps'

}


$tags=gh api  -H "Accept: application/vnd.github+json" /repos/PowerShell/PowerShell/tags --paginate --jq '.[] |."name"'
$R=$tags |Where-object {$_ -match '^v'}
$List=$r|% { gh api -H "Accept: application/vnd.github+json" /repos/PowerShell/PowerShell/releases/tags/$_}|convertfrom-json
$Notes=$List|Select-object tag_name,name,draft,prerelease,created_at,body

v6.0.0-beta.1

### Telemetry

If you want to opt-out of this telemetry, simply delete
`$PSHome\DELETE_ME_TO_DISABLE_CONSOLEHOST_TELEMETRY`. Even before the first run of Powershell, deleting
this file will bypass all telemetry. In the future, we plan on also enabling a configuration value for
whatever is approved as part of [RFC0015](https://github.com/PowerShell/PowerShell-RFC/blob/master/1-Draft
/RFC0015-PowerShell-StartupConfig.md). We also plan on exposing this telemetry data (as well as whatever
insights we leverage from the telemetry) in [our community dashboard](https://blogs.msdn.microsoft.com/pow
ershell/2017/01/31/powershell-open-source-community-dashboard/).

Add the `OS` entry to `$PSVersionTable`. (#3654)
Arrange the display of `$PSVersionTable` entries in the following way: (#3562) (Thanks to @iSazonov!)

Fix code in PowerShell to use `IntPtr(-1)` for `INVALID_HANDLE_VALUE` instead of `IntPtr.Zero`. (#3544) (Thanks to @0xfeeddeadbeef)

Change the default encoding and OEM encoding used in PowerShell Core to be compatible with Windows PowerShell. (#3467) (Thanks to @iSazonov!)
Fix a bug in `Import-Module` to avoid incorrect cyclic dependency detection. (#3594)
Fix `New-ModuleManifest` to correctly check if a URI string is well formed. (#3631)

Fix `New-Item` to allow creating symbolic links to file/directory targets and even a non-existent target. (#3509)
Change the behavior of `Remove-Item` on a symbolic link to only removing the link itself. (#3637)
Use better error message when `New-Item` fails to create a symbolic link because the specified link path points to an existing item. (#3703)
Change `Get-ChildItem` to list the content of a link to a directory on Unix platforms. (#3697)
Fix `Rename-Item` to allow Unix globbing patterns in paths. (#3661)

### Interactive fixes

- Add Hashtable tab completion for `-Property` of `Select-Object`. (#3625) (Thanks to @powercode)
- Fix tab completion with `@{<tab>` to avoid crash in PSReadline. (#3626) (Thanks to @powercode)
- Use `<id> - <name>` as `ToolTip` and `ListItemText` when tab completing process ID. (#3664) (Thanks to
@powercode)

### Remoting fixes

- Update PowerShell SSH remoting to handle multi-line error messages from OpenSSH client. (#3612)
- Add `-Port` parameter to `New-PSSession` to create PowerShell SSH remote sessions on non-standard
(non-22) ports. (#3499) (Thanks to @Lee303)

### API Updates

- Add the public property `ValidRootDrives` to `ValidateDriveAttribute` to make it easy to discover the
attribute state via `ParameterMetadata` or `PSVariable` objects. (#3510) (Thanks to @indented-automation!)
- Improve error messages for `ValidateCountAttribute`. (#3656) (Thanks to @iSazonov)
- Update `ValidatePatternAttribute`, `ValidateSetAttribute` and `ValidateScriptAttribute` to allow users
to more easily specify customized error messages. (#2728) (Thanks to @powercode)

### Windows 7 Packages

Windows 7 packages were not produced for this release due to a downlevel API set issue (#3747) that we
are working to resolve. Until it is fixed, users who wish to run PowerShell Core on Windows 7 systems can
use the [Alpha.18 release](https://github.com/PowerShell/PowerShell/releases/tag/v6.0.0-alpha.18).


v6.0.0-alpha.18

Improve the performance of writing progress records. (#2822) (Thanks to @iSazonov!)

### Cmdlet updates

 Use `ShellExecute` with `Start-Process`, `Invoke-Item`, and `Get-Help -Online` so that those cmdlets use standard shell associations to open a file/URI.
This means you `Get-Help -Online` will always use your default browser, and `Start-Process`/`Invoke-Item` can open any file or path with a handler.
(Note: there are still some problems with STA threads.) (#3281, partially fixes #2969)

Add `-Extension` and `-LeafBase` switches to `Split-Path` so that you can split paths between the filename extension and the rest of the filename. (#2721) (Thanks to @powercode!)
Implement `Format-Hex` in C# along with some behavioral changes to multiple parameters and the pipeline. (#3320) (Thanks to @MiaRomero!)
Add `-NoProxy` to web cmdlets so that they ignore the system-wide proxy setting. (#3447) (Thanks to @TheFlyingCorpse!)
?Fix `Out-Default -Transcript` to properly revert out of the `TranscribeOnly` state, so that further output can be displayed on Console. (#3436) (Thanks to @PetSerAl!)
Fix `Get-Help` to not return multiple instances of the same help file. (#3410)


v6.0.0-alpha.17
Use prettier formatter with `ConvertTo-Json` output. (#2787) (Thanks to @kittholland!)
Add the `-TimeOut` parameter to `Test-Connection`. (#2492)
Add `ShouldProcess` support to `New-FileCatalog` and `Test-FileCatalog` (fixes `-WhatIf` and `-Confirm`). (#3074) (Thanks to @iSazonov!)
Fix `Test-ModuleManifest` to normalize paths correctly before validating.
Remove the `AliasProperty Count` defined for `System.Array`.
? removes the extraneous `Count` property on some `ConvertFrom-Json` output. (#3231) (Thanks to @PetSerAl!)
Add `-CustomMethod` paramter to web cmdlets to allow for non-standard method verbs. (#3142) (Thanks to @Lee303!)
Fix web cmdlets to include the HTTP response in the exception when the response status code is not success.
Expose a process' parent process by adding the `CodeProperty Parent` to `System.Diagnostics.Process`. (#2850) (Thanks to @powercode!)
 Fix crash when converting a recursive array to a bool. (#3208) (Thanks to @PetSerAl!)
 Fix casting single element array to a generic collection. (#3170)
 Allow Windows' reserved device names (e.g. CON, PRN, AUX, etc.) to be used on non-Windows platforms. (#3252)
 Fix `PSModuleInfo.CaptureLocals` to not do `ValidateAttribute` check when capturing existing variables from the caller's scope. (#3149)
Fixed spelling for the property name `BiosSerialNumber` for `Get-ComputerInfo`. (#3167) (Thanks to @iSazonov!)


v6.0.0-alpha.16
Add `WindowsUBR` property to `Get-ComputerInfo` result
Add alias `Path` to the `-FilePath` parameter of `Out-File`
Fix the `-InFile` parameter of `Invoke-WebRequest`
Add the `RoleCapabilityFiles` keyword for JEA support on Windows


v6.0.0-alpha.15
Add `-Group` parameter to `Get-Verb`
Add new escape character for ESC: ``e`
`Invoke-RestMethod` improvements for non-XML non-JSON input


v6.0.0-alpha.14
`Split-Path` now works with UNC roots
Implicitly convert value assigned to XML property to string
Updates to `Invoke-Command` parameters when using SSH remoting transport
Fix `Invoke-WebRequest` with non-text responses on non-Windows platforms

v6.0.0-alpha.13
Enable `Invoke-WebRequest` and `Invoke-RestMethod` to not validate the HTTPS certificate of the server if required.
Add parameters `-Top` and `-Bottom` to `Sort-Object` for Top/Bottom N sort

Add `Get-Uptime` to `Microsoft.PowerShell.Utility`
 Make `Out-Null` as fast as `> $null`
Make `Write-Information` accept objects from pipeline
Add support to W3C Extended Log File Format in `Import-Csv`

v6.0.0-alpha.12
Select-Object with -ExcludeProperty now implies `-Property *` if -Property is not specified.
Adding ValidateNotNullOrEmpty to -Name parameter of Get-Alias
Adding ValidateNotNullOrEmpty to -Name parameter of Get-Service
Adding support <Suppress> in Get-WinEvent -FilterHashtable
Adding WindowsVersion to Get-ComputerInfo

v6.0.0-alpha.11
Add '-Title' to 'Get-Credential' and unify the prompt experience
Fix 'Get-ChildItem -Hidden' to work on system hidden files on Windows
Fix variable assignment to not overwrite readonly variables
Fix 'Get-WinEvent -FilterHashtable' to work with named fields in UserData of event logs
Fix 'Get-Help -Online' in PowerShell Core on Windows

v6.0.0-alpha.8
cd` with no arguments now behaves as `cd ~`

v6.0.0-alpha.7
Get-Process -IncludeUserName ported
ConvertFrom-Json multi-line bug fixed