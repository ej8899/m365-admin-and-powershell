#
# Scan the logs to see who is installing miscellaneous Teams Apps
# EJMedia.ca - 2025
#


# Number of days to scan (e.g., -90 for 90 days, -180 for 6 months)
$DaysToScan = -180

# Number of log entries to retrieve (increase if needed)
$ResultSize = 10

# Admin account for Exchange Online connection
$AdminUser = ""


#
# Engage
#

# check for $AdminUser
if ([string]::IsNullOrWhiteSpace($AdminUser)) {
    Write-Host "ERROR: Admin account (AdminUser) is not set. Please update the script and try again." -ForegroundColor Red
    exit 1  # Exit script with error code
}

# Connec to Exchange Server
Connect-ExchangeOnline -UserPrincipalName $AdminUser

# Retrieve logs for "Add app"
$logs = Search-UnifiedAuditLog -Operations "Add app" -StartDate (Get-Date).AddDays($DaysToScan) -EndDate (Get-Date) -ResultSize $ResultSize

# Display full details of the first log entry (for debugging)
if ($logs.Count -gt 0) {
    $logs[0].AuditData | ConvertFrom-Json | Format-List *
} else {
    Write-Host "No app installation logs found in the past $(-$DaysToScan) days."
}
