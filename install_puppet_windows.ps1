# install_puppet_windows.ps1

Write-Output "[INFO] Starting Puppet installation..."

$puppetMsiUrl = "https://downloads.puppet.com/windows/puppet7/puppet-agent-x64-latest.msi"
$msiPath = "$env:TEMP\puppet-agent-x64-latest.msi"

# Download Puppet MSI
Invoke-WebRequest -Uri $puppetMsiUrl -OutFile $msiPath

# Install silently
Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /qn" -Wait

# Verify install
$puppetPath = "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat"
if (Test-Path $puppetPath) {
    & $puppetPath --version
    Write-Output "[SUCCESS] Puppet installed."
} else {
    Write-Output "[ERROR] Puppet installation failed."
    exit 1
}
