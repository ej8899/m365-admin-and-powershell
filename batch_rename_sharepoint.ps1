#
# rename vehicle daily inspections
#


# Configuration
$SiteURL = "https://COMPANY.sharepoint.com/sites/COMPANY"
$LibraryName = "Shared Documents"

$VehicleID = "1002-CB22999"

$FolderPath = "Shared Documents/Equipment & Vehicle/COMPANY Fleet/$VehicleID/Daily Inspections"
$NewPrefixBase = "Company Vehicle Daily Inspection Form-$VehicleID"


# Options
$DryRun = $false  # Set to $false to apply renames
$LogFile = "rename-log-$VehicleID-{0}.txt" -f (Get-Date -Format "yyyyMMdd")


"Log started on $(Get-Date)" | Out-File $LogFile


# Connect to SharePoint Online
Connect-PnPOnline -Url $SiteURL -UseWebLogin

# Get all files in the target folder only
$Files = Get-PnPFolderItem -FolderSiteRelativeUrl $FolderPath -ItemType File

$Counter = 0

# Display target folder info
$PrePath = "Working in SharePoint folder: Equipment & Vehicle/BNAOM Fleet/"
$PostPath = "/Daily Inspections"

Write-Host $PrePath -NoNewline
Write-Host $VehicleID -ForegroundColor Yellow -NoNewline
Write-Host $PostPath

#Write-Host "`nFiles found in folder:" -ForegroundColor Gray
#foreach ($File in $Files) {
#    Write-Host $File.Name -ForegroundColor DarkCyan
#}


foreach ($File in $Files) {
    $FileName = $File.Name
    $FilePath = $File.ServerRelativeUrl

    # if (-not (Test-Path "C:\Temp")) { New-Item -Path "C:\Temp" -ItemType Directory }
    # Get-PnPFile -Url $FilePath -Path "C:\Temp" -FileName "test.pdf" -AsFile

    # Extract date in YYYY-MM-DD from beginning of filename
    if ($FileName -match "^(\d{4}-\d{2}-\d{2})") {
        $DatePart = $matches[1]

        # Extract existing suffix (e.g. "-JR" or "-XX" fallback)
        $Suffix = if ($FileName -match "-([a-zA-Z]{2})\.pdf$") { "-$($matches[1].ToUpper())" } else { "-XX" }

        # Build new filename
        $NewFileName = "$DatePart $NewPrefixBase$Suffix.pdf"


        if ($FileName -ne $NewFileName) {
            $Counter++

            # Colorized console output
            Write-Host "[" -NoNewline
            Write-Host "$Counter" -ForegroundColor Magenta -NoNewline
            Write-Host "] Renaming: " -NoNewline
            Write-Host "$FileName" -ForegroundColor Cyan -NoNewline
            Write-Host " -> " -NoNewline
            Write-Host "$NewFileName" -ForegroundColor Green

            # Log to file
            "[$Counter] $FileName -> $NewFileName" | Out-File $LogFile -Append

            if (-not $DryRun) {
                $NewFilePath = ($FilePath -replace [Regex]::Escape($FileName), $NewFileName)
                Move-PnPFile -SourceUrl $FilePath -TargetUrl $NewFilePath -Force
            } else {
                Write-Host "Dry run - not renaming." -ForegroundColor DarkYellow
            }


        }
    }
}

Write-Host "`nTotal files processed: $Counter"
"Total files processed: $Counter" | Out-File $LogFile -Append
