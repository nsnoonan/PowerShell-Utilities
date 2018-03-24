<#
.Synopsis
    Generates and returns password matching complexity requirements.
    
    NOTE: Script verifies that no character is repeated more than twice.
    EG: 098777839 will fail due to the repeated 777.

    NOTE: Script verifies that the first character is a letter unless -NumbersOnly is specified.

.Inputs
    * Requires a length paramater to define the length of the password.
    * Has switches [ContainsNumber] and [ContainsSpecial] to define complexity.
    * Has switch [NumbersOnly] for PIN-type passwords.
    * Has switch [WriteHost] for verbose output.

.Parameter Length
    Specify how many characters the password will be.  Accepts from 1 to 10,000.

.Parameter ContainsNumber
    If switch is specified, output will contain a number.

.Parameter ContainsSpecial
    If switch is specified, output will contain a special character.

.Parameter NumbersOnly
    If switch is specified, output will contain only numbers.
    NOTE: This overrides other [Contains] switches.

.Parameter WriteHost
    If switch is specified, verbose output will display in console.

.Parameter Count
    Number of passwords to generate and return.  Defaults to 1 if not specified.

.Outputs
    * A password meeting the complexity requirements of the input.
    * Verbose output if the WriteHost switch is specified.

.Example
    .\Generate-Password.ps1 -length 15 -ContainsNumber -ContainsSpecial
    .\Generate-Password.ps1 -length 8 -NumbersOnly -WriteHost

.Notes
    SCRIPT:             New-Password.ps1
    CREATE DATE:        2018-02-18
    CREATE AUTHOR:      Nick Noonan
    REV NOTES:
        v1.1 - 2018-02-19 / Nick Noonan
        * Added [NumbersOnly] switch.
        * Added logic to ensure no 3+ repeating characters.
        v1.2 - 2018-02-20 / Nick Noonan
        * Added break to repeat detection logic to stop at first failure.
        v1.3 - 2018-03-14 / Zack Schwermer
        * Added count paramter to generate more than one password.
#>

param
(
    [Switch]$ContainsNumber,
    [Switch]$ContainsSpecial,
    [Switch]$NumbersOnly,
    [Switch]$WriteHost,
    [int]$Count = 1,
    [Parameter(Mandatory = $true)]
    [ValidateRange(1,10000)]
    [int]$length
)

# function from Steve König
# http://activedirectoryfaq.com/2017/08/creating-individual-random-passwords/
function Get-RandomCharacters($length, $characters) { 
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length } 
    $private:ofs = "" 
    return [String]$characters[$random]
}

$Lower = 'abcdefghiklmnoprstuvwxyz'
$Upper = 'ABCDEFGHKLMNOPRSTUVWXYZ'
$Number = '0123456789'
$Special = '!@#$%^&*()-=+_[]{}<>'

[string]$Chars = $Lower + $Upper

# add char types if specified at run
if ($ContainsNumber) { $Chars += $Number }
if ($ContainsSpecial) { $Chars += $Special }
# replace with numbers only if specified at run
if ($NumbersOnly) { $Chars = $Number }

# generate and check until all checks pass and verified switch is true
$verified = $false
$PasswordList = @()
$i = 0
1..$Count | ForEach-Object {
    do {
        # get password
        $password = Get-RandomCharacters -length $length -characters $Chars
        if ($WriteHost) {write-host "New password is: $password" -ForegroundColor Green -BackgroundColor Black}

        # check for repeating characters, fail if 3 consecutive
        $PassArray = $password.ToCharArray()
        $LastChar = $null
        $LastLastChar = $null
        $RepeatVerify = $null
        foreach ($Char in $PassArray) {
            if ($Char -eq $LastChar -and $Char -eq $LastLastChar) {
                if ($WriteHost) {write-host "illegal repeated character: $Char" -ForegroundColor Red -BackgroundColor Black}
                $RepeatVerify = $False
                break
            }
            else {
                if ($WriteHost) {write-host "character $Char does not repeat with $LastChar and $LastLastChar"}
            }
            $LastLastChar = $LastChar
            $LastChar = $Char
        }
        # fail if RepeatVerify was set to false
        if ($RepeatVerify -eq $False) {
            if ($WriteHost) {write-host "failed repeat verify" -ForegroundColor Red -BackgroundColor Black}
            continue
        }



        # if NumbersOnly is specified, confirm no non-numbers
        if ($NumbersOnly) {
            if ($password -match '[^0-9]') {
                if ($WriteHost) {write-host "NumbersOnly contains illegal characters" -ForegroundColor Red -BackgroundColor Black}
                continue
            }
            else {
                # if here, passed all checks and is successful
                $verified = $true
                if ($WriteHost) {write-host "passes all checks" -ForegroundColor Green -BackgroundColor Black}
            }
        }
        else {
        
            # confirm first character starts with a letter, skip if fail
            if ($password -cmatch "^[a-zA-Z]") {
                if ($WriteHost) {write-host "starts with a letter"}
            }
            else { 
                if ($WriteHost) {write-host "does not start with a letter" -ForegroundColor Red -BackgroundColor Black}
                continue
            }

            # check for lowercase, skip if fail
            if ($password -cmatch '[a-z]') {
                if ($WriteHost) {write-host "contains [a-z]"}
            }
            else { 
                if ($WriteHost) {write-host "does not contain [a-z]" -ForegroundColor Red -BackgroundColor Black}
                continue
            }
    
            # check for uppercase, skip if fail
            if ($password -cmatch '[A-Z]') {
                if ($WriteHost) {write-host "contains [A-Z]"}
            }
            else { 
                if ($WriteHost) {write-host "does not contain [A-Z]" -ForegroundColor Red -BackgroundColor Black}
                continue
            }
    
            # check for number if specified at run, skip if fail
            if ($ContainsNumber) {
                if ($password -match '[0-9]') {
                    if ($WriteHost) {write-host "contains [0-9]"}
                }
                else { 
                    if ($WriteHost) {write-host "does not contain [0-9]" -ForegroundColor Red -BackgroundColor Black}
                    continue
                }
            }
    
            # check for special if specified at run, skip if fail
            if ($ContainsSpecial) {
                if ($password -match '[^a-zA-Z0-9]') {
                    if ($WriteHost) {write-host "contains special"}
                }
                else { 
                    if ($WriteHost) {write-host "does not contain special" -ForegroundColor Red -BackgroundColor Black}
                    continue
                }
            }
    
            # if here, passed all checks and is successful
            $verified = $true
            if ($WriteHost) {write-host "passes all checks" -ForegroundColor Green -BackgroundColor Black}
        }
    } while ($verified -ne $true)

    # return verfied good password
    if ($WriteHost) {write-host "Final passowrd is: $password" -ForegroundColor Green -BackgroundColor Black}
#    return $password
    #Adding variable
    $Details = "" | Select-Object PasswordNumber, Password
    $Details.Password = $Password
    $i++
    $Details.PasswordNumber = $i
    $PasswordList += $Details

}
return $PasswordList.Password
