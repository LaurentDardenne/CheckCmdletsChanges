

#folder product\PSversion\R.Notes
Produit='SCCM'
PowershellVersion='5.1'
    #Cmdlet
    Name=@{ParameterName='raison de la présence? type de change '

LibraryChangesForVersion='2107'

Url='https://docs.microsoft.com/en-us/powershell/sccm/2107-release-notes?view=sccm-ps'

}

#un seul
$Severity=@('Error','Warning','Information')

$ChangeTypeSeverity=@{
'Removed'='Error';
'Deprecated'='Warning';
'UnResolvedBug'='Error';
'BugFix'='Warning';
'Changed'='Information'; #?
'BreakingChange'='Error';
'Unsupported'='Error';
'Added'='Information'
}

#plusieurs ?
$ChangeType=@(
    'Removed',
    'Deprecated',
    'UnResolvedBug',
    'BugFix',
    'Changed',
    'BreakingChange',
    'Unsupported',
    'Added'
)

#Type de l'élément concerné
$Target=('Cmdlet','Alias','Language','CmdletParameter')

@{
    ProductName='SCCM'
    Version='2203'
    PowershellVersion='5.1'
     #de la doc ce release
    Url='https://docs.microsoft.com/en-us/powershell/sccm/2203-release-notes?view=sccm-ps'
    UrlProject='github'

    Changes=@(
        #new-change
        Name # du cmdlet,Alias
        ParameterName # si c'est un cmdlet
        Target
        ChangeType
        #Severity :propriété interne déduite de $ChangeTypeSeverity
        #Court texte détaillant le change
        Description

        #language :classe AST ?
    )
}

