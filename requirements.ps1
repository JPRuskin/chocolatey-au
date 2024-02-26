#requires -version 5

if (-not (Get-Command choco.exe)) {
    Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression
}

if (-not (Get-Command gitversion)) {
    choco install GitVersion.Portable --confirm
}

$PSScriptRoot\Install-RequiredModules.ps1