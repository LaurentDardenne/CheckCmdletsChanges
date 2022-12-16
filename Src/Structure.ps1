

#folder product\PSversion\R.Notes



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


# Write-Warning "FunctionName `r`n$($PSBoundParameters.GetEnumerator()|Out-String -width 512)"

@{
    ProductName='SCCM'
    Version='2203'
     #de la doc cette release
    Url='https://docs.microsoft.com/en-us/powershell/sccm/2203-release-notes?view=sccm-ps'
    UrlProject='github'

    Changes=@(
        #New-ChangeCmdlet -Name -ChangeType -Severity -UrlIssue -Description
        New-ChangeCmdlet -Name 'Test' -ChangeType 'BugFix'
        New-ChangeCmdlet -Name 'Test' -ChangeType 'BugFix' -Edition Core -Version
    )
}

