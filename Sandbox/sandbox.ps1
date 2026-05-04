<#
.SYNOPSIS
    Automated initialization script for Windows Sandbox.
.DESCRIPTION
    This script applies developer-friendly UI tweaks, locates or downloads 
    the portable version of VS Code, extracts it safely to the local VM drive, 
    creates a desktop shortcut, and launches the IDE mapped to your shared folder.
#>

# ==============================================================================
# 1. ZERO-TRUST ENVIRONMENT CHECK
# ==============================================================================
# This ensures the script instantly terminates if you accidentally run it on 
# your main Host PC. It will ONLY execute inside the Windows Sandbox user account.
if ($env:USERNAME -ne "WDAGUtilityAccount") { 
    Write-Host "This script must be run inside Windows Sandbox." -ForegroundColor Red
    exit 
}

# ==============================================================================
# 2. DEVELOPER QUALITY OF LIFE (UI TWEAKS)
# ==============================================================================
# Show hidden files and file extensions (Crucial for spotting malicious files)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f | Out-Null
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f | Out-Null

# Enable Windows Clipboard History (Win + V)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Clipboard" -Name "EnableClipboardHistory" -Value 1 -Type DWord -Force | Out-Null

# Add 'Open PowerShell Here' to the right-click context menu
$powershellPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\MyPowerShell" /ve /d "Open PowerShell Here" /f | Out-Null
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\MyPowerShell\command" /ve /d "powershell.exe -noexit -command Set-Location -literalPath '%V'" /f | Out-Null

# Restart Windows Explorer immediately to apply all UI tweaks without a reboot
Stop-Process -Name explorer -Force

# ==============================================================================
# 3. DYNAMIC PORTABLE VS CODE INSTALLATION
# ==============================================================================
try {
    # Define paths. $sandboxDir is where your host files are mounted.
    $sandboxDir = "C:\Users\WDAGUtilityAccount\Desktop\Sandbox"
    
    # We extract to the root C:\ drive of the VM to avoid Hyper-V share locks
    $destPath = "C:\VSCode"

    # Step A: Look for any pre-downloaded VS Code ZIP in the shared folder
    # Example: "VSCode-win32-x64-1.118.1.zip"
    $existingZip = Get-ChildItem -Path $sandboxDir -Filter "VSCode-win32-*.zip" | Select-Object -First 1

    # Step B: Check if the file exists and isn't a corrupted 0-byte file (must be > 50MB)
    if ($existingZip -and $existingZip.Length -gt 50MB) {
        $vscodeZip = $existingZip.FullName
        Write-Host "Found local VS Code ZIP: $($existingZip.Name)" -ForegroundColor Cyan
    } else {
        # Step C: Fallback. If no ZIP is found, download the latest stable release from Microsoft.
        Write-Host "Local ZIP not found. Downloading latest portable release..." -ForegroundColor Yellow
        $vscodeZip = "$sandboxDir\vscode-latest.zip"
        
        # Force TLS 1.2 to ensure the download doesn't fail due to outdated security protocols
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive' -OutFile $vscodeZip -UseBasicParsing
    }

    # Step D: Strip the "Mark of the Web" security tag so Windows allows extraction
    Write-Host "Unblocking ZIP file..." -ForegroundColor Cyan
    Unblock-File -Path $vscodeZip

    # Step E: Extract the archive
    Write-Host "Extracting VS Code (This might take a minute)..." -ForegroundColor Cyan
    # Clear the destination folder if a previous extraction got stuck
    if (Test-Path $destPath) { Remove-Item -Path $destPath -Recurse -Force }
    Expand-Archive -Path $vscodeZip -DestinationPath $destPath -Force

    # ==============================================================================
    # 4. CREATE DESKTOP SHORTCUT & LAUNCH
    # ==============================================================================
    Write-Host "Creating Desktop Shortcut..." -ForegroundColor Cyan
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("C:\Users\WDAGUtilityAccount\Desktop\VS Code.lnk")
    $Shortcut.TargetPath = "$destPath\Code.exe"
    $Shortcut.IconLocation = "$destPath\Code.exe"
    $Shortcut.Save()

    # Launch the IDE and open the mapped project folder automatically
    Write-Host "Success! Launching IDE..." -ForegroundColor Green
    & "$destPath\Code.exe" $sandboxDir

} catch {
    # If anything breaks, freeze the terminal and print the exact error
    Write-Host "`n========================================" -ForegroundColor Red
    Write-Host "CRITICAL ERROR DURING INSTALLATION:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "========================================`n" -ForegroundColor Red
    Read-Host "Press Enter to exit so you can read this error..."
}