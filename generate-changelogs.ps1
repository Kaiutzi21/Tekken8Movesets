Write-Host "Starting changelog generation..." -ForegroundColor Green

Get-ChildItem -Directory | ForEach-Object {
    $folderName = $_.Name
    $folderPath = $_.FullName
    $changelogPath = "$folderPath\CHANGELOG.md"

    $log = git log --pretty=format:"## %h - %sn%bn" -- "$folderName" 2>$null

    if (-not $log) {
        Write-Host "No changes for $folderName (skipping...)" -ForegroundColor Yellow
        return
    }

    $logText = $log -join "n"

    if (Test-Path $changelogPath) {
        $existingContent = Get-Content $changelogPath -Raw

        if ($existingContent -eq $logText) {
		Write-Host "${folderName}: CHANGELOG.md is up to date (skipping...)" -ForegroundColor DarkYellow
            return
        }
    }

    Write-Host "Updating CHANGELOG.md for $folderName..." -ForegroundColor Green
    $logText | Out-File -Encoding UTF8 -FilePath $changelogPath
}

Write-Host "Changelog generation complete!" -ForegroundColor Green