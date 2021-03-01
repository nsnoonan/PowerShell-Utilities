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

param (
    [switch]$Date,
    [switch]$Time,
    [switch]$DateTime,
    [switch]$DateTimeFile
)

if ($Date) {
    $stamp = get-date -format "yyyy-MM-dd"
} elseif ($Time) {
    $stamp = get-date -format "HH:mm:ss"
} elseif ($DateTime) {
    $stamp = get-date -format "yyyy-MM-dd HH:mm:ss"
} elseif ($DateTimeFile) {
    $stamp = get-date -format "yyyy-MM-dd_HH-mm-ss"
} else {
    $stamp = get-date -format "yyyy-MM-dd_HH-mm-ss"
}

return $stamp