#requires -version 3
<#
    .SYNOPSIS
        AU build script
#>
param(
    # Version to set
    [Parameter()]
    [Alias("ModuleVersion", "Version")]
    [string]$SemVer = $(
        if (Get-Command GitVersion) {
            gitversion -showvariable SemVer
        } else {
            "0.1.0-dev.1"
        }
    ),

    # Does not build the Chocolatey package if true
    [Alias("NoChocoPackage")]
    [switch]$SkipPackage
)
$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot -StackName BuildScript

try {
    # Build the module
    $Module = Build-Module -SemVer $SemVer -Passthru

    # Create a help file for the module, based on the Readme
    $HelpFolder = Join-Path $Module.ModuleBase "en-US"
    if (-not (Test-Path $HelpFolder -PathType Container)) {
        $null = New-Item -Path $HelpFolder -ItemType Directory
    }
    Get-Content $PSScriptRoot/README.md | Select-Object -Skip 4 | Set-Content $HelpFolder/about_Chocolatey-AU.help.txt -Encoding ascii
    
    # Create the packages
    if (-not $SkipPackage) {
        $OutputFolder = Resolve-Path $PSScriptRoot\output\

        choco pack $PSScriptRoot\chocolatey\chocolatey-au.nuspec --version $Module.Version --output $OutputFolder

        try {
            Register-PSRepository -Name "$(($RepoName = New-Guid))" -SourceLocation $OutputFolder -PublishLocation $OutputFolder
            Publish-Module -Path $Module.ModuleBase -Repository $RepoName
        } finally {
            Unregister-PSRepository -Name $RepoName
        }
    }
} finally {
    Pop-Location -StackName BuildScript
}