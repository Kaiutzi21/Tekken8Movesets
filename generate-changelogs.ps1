Write-Host "Starting changelog generation..." -ForegroundColor Green

Get-ChildItem -Directory | ForEach-Object {
    $folderName = $_.Name
    $folderPath = $_.FullName

    # Prüfen, ob Git-Commits zu diesem Ordner existieren
    $log = git log --pretty=format:"- %ad | %s" --date=short -- "$folderName" 2>$null

    if ($log) {
        Write-Host "📂 Generating CHANGELOG.md for $folderName..." -ForegroundColor Green
        $log | Out-File -Encoding UTF8 -FilePath "$folderPath\CHANGELOG.md"
    } else {
        Write-Host "⚠️ No Git-Log found for $folderName (skipping)" -ForegroundColor Yellow
    }
}

Write-Host "✅ All changelogs were updated!" -ForegroundColor Green