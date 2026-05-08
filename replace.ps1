Get-ChildItem -Path lib -Filter *.dart -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '\.withOpacity\(') {
        $newContent = [regex]::Replace($content, '\.withOpacity\(([^)]+)\)', '.withValues(alpha: $1)')
        Set-Content -Path $_.FullName -Value $newContent -NoNewline
        Write-Output "Replaced in $($_.Name)"
    }
}
