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

# Loop through each group and ask the user if they want to change the state
ForEach ($Group in $AllGroups) {
    $GroupName = $Group.DisplayName
    $WelcomeMessageState = $Group.WelcomeMessageEnabled
    Write-Host "`nGroup Name: $GroupName"
    Write-Host "Welcome Email Enabled: $WelcomeMessageState"

    # Prompt user to decide on action
    $Response = Read-Host "Do you want to toggle the Welcome Email state for this group? (Y/N)"
    if ($Response -eq 'Y' -or $Response -eq 'y') {
        # Toggle the state
        $NewState = -not $WelcomeMessageState
        Set-UnifiedGroup -Identity $Group.Id -UnifiedGroupWelcomeMessageEnabled:$NewState

        Write-Host "Welcome Email state changed to $NewState for the group: $GroupName"
    } else {
        Write-Host "No changes made for the group: $GroupName"
    }
}

#
# Additional References
#
# https://www.reddit.com/r/Office365/comments/15knp3w/prevent_an_invitation_to_join_the_m365_group_from/
# https://www.sharepointdiary.com/2020/10/how-to-disable-welcome-email-in-office-365-group.html
#
