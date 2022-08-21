doc :
https://www.productplan.com/glossary/release-notes/

api public (signature)
https://github.com/ltrzesniewski/dotnet-runtime/blob/master/docs/coding-guidelines/breaking-change-rules.md


voir https://devblogs.microsoft.com/powershell/using-psscriptanalyzer-to-check-powershell-version-compatibility/

 Get-ASTCommand : retrouve toutes les commandes et filtre celles que l'on recherche, sinon chaque recherche de noeud AST va tous les tester.
On peut vouloir tout récupérer et faire produit par produit si un script utilise 2 ou + produits (SCCM et Teams par exemple).

    [System.Management.Automation.Language.StaticParameterBinder]::BindCommand
    cf module MeasureLocalizedData
	https://github.com/LaurentDardenne/MeasureLocalizedData/blob/master/MeasureLocalizedData.psm1

    voir la doc du change pour PS v7 : https://github.com/PowerShell/PowerShell/blob/master/docs/dev-process/breaking-change-contract.md
    https://github.com/PowerShell/PowerShell/issues?q=is%3Aopen+is%3Aissue+label%3ABreaking-Change
    pour un produit que des cmdlets, le plus osuvnet, pour PS le langage, variable auto et divers comportement


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
L'ancienne structure permet de recherche des string dansd le code C#.
    On recherche un mot clé/AST et on rapporte la raison de sa présence dans le résultat
On change le comportement d'un cmdlet en modifiant ou non sa signature ( qui détaille la raison)

une structure stable mais on ajoute des valeurs d'enumération :
Cmdlet=Catégorie de Changement (Peut être présent trois fois, un ajout et deux fois pour un paramètre existant avec break et un sans break, c'est l'usage du paramètre qui indique si c'est un Breaking Change)

(si certains paramètre deviennent obligatoire doivent peut devenir optionnel)
param=Delete,Add,Rename,Deprecated,TypeChange,DefaultValue,ChangeValue,Position,Mandatory,Optinnal,BugFix,RemoveParameterSet.
Attribut

Préconiser d'utiliser une assertion pour vérifier certains bug

#folder product\PSversion\R.Notes
    Produit='SCCM'
    PowershellVersion='5.1'
        #Cmdlet
        Name=@{ParameterName='raison de la présence? type de change '

    LibraryChangesForVersion='2107'

    Url='https://docs.microsoft.com/en-us/powershell/sccm/2107-release-notes?view=sccm-ps'

    RemovedCmdletNames=@(
        'Add-CMApplicationCatalogWebServicePoint',
        'Add-CMApplicationCatalogWebsitePoint',
        'Get-CMApplicationCatalogWebServicePoint',
        'Get-CMApplicationCatalogWebsitePoint',
        'Remove-CMApplicationCatalogWebServicePoint',
        'Remove-CMApplicationCatalogWebsitePoint',
        'Set-CMApplicationCatalogWebsitePoint',
        'Get-CMVhd',
        'New-CMVhd',
        'Remove-CMVhd',
        'Set-CMVhd'
    )

    RemovedAliasNames=@(
    )

    DeprecatedCommandNames=@(
        'Start-CMApplicationDeploymentSimulation',
        'Start-CMClientSettingDeployment',
        'Start-CMAntimalwarePolicyDeployment'
    )

    UnresolvedBugCommandNames=@(
    )

    ChangedCommandNames=@(
        'Add-CMDeviceCollectionDirectMembershipRule',
        'Add-CMTaskSequenceStep',
        'Disconnect-CMTrackedObject',
        'Get-CMApplicationGroup',
        'Get-CMDeploymentStatusDetails',
        'Import-CMAntimalwarePolicy',
        'Import-CMQuery',
        'New-CMAdministrativeUser',
        'New-CMApplicationDeployment',
        'New-CMMigrationJob',
        'New-CMSoftwareUpdateAutoDeploymentRule',
        'New-CMSoftwareUpdateDeployment',
        'New-CMTaskSequence',
        'New-CMTaskSequenceDeployment',
        'New-CMTSStepApplyDriverPackage',
        'New-CMTSStepApplyOperatingSystem',
        'New-CMTSStepUpgradeOperatingSystem',
        'Publish-CMPrestageContent',
        'Remove-CMApplicationGroup',
        'Set-CMAntimalwarePolicy',
        'Set-CMApplicationDeployment',
        'Set-CMClientSetting',
        'Set-CMClientSettingSoftwareUpdate',
        'Set-CMDeploymentType',
        'Set-CMMsiDeploymentType',
        'Set-CMTaskSequence',
        'Set-CMTSStepApplyDriverPackage',
        'Set-CMTSStepApplyOperatingSystem',
        'Set-CMTSStepUpgradeOperatingSystem',
        'Update-CMDistributionPoint'
    )

    BreakingChangesCommandNames=@(
        'Add-CMDistributionPoint',
        'New-CMCloudManagementGateway',
        'New-CMSecondarySite',
        'Start-CMDistributionPointUpgrade'
    )
}
