<#
.Synopsis
    Adds specified location to $env:Path.

.Parameter Path
    Full path to the directory you'd like to add to $env:Path

.Example
    .\Add-Path.ps1 -Path "C:\allegbin"

.Notes
    SCRIPT:             Add-Path.ps1
    CREATE DATE:        2018-03-26
    CREATE AUTHOR:      Nick Noonan
    REV NOTES:
        v1.0
        * Created script.
#>

param
(
    [Parameter(Mandatory = $true)]
    [ValidateScript( {Test-Path $_ -PathType 'leaf'})]
    [string]$Path
)


if (!($ENV:Path -like $Path)) {
    write-host "adding $Path to your path" -ForegroundColor Green -BackgroundColor Black
    $AddPaths += ";$Path"
    [Environment]::SetEnvironmentVariable("Path", $env:Path + "$AddPaths", [EnvironmentVariableTarget]::Machine)
} else {
    write-host "your path already contains $Path" -ForegroundColor Red -BackgroundColor Black
}