﻿param (
    [Alias("User","U")][string]$UserName,
    [switch]$Verbose,
    [switch]$NoGroupRemoval,
    [switch]$NoOutputFile
)

$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
. $ScriptDir\EnvConfig.ps1

Write-Host "Disable a User Account - on prem"

If (!$UserName) {$UserName = Read-Host "Enter username"}

Disable-ADAccount -Identity $UserName

$Groups = Get-ADPrincipalGroupMembership $UserName

if (-NOT $NoOutputFile) { $Groups | Select NAME |  Export-Csv $UserGroupCSVLocation\$UserName.csv }

if (-NOT $NoGroupRemoval)
{
    foreach ($Group in $Groups) {
        if ($Group.name -ne "Domain Users") {
            Remove-ADGroupMember -Identity $Group -Members $UserName -Confirm:$false;
            if($Verbose) { write-host "Removed" $username "from Group:" $group.name; }
        }
    }
}