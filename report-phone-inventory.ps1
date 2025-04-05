#
# display MDM phone inventory report - device name | serial number | phone number | carrier | assigned user
#


# Connect if not already connected
if (-not (Get-MgContext)) {
    Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"
}

cls
Write-Host ""


$ReportDate = Get-Date -Format "yyyy-MM-dd"
Write-Host "Summary Report Date: $ReportDate" -ForegroundColor Green

# Get all managed devices
$devices = Get-MgDeviceManagementManagedDevice -All

# Filter only iPhones
$iphones = $devices | Where-Object { $_.OperatingSystem -eq "iOS" -and $_.Model -like "iPhone*" }

# Select and format relevant data
$report = $iphones | Select-Object `
    DeviceName,
    SerialNumber,
    @{Name="PhoneNumber"; Expression = { $_.PhoneNumber }},
    @{Name="Carrier"; Expression = { $_.SubscriberCarrier }},
    @{Name="AssignedUser"; Expression = { $_.UserPrincipalName }}

# Output to console
$report | Format-Table -AutoSize

# Optional: Export to CSV
$report | Export-Csv -Path "Intune-iPhones-WithUsers.csv" -NoTypeInformation

Write-Host ""
