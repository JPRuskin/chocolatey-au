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

    # Clean up uncommitted changes
    [switch]$Clean,

    # Does not build the Chocolatey package if true
    [Alias("NoChocoPackage")]
    [switch]$SkipPackage
)
$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot -StackName BuildScript

try {
    if ($Clean) {
        git clean -Xfd -e vars.ps1; return
    }

    # Build the module
    $Module = Build-Module -SemVer $SemVer -Passthru

    # Create a help file for the module, based on the Readme
    $HelpFolder = Join-Path $Module.ModuleBase "en-US"
    if (-not (Test-Path $HelpFolder -PathType Container)) {
        $null = New-Item -Path $HelpFolder -ItemType Directory
    }
    Get-Content $PSScriptRoot/README.md | Select-Object -Skip 4 | Set-Content $HelpFolder/about_Chocolatey-AU.help.txt -Encoding ascii
    
    # Create the Chocolatey package, if required
    if (-not $SkipPackage) {
        choco pack $PSScriptRoot\chocolatey\chocolatey-au.nuspec --version $Module.Version
    }
} finally {
    Pop-Location -StackName BuildScript
}