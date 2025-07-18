Write-Host "Starting changelog generation..." -ForegroundColor Green

Get-ChildItem -Directory | ForEach-Object {
    $folderName = $_.Name
    $folderPath = $_.FullName

    Push-Location $folderPath

    $log = git log --pretty=format:"## %h - %s`n%b`n" -- "$folderPath" 2>$null

    Pop-Location

    if ($log) {
        Write-Host "Generating CHANGELOG.md for $folderName..." -ForegroundColor Green
        $log | Out-File -Encoding UTF8 -FilePath "$folderPath\CHANGELOG.md"
    } else {
        Write-Host "No Git log found for $folderName (skipping)" -ForegroundColor Yellow
    }
}

Write-Host "All changelogs were updated!" -ForegroundColor Green