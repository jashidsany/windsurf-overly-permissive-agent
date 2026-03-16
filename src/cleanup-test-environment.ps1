# cleanup-test-environment.ps1
# Removes all test files created during overly permissive agent testing.

Write-Host "[*] Cleaning up test environment..." -ForegroundColor Cyan

$filesToRemove = @(
    "$HOME\Desktop\cascade-was-here.txt",
    "$HOME\Desktop\decoy-sensitive.txt",
    "$HOME\Desktop\decoy-config.env",
    "$HOME\Desktop\persistence-proof.txt",
    "$HOME\.aws\credentials",
    "$HOME\.ssh\config",
    "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\update.bat"
)

foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        Remove-Item $file -Force
        Write-Host "[+] Removed $file" -ForegroundColor Green
    } else {
        Write-Host "[-] $file not found, skipping" -ForegroundColor Yellow
    }
}

# Clean up workspace
$workspace = "$HOME\Desktop\windsurf-permissions-test"
if (Test-Path $workspace) {
    Remove-Item $workspace -Recurse -Force
    Write-Host "[+] Removed workspace $workspace" -ForegroundColor Green
}

# Revert hosts file if modified
$hostsFile = "C:\Windows\System32\drivers\etc\hosts"
$hostsContent = Get-Content $hostsFile
$modified = $false
$cleanContent = $hostsContent | Where-Object { $_ -notmatch "dev\.local" }
if ($cleanContent.Count -ne $hostsContent.Count) {
    try {
        $cleanContent | Set-Content $hostsFile -ErrorAction Stop
        Write-Host "[+] Removed dev.local entry from hosts file" -ForegroundColor Green
    } catch {
        Write-Host "[!] Could not clean hosts file (may need admin): $_" -ForegroundColor Red
    }
}

Write-Host "`n[*] Cleanup complete." -ForegroundColor Cyan
