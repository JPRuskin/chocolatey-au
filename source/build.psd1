@{
    ModuleManifest           = "Chocolatey-AU.psd1"
    # Subsequent relative paths are to the ModuleManifest
    OutputDirectory          = "../"
    VersionedOutputDirectory = $true
    CopyDirectories          = @('Plugins')
}
