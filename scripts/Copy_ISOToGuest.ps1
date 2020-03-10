Set-StrictMode -Version Latest

$ErrorActionPreference = "stop"

$CopySettings = @{
    Name            = "build"
    FileSource      = "host"
    SourcePath      = ".\rhel-8.0-x86_64-dvd.iso"
    DestinationPath = "/root"
}

Copy-VMFile @CopySettings
