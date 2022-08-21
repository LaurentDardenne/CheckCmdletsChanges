
Function Get-AST {
#from http://becomelotr.wordpress.com/2011/12/19/powershell-vnext-ast/
<#
.Synopsis
   Function to generate AST (Abstract Syntax Tree) for PowerShell code.

.DESCRIPTION
   This function will generate Abstract Syntax Tree for PowerShell code, either from file or direct input.
   Abstract Syntax Tree is a new feature of PowerShell 3 that should make parsing PS code easier.
   Because of nature of resulting object(s) it may be hard to read (different object types are mixed in output).

.EXAMPLE
   $AST = Get-AST -FilePath MyScript.ps1
   $AST will contain syntax tree for MyScript script. Default are used for list of tokens ($Tokens) and errors ($Errors).

.EXAMPLE
   Get-AST -Input 'function Foo { param ($Foo) Write-Host $Foo }' -Tokens MyTokens -Errors MyErors | Format-Custom
   Display function's AST in Custom View. $MyTokens contain all tokens, $MyErrors would be empty (no errors should be recorded).

.INPUTS
   System.String

.OUTPUTS
   System.Management.Automation.Languagage.Ast

.NOTES
   Just concept of function to work with AST. Needs a polish and shouldn't polute Global scope in a way it does ATM.

#>

[CmdletBinding(
    DefaultParameterSetName = 'File'
)]
param (
    # Path to file to process.
    [Parameter(
        Mandatory,
        HelpMessage = 'Path to file to process',
        ParameterSetName = 'File'
    )]
    [Alias('Path','PSPath')]
    [ValidateNotNullOrEmpty()]
    [string]$FilePath,
    
    # Input string to process.
    [Parameter(
        Mandatory,
        HelpMessage = 'String to process',
        ParameterSetName = 'Input'

    )]
    [Alias('Script','IS')]
    [string]$InputScript,

    # Name of the list of Errors.
    [Alias('EL')]
    [ValidateScript({$_ -ne 'ErrorsList'})] 
    [string]$ErrorsList = 'ErrorsAst',
    
    # Name of the list of Tokens.
    [Alias('TL')]
    [ValidateScript({$_ -ne 'TokensList'})]
    [string]$TokensList = 'Tokens',
    [switch] $Strict
)
   
    if (($PsCmdlet.ParameterSetName -eq "File") -and ((Test-Path -LiteralPath $FilePath) -eq $false))
    { throw "The file do not exist : $FilePath" }

     #Chaque appel de l'API crée une nouvelle instance
    New-Variable -Name $ErrorsList -Value $null -Scope Global -Force
    New-Variable -Name $TokensList -Value $null -Scope Global -Force

    switch ($psCmdlet.ParameterSetName) {
        File {
            $ParseFile = (Resolve-Path -LiteralPath $FilePath).ProviderPath
            [System.Management.Automation.Language.Parser]::ParseFile(
                $ParseFile, 
                [ref](Get-Variable -Name $TokensList),
                [ref](Get-Variable -Name $ErrorsList)
            )
        }
        Input {
            [System.Management.Automation.Language.Parser]::ParseInput(
                $InputScript, 
                [ref](Get-Variable -Name $TokensList),
                [ref](Get-Variable -Name $ErrorsList)
            )
        }
    }
   if ( (Get-Variable $ErrorsList).Value.Count -gt 0  )
   {
      $Er= New-Object System.Management.Automation.ErrorRecord(
              (New-Object System.ArgumentException("The syntax of the code is incorrect. $ParseFile")), 
              "InvalidSyntax", 
              "InvalidData",
              "[AST]"
             )  

      if ($Strict) 
      {  throw $er }
      else
      { $PSCmdlet.WriteError($Er)}
   }
} #Get-AST

Function Split-VariablePath {
<#
.SYNOPSIS
   Supprime l'indicateur de portée précisé dans le nom de variable          
#>            
 param (
  [System.Management.Automation.Language.VariableExpressionAst] $VEA
 )
 $VEA.VariablePath.UserPath -Replace '^(.*):(.*)$','$2'
}#Split-VariablePath

Function New-LocalizedDataInformations{
  param (
    $Path,
    [System.Management.Automation.Language.StaticBindingResult] $Binding
  )
  
  [pscustomobject]@{
      PSTypeName='LocalizedDataInformations'
        #Nom du fichier de localisation des messages 
      FileName=$binding.BoundParameters['FileName'].ConstantValue
        #Nom de la variable utilisée pour accèder aux clés de la hashtable 
        #contenant les messages localisés
      BindingVariable=$binding.BoundParameters['BindingVariable'].ConstantValue
        #Nom complet du fichier contenant les appels à Import-localizedData
        #Dénormalisation assumée ;-)
      ScriptPath=$Path      
        #Nom du fichier contenant les appels à Import-localizedData
      ScriptName=[System.IO.Path]::GetFileName($Path)
        #Nom du répertoire du fichier 
      BaseDirectory=[System.IO.Path]::GetDirectoryName($Path)
        #Liste des clés trouvées
      KeysFound=$null
  }
} #New-LocalizedDataInformations

Function Search-ASTCommand {
<#
.SYNOPSIS
  Recherche dans un script les appels au cmdlet 'Import-LocalizedData'.
  On récupère deux paramètre : 
       le nom de la variable et 
       le nom du fichier de localisation.
  On émet seulement les cas utilisables.
#> 

 [CmdletBinding()]
 param(
      #Chemin complet du fichier à analyser
     [Parameter(Position=1, Mandatory=$true)] 
   [string] $Path
 ) 

  $AstScript = Get-AST -FilePath $Path -Strict
  # 1 - Première lecture de l'arbre
  #----------Recherche les appels de cmdlet
  $ImportLocalizedDataCommands = $AstScript.FindAll(
    {
      [System.Management.Automation.Language.Ast]$ast = $args[0]
      $ast -is [System.Management.Automation.Language.CommandAst]
    }, $true)
  
  foreach ($Binding in $ImportLocalizedDataCommands)
  {
     $Parameters=[System.Management.Automation.Language.StaticParameterBinder]::BindCommand($Binding)
     if ( ($null -ne $Parameters) -and ($Parameters.BindingExceptions.Count -gt 0) )
     {
       
       $Er= New-Object System.Management.Automation.ErrorRecord(
        (New-Object System.Exception("Binding error line $($binding.extent.StartLineNumber) in file '$($binding.extent.File)'")), 
        "InvalidSyntax", 
        "SyntaxError",
        "[AST]"
        )  
       $PScmdlet.WriteError($Er)
       foreach ($BindingException in $Parameters.BindingExceptions.GetEnumerator())
       {
          $Er= New-Object System.Management.Automation.ErrorRecord(
          (New-Object System.Exception("$($BindingException.Value.BindingException)")), 
          "UnknownParameter", 
          "InvalidArgument",
          "$($BindingException.Key)"
          ) 
          $PScmdlet.WriteError($er)
       }
       continue
     }
     $result=New-LocalizedDataInformations $Path $Parameters
      #Comportement du cmdlet 
      #revoir MeasureLocalizedData.psm1
     if (! $Parameters.BoundParameters.ContainsKey('FileName'))
     { 
        $result.FileName=[System.IO.Path]::GetFileNameWithoutExtension($Path)+'.psd1'
        Write-verbose "The parameter 'Filename' is not bounded, we use an implicit filename : '$($result.FileName)'" 
     }
     elseif ($null -eq $Parameters.BoundParameters['FileName'].ConstantValue) 
     {
        #cas :  -FileName (Microsoft.PowerShell.Management\Split-Path $PSModuleInfo.Path -Leaf)       
       Write-warning "Syntax not supported : $Binding"
       Continue 
     }
     
     if (! $Parameters.BoundParameters.ContainsKey('BindingVariable'))
     {
        $astParent=$Binding.Parent.Parent
        if ($astParent -is [System.Management.Automation.Language.AssignmentStatementAst] )
        {
          if ($astParent.Left -is [System.Management.Automation.Language.VariableExpressionAst])
          {
              $result.BindingVariable=Split-VariablePath $astParent.Left
              Write-verbose "The parameter 'BindingVariable' is not bounded, we use an explicit variable : $($result.BindingVariable)" 
              $result 
          }
        }
     }
     else 
     { $result }
  } 
} #Search-ASTImportLocalizedData

Function Get-ASTCommand{}

Function Find-CmdletChange {
<#
.Synopsis

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS
#>  
}
  
#Export-ModuleMember -Function ''