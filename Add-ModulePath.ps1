<#
.Synopsis
    Adds specified location to modules $env:Path.

.Parameter Path
    Full path to the directory you'd like to add to $env:Path

.Example
    .\Add-ModulePath.ps1 -Path "C:\allegbin"

.Notes
    SCRIPT:             Add-Path.ps1
    CREATE DATE:        2021-02-26
    CREATE AUTHOR:      Nick Noonan
    REV NOTES:
        v1.0
        * Created script.
#>

param (
    [Parameter(Mandatory = $true)]
    [ValidateScript( { Test-Path $_ -PathType 'leaf' })]
    [string]$Path
)

if ($ENV:Path -notlike $Path) {
    write-host "adding $Path to your module path" -ForegroundColor Green -BackgroundColor Black
    $CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
    [Environment]::SetEnvironmentVariable("PSModulePath", $CurrentValue + ";$Path", "Machine")
}
else {
    write-host "your module path already contains $Path" -ForegroundColor Green -BackgroundColor Black
}
