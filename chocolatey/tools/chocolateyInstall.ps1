$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$ModuleName = "Chocolatey-AU"
$ModuleVersion = $env:ChocolateyPackageVersion

$SourcePath = Join-Path $toolsDir "$($ModuleName)\*"
$SavedPaths = Join-Path $ToolsDir 'installedpaths'

$DestinationPath = switch ((Get-PackageParameters).Keys) {
    "Core" {
        Join-Path $env:ProgramFiles "PowerShell\Modules"
    }
    "Desktop" {
        Join-Path $env:ProgramFiles "WindowsPowerShell\Modules"
    }
}

# By default, install for Windows PowerShell
if (-not $DestinationPath) {
    $DestinationPath = Join-Path $env:ProgramFiles "WindowsPowerShell\Modules"
}

$InstalledPaths = foreach ($Path in $DestinationPath) {
    Write-Verbose "Installing '$ModuleName' to '$Path'"

    # PS > 5 needs to extract to a versioned folder
    $Path = if ($PSVersionTable.PSVersion.Major -ge 5) {
        Join-Path $Path "$($ModuleName)\$($ModuleVersion)"
    } else {
        Join-Path $Path "$($ModuleName)"
    }

    if (-not (Test-Path $Path)) {
        $null = New-Item $Path -ItemType Directory -Force
    }

    Copy-Item -Path $SourcePath -Destination $Path -Recurse
}

# Cleanup the module from the Chocolatey $toolsDir folder
Remove-Item $SourcePath -Force -Recurse

# Store the installed locations, so we can remove them during uninstall
Set-Content $SavedPaths -Value $InstalledPaths