Write-Host "Starting changelog generation..." -ForegroundColor Green

Get-ChildItem -Directory | ForEach-Object {
    $folderName = $_.Name
    $folderPath = $_.FullName
    $changelogPath = "$folderPath\CHANGELOG.md"

    # JSON-Dateien im aktuellen Ordner (rekursiv)
    $jsonFiles = Get-ChildItem -Path $folderPath -Filter *.json -Recurse -File

    if (-not $jsonFiles) {
        Write-Host "${folderName}: No JSON files found (skipping...)" -ForegroundColor Gray
        return
    }

    # Letzter Commit mit CHANGELOG.md
    $lastChangelogCommit = git log -n 1 --format="%H" -- "$changelogPath" 2>$null

    $jsonChanged = $false
    foreach ($json in $jsonFiles) {
        $changed = git log --since=$lastChangelogCommit --format="%H" -- "$($json.FullName)" 2>$null
        if ($changed) {
            $jsonChanged = $true
            break
        }
    }

    if (-not $jsonChanged -and $lastChangelogCommit) {
        Write-Host "${folderName}: No JSON changes since last changelog (skipping...)" -ForegroundColor Gray
        return
    }

    # Git Log generieren
    $log = git log --pretty=format:"## %h - %s`n%b`n" -- "$folderName" 2>$null

    if (-not $log) {
        Write-Host "No changes for $folderName (skipping...)" -ForegroundColor Yellow
        return
    }

    $logText = $log -join "`n"

    if (Test-Path $changelogPath) {
        $existingContent = Get-Content $changelogPath -Raw
        if ($existingContent -eq $logText) {
            Write-Host "{$folderName}: CHANGELOG.md is up to date (skipping...)" -ForegroundColor DarkYellow
            return
        }
    }

    Write-Host "Updating CHANGELOG.md for $folderName..." -ForegroundColor Green
    $logText | Out-File -Encoding UTF8 -FilePath $changelogPath
}

Write-Host "Changelog generation complete!" -ForegroundColor Green