#
# Scan the logs to see who is installing miscellaneous Teams Apps
#


# Number of days to scan (e.g., -90 for 90 days, -180 for 6 months)
$DaysToScan = -180

# Number of log entries to retrieve (increase if needed)
$ResultSize = 10

# Admin account for Exchange Online connection
$AdminUser = "admin-account@yourcompany.com"


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

# Check if log data exists before processing
if ($logs.Count -gt 0) {
    Write-Host "Found $($logs.Count) installation log(s) in the past $(-$DaysToScan) days.`n"

    # Loop through each log entry and display full details
    foreach ($log in $logs) {
        Write-Host "-------------------------------------"
        Write-Host "Timestamp: $($log.CreationDate)"
        Write-Host "User: $($log.UserIds)"

        # Parse AuditData JSON
        $auditData = $log.AuditData | ConvertFrom-Json

        # Extract key fields
        $objectId = if ($auditData.PSObject.Properties["ObjectId"]) { $auditData.ObjectId } else { "N/A" }
        $appId = if ($auditData.PSObject.Properties["AppId"]) { $auditData.AppId } else { "N/A" }
        $appName = if ($auditData.PSObject.Properties["AppDisplayName"]) { $auditData.AppDisplayName } else { "Unknown" }

        Write-Host "Object ID (Possible App ID): $objectId"
        Write-Host "App ID: $appId"
        Write-Host "App Name: $appName"

        # Show full raw log data (json)
        Write-Host "`nFULL LOG DATA:"
        $auditData | ConvertTo-Json -Depth 3

        Write-Host "-------------------------------------`n"
    }
} else {
    Write-Host "No app installation logs found in the past $(-$DaysToScan) days."
}
