# Connect to Graph
Connect-MgGraph -Scopes "Group.Read.All", "User.Read.All"

# Get date string
$date = Get-Date -Format "yyyy-MM-dd"
$outputPath = "SecurityGroupMembers-$date.csv"

# Get security groups
$groups = Get-MgGroup -Filter "securityEnabled eq true and mailEnabled eq false" -All
$result = @()

foreach ($group in $groups) {
    Write-Host "Processing group: $($group.DisplayName)" -ForegroundColor Cyan
    $members = Get-MgGroupMember -GroupId $group.Id -All | Where-Object {$_.AdditionalProperties['userPrincipalName'] -ne $null}

    foreach ($member in $members) {
        $result += [PSCustomObject]@{
            GroupName = $group.DisplayName
            UserName  = $member.AdditionalProperties['displayName']
            UPN       = $member.AdditionalProperties['userPrincipalName']
        }
    }

    if (-not $members) {
        $result += [PSCustomObject]@{
            GroupName = $group.DisplayName
            UserName  = "<No Members>"
            UPN       = ""
        }
    }
}

# Export
$result | Export-Csv -Path $outputPath -NoTypeInformation -Encoding UTF8
Write-Host "Done. Output saved to $outputPath"
