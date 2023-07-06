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

    # Clean up uncommitted files
    [switch]$Clean,

    # Do not build chocolatey package
    [switch]$NoChocoPackage
)

function zip_module() {
    Write-Host "Creating 7z package"

    $zip_path = "$build_dir\${module_name}_$version.7z"
    $cmd = "$Env:ChocolateyInstall/tools/7z.exe a '$zip_path' '$module_path' '$installer_path'"
    $cmd | Invoke-Expression | Out-Null
    if (!(Test-Path $zip_path)) { throw "Failed to build 7z package" }
}

function build_chocolatey_package {
    if ($NoChocoPackage) { Write-Host "Skipping chocolatey package build"; return }

    & $PSScriptRoot/chocolatey/build-package.ps1
    Move-Item "$PSScriptRoot/chocolatey/${module_name}.$version.nupkg" $build_dir
}

function create_help() {
    Write-Host 'Creating module help'

    $help_dir = "$module_path/en-US"
    New-Item -Type Directory -Force $help_dir | Out-Null
    Get-Content $PSScriptRoot/README.md | Select-Object -Skip 4 | Set-Content "$help_dir/about_${module_name}.help.txt" -Encoding ascii
}

if ($Clean) { git clean -Xfd -e vars.ps1; return }

$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot -StackName BuildScript

try {
    Build-Module -SemVer $SemVer
    # create_help
    # zip_module
    # build_chocolatey_package
} finally {
    Pop-Location -StackName BuildScript
}