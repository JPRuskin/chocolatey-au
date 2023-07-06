@{
    # Module Information
    RootModule        = 'Chocolatey-AU.psm1'
    Description       = 'Chocolatey Automatic Package Updater Module'
    ModuleVersion     = '0.1.0'
    GUID              = 'b7e71ae5-cf37-47e1-b3b6-df606b3f6af9'
    
    # Author Information
    Author            = 'Chocolatey Community'  # with thanks to Miodrag Milic and other contributors
    CompanyName       = 'Chocolatey Software'
    # Copyright         = '(c) Chocolatey Community. All rights reserved.'

    PowerShellVersion = '5.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Get-AUPackages'
        'Get-RemoteChecksum'
        'Get-RemoteFiles'
        'Get-Version'
        'Push-Package'
        'Set-DescriptionFromReadme'
        'Test-Package'
        'Update-AUPackages'
        'Update-Package'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @()

    PrivateData       = @{
        PSData = @{
            Tags         = 'chocolatey', 'update'
            LicenseUri   = 'https://github.com/chocolatey-community/chocolatey-au/blob/master/license.txt'
            ProjectUri   = 'https://github.com/chocolatey-community/chocolatey-au'
            # IconUri = ''
            ReleaseNotes = 'https://github.com/chocolatey-community/chocolatey-au/releases'
            Prerelease = ''
            RequireLicenseAcceptance = $false
            # ExternalModuleDependencies = @()
        }
    }

    HelpInfoURI       = 'https://github.com/chocolatey-community/chocolatey-au/'
}
