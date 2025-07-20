Write-Host "Starting changelog generation..." -ForegroundColor Green

Get-ChildItem -Directory | ForEach-Object {
    $folder = $_.FullName
    $folderName = $_.Name
    $changelogPath = Join-Path $folder "CHANGELOG.md"

    $jsonFiles = Get-ChildItem -Path $folder -Filter *.json -Recurse -File
    if (-not $jsonFiles) {
        Write-Host "No JSON files in $folderName, skipping..." -ForegroundColor Gray
        return
    }

    $lastChangelogCommit = git log -n 1 --format="%H" -- "$changelogPath" 2>$null
    if (-not $lastChangelogCommit) {
        Write-Host "$folderName has no changelog commit yet – will create new one." -ForegroundColor Cyan
    }

    $jsonChanged = $false
    foreach ($json in $jsonFiles) {
        $changed = git log --since="$lastChangelogCommit" --format="%H" -- "$($json.FullName)" 2>$null
        if ($changed) {
            $jsonChanged = $true
            break
        }
    }

    if (-not $jsonChanged -and $lastChangelogCommit) {
        Write-Host "$folderName: No relevant changes since last changelog. Skipping..." -ForegroundColor Gray
        return
    }

    $log = git log --pretty=format:"## %h - %s`n%b`n" -- "$folderName" 2>$null
    if (-not $log) {
        Write-Host "$folderName: No commits found. Skipping..." -ForegroundColor Gray
        return
    }

    $logText = $log -join "`n"

    if (Test-Path $changelogPath) {
        $existingContent = Get-Content $changelogPath -Raw
        if ($existingContent -eq $logText) {
            Write-Host "$folderName: CHANGELOG.md is up to date. Skipping..." -ForegroundColor Gray
            return
        }
    }

    Write-Host "Updating CHANGELOG.md for $folderName..." -ForegroundColor Green
    $logText | Out-File -Encoding UTF8 -FilePath $changelogPath
}

Write-Host "Selective changelog generation complete!" -ForegroundColor Green
