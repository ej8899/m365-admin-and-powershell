<#
.SYNOPSIS
    Export all security groups and their members, then email the report using Microsoft Graph API.

.DESCRIPTION
    - Connects to Microsoft Graph
    - Lists all security-enabled, non-mail-enabled groups
    - Gathers group members with DisplayName and UPN
    - Exports to a dated CSV file
    - Emails the report using Graph API (no SMTP or app password)

.NOTES
    Requires Microsoft.Graph PowerShell module.
    Scopes needed: Group.Read.All, User.Read.All, Mail.Send
#>

# Load required module
# Import-Module Microsoft.Graph -ErrorAction Stop


# Connect to Graph with required scopes
Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All", "Mail.Send"

# Get today's date and output file path
$date = Get-Date -Format "yyyy-MM-dd"
# $outputPath = "SecurityGroupMembers-$date.csv"
$outputPath = Join-Path -Path (Get-Location) -ChildPath "SecurityGroupMembers-$date.csv"

# Fetch security groups
$groups = Get-MgGroup -Filter "securityEnabled eq true and mailEnabled eq false" -All
$result = @()

foreach ($group in $groups) {
    Write-Host "Processing group: $($group.DisplayName)" -ForegroundColor Cyan
    $members = Get-MgGroupMember -GroupId $group.Id -All | Where-Object {
        $_.AdditionalProperties['userPrincipalName'] -ne $null
    }

    if ($members.Count -eq 0) {
        $result += [PSCustomObject]@{
            GroupName = $group.DisplayName
            UserName  = "<No Members>"
            UPN       = ""
        }
    } else {
        foreach ($member in $members) {
            $result += [PSCustomObject]@{
                GroupName = $group.DisplayName
                UserName  = $member.AdditionalProperties['displayName']
                UPN       = $member.AdditionalProperties['userPrincipalName']
            }
        }
    }
}

# Export to CSV
$result | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8
Write-Host "CSV report exported to: $outputPath" -ForegroundColor Green

# Read and encode file for Graph email
$fileBytes = [System.IO.File]::ReadAllBytes($outputPath)
$fileBase64 = [Convert]::ToBase64String($fileBytes)

# Prepare and send the email
$fromUser = "sender@COMPANY.com" # Must be a licensed user
$toUser = "receiver@COMPANY.com"

Send-MgUserMail -UserId $fromUser -BodyParameter @{
    Message = @{
        Subject = "Security Group Membership Report - $date"
        Body = @{
            ContentType = "Text"
            Content = "Hi team,`n`nAttached is the security group membership report for $date.`n`nRegards,`nIT Automation"
        }
        ToRecipients = @(
            @{
                EmailAddress = @{
                    Address = $toUser
                }
            }
        )
        Attachments = @(
            @{
                "@odata.type" = "#microsoft.graph.fileAttachment"
                Name = [System.IO.Path]::GetFileName($outputPath)
                ContentBytes = $fileBase64
            }
        )
    }
    SaveToSentItems = $false
}

Write-Host "Email sent to $toUser via Microsoft Graph." -ForegroundColor Green
