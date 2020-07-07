<#
.SYNOPSIS
    Creates powershell module and adds all scripts inside specified folder as functions in the module

.NOTES
    CREATE DATE:    2020-07-01
    CREATE AUTHOR:  Nick Noonan
    REV NOTES:
        v1.0: 2020-07-01 / Nick Noonan
        * Created script.
#>

param 
(
    [Parameter(Mandatory = $true)]
    [ValidateScript( { Test-Path $_ -PathType 'container' })]
    [String]$ScriptFolder,
    [String]$ModuleName
)

# determine module name
$FolderObj = Get-Item $ScriptFolder
if (!($ModuleName)) {
    $ModuleName = $FolderObj.Name
}
if ($ModuleName -NotLike ".psm1$") {
    $ModuleName = "$ModuleName.psm1"
}

# create a header for the module and write to file
$DateStamp = get-date -format "yyyy-MM-dd"
$ScriptNotes = @"
<#
.SYNOPSIS
    module created by Build-Module.ps1
    ran against folder [$($FolderObj.fullname)]

.NOTES
    CREATE DATE:    $DateStamp
    CREATE AUTHOR:  $($ENV:username)
    REV NOTES:
        v1.0: $DateStamp / $($ENV:username)
        * Created module

"@

# grab all scripts
$scripts = Get-ChildItem $FolderObj -Name "*.ps1"
# add each function name to module notes
foreach ($script in $scripts) {
    # skip if it's the build-module script itself
    if ($script.pschildname -match "Build-Module.ps1") {
        continue
    }
    $FunctionName = $script.pschildname -replace ".ps1", ""
    $ScriptNotes += @"
        * Added $FunctionName

"@
}
$ScriptNotes += @"
#>
"@
$ScriptNotes | Out-File $ModuleName

# start adding scripts to module
foreach ($script in $scripts) {
    # skip if it's the build-module script itself
    if ($script.pschildname -match "Build-Module.ps1") {
        continue
    }

    # compile function
    $FunctionName = $script.pschildname -replace ".ps1", ""
    $FunctionCode = (get-content $script) -join "`n"
    $Function = @"
function $FunctionName {
    $FunctionCode
}
Export-ModuleMember -Function $FunctionName

"@
    # append function to module
    $function | Out-File $ModuleName -append
}