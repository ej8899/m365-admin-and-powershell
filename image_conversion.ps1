#
#
# Batch image resize and convert
# Requires: ImageMagick installed and 'magick' in PATH -> https://imagemagick.org/index.php
#
# resizes to 2048 in any direction
# applies $logoPath to bottom right
# converts to JPG
# applies quality to 85%
#


# Paths
$folderPath = "C:\Users\ITSupport\OneDrive - COMPANY\Shared Documents - COMPANY Document Library\Disciplines\CAD\Pictures"
$logoPath = "COMPANY_logo.jpg"
$logFile = Join-Path $folderPath "conversion-log.txt"

# Write table-style header
"Filename".PadRight(40) + "Original (KB)".PadLeft(15) + "Converted (KB)".PadLeft(17) + "Reduction (%)".PadLeft(15) | Out-File -FilePath $logFile -Encoding utf8
("-" * 87) | Out-File -FilePath $logFile -Append -Encoding utf8

# Process all HEIC images
Get-ChildItem -Path $folderPath -Filter *.heic | ForEach-Object {
    $inputFile = $_.FullName
    $tempJpg = [System.IO.Path]::ChangeExtension($inputFile, "temp.jpg")
    $outputFile = [System.IO.Path]::ChangeExtension($inputFile, "jpg")

    if (Test-Path $outputFile) {
        Write-Host "Skipping (already converted): $($_.Name)"
        return
    }

    $originalSizeKB = [math]::Round((Get-Item $inputFile).Length / 1KB, 2)

    # Step 1: Convert and resize HEIC to temp JPG
    $resizeCommand = @(
        'magick',
        "`"$inputFile`"",
        '-resize', '2048x2048>',
        '-quality', '85',
        '-strip',
        '-set', 'profile:exif', "`"$inputFile`"",
        "`"$tempJpg`""
    ) -join ' '
    Invoke-Expression $resizeCommand

    # Step 2: Overlay logo with transparency
    if (Test-Path $tempJpg) {
        $compositeCommand = 'magick "' + $tempJpg + '" ( "' + $logoPath + '" -alpha set -channel A -evaluate set 30%% +channel ) -gravity southeast -geometry +10+10 -composite "' + $outputFile + '"'
        cmd.exe /c $compositeCommand

        Remove-Item $tempJpg -Force
    }

    # Step 3: Log file sizes and reduction
    if (Test-Path $outputFile) {
        $convertedSizeKB = [math]::Round((Get-Item $outputFile).Length / 1KB, 2)
        $reduction = [math]::Round((($originalSizeKB - $convertedSizeKB) / $originalSizeKB) * 100, 2)

        ($_.Name.PadRight(40) +
         $originalSizeKB.ToString().PadLeft(15) +
         $convertedSizeKB.ToString().PadLeft(17) +
         $reduction.ToString("0.00").PadLeft(15)) | Out-File -FilePath $logFile -Append -Encoding utf8

        Write-Host "✅ Watermarked: $($_.Name) - $originalSizeKB KB to $convertedSizeKB KB ($reduction% smaller)"
    } else {
        Write-Warning "❌ Conversion failed: $($_.Name)"
    }
}
