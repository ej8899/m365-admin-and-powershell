#
# This allows for the toggling of the "welcome email" to M365 groups
# It reads all groups into a list and shows the state of the "Welcome Email Enabled" 
# as either True or False and asks if you want to toggle this state 
#

# NOTICE - be sure to adjust your authentication method below - either (1) or (2)


# Connect to Exchange Online

# (1) uncomment below to have system prompt for full credentials
# Connect-ExchangeOnline -Credential (Get-Credential)

# (2) comment this out if using the above prompt instead - otherwise we're defaulting to an admin email as listed (& logged in).
Connect-ExchangeOnline -UserPrincipalName username@companydomain.com

# Get all Unified Groups
$AllGroups = Get-UnifiedGroup

# Initialize summary report
$SummaryReport = @()


# Loop through each group and ask the user if they want to change the state
ForEach ($Group in $AllGroups) {
    $GroupName = $Group.DisplayName
    $WelcomeMessageState = $Group.WelcomeMessageEnabled
    $Color = if ($WelcomeMessageState) { "Green" } else { "DarkYellow" }
    
    Write-Host "`nGroup Name: " -NoNewline
    Write-Host "$GroupName" -ForegroundColor Cyan
    Write-Host "Welcome Email Enabled: " -NoNewline
    Write-Host "$WelcomeMessageState" -ForegroundColor $Color

    # Add to summary report
    $SummaryReport += [PSCustomObject]@{
        GroupName = $GroupName
        WelcomeMessageState = $WelcomeMessageState
    }

    # Prompt user to decide on action
    $Response = Read-Host "Do you want to toggle the Welcome Email state for this group? (Y/N)"
    if ($Response -eq 'Y' -or $Response -eq 'y') {
        # Toggle the state
        $NewState = -not $WelcomeMessageState
        Set-UnifiedGroup -Identity $Group.Id -UnifiedGroupWelcomeMessageEnabled:$NewState

        Write-Host "Welcome Email state changed to $NewState for the group: $GroupName" -ForegroundColor Green
    } else {
        Write-Host "No changes made for the group: $GroupName" -ForegroundColor Yellow
    }
}


# Reset the foreground color to default after output
$Host.UI.RawUI.ForegroundColor = [System.ConsoleColor]::White

$ReportDate = Get-Date -Format "yyyy-MM-dd"
Write-Host "Summary Report Date: $ReportDate" -ForegroundColor Green

#
# Display summary report
#

# Calculate dynamic column widths
$maxGroupLength = ($SummaryReport | ForEach-Object { $_.GroupName.Length } | Measure-Object -Maximum).Maximum
$groupColWidth = [Math]::Max($maxGroupLength, 15) + 2
$stateColWidth = 25

# Header
$headerGroup = "Group Name".PadRight($groupColWidth)
$headerWelcome = "Welcome Email Enabled".PadRight($stateColWidth)
$divider = "-" * ($groupColWidth + $stateColWidth)

Write-Host "$headerGroup$headerWelcome" -ForegroundColor Cyan
Write-Host "$divider" -ForegroundColor Cyan

# Rows
foreach ($Item in $SummaryReport) {
    $group = $Item.GroupName.PadRight($groupColWidth)
    $stateText = if ($Item.WelcomeMessageState) { "Enabled" } else { "Disabled" }
    $color = if ($Item.WelcomeMessageState) { "Green" } else { "DarkYellow" }

    Write-Host "$group" -NoNewline
    Write-Host $stateText.PadRight($stateColWidth) -ForegroundColor $color
}



#
# Additional References
#
# https://www.reddit.com/r/Office365/comments/15knp3w/prevent_an_invitation_to_join_the_m365_group_from/
# https://www.sharepointdiary.com/2020/10/how-to-disable-welcome-email-in-office-365-group.html
#
