# Connect to Exchange Online

# Uncomment ONE of the following based on how you want credentials handled
# Connect-ExchangeOnline -Credential (Get-Credential)
# Connect-ExchangeOnline -UserPrincipalName ernie@erniejohnson.ca

# Get all Unified Groups
$AllGroups = Get-UnifiedGroup
                                    


$Host.UI.RawUI.ForegroundColor = [System.ConsoleColor]::Blue

Write-Host "
        _     _                
   ___ (_) __| | _____   _____ 
  / _ \| |/ _`` |/ _ \ \ / / __|
 |  __/| | (_| |  __/\ V /\__ \
  \___|/ |\__,_|\___| \_/ |___/
     |__/                      
ernie@erniejohnson.ca
"

# Reset the foreground color to default after output
$Host.UI.RawUI.ForegroundColor = [System.ConsoleColor]::White

$ReportDate = Get-Date -Format "yyyy-MM-dd"
Write-Host "Report Date: $ReportDate" -ForegroundColor Green

# Loop through each group and show the welcome message flag state
ForEach ($Group in $AllGroups) {
    $GroupName = $Group.DisplayName
    $WelcomeMessageState = $Group.WelcomeMessageEnabled
    Write-Host "`nGroup Name: " -NoNewline
    Write-host "$GroupName" -ForegroundColor Yellow
    
    Write-Host "Welcome Email Enabled: " -NoNewline
    if ($WelcomeMessageState) {
        Write-Host "$WelcomeMessageState" -ForegroundColor Green
    } else {
        Write-Host "$WelcomeMessageState" -ForegroundColor Red
    }
}

Write-Host "`n`n"
