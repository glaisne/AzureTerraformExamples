
# update packageManager
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PackageManagement -Force -Scope AllUsers -AllowClobber -Repository PSGallery -Confirm:$false

# Install chocolaty
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# install Azure CLI
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile ".\AzureCLI.msi"
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
rm ".\AzureCLI.msi"

# install SSH
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*' | % {Add-WindowsCapability -Online -Name $_.name}
   # Start the sshd service
Start-Service sshd
   # OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'
   # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}

# install python
choco install python3 -y

# Install Powreshell 7
choco install powershell.portable -y

# install VSCode
find-script install-vscode | save-script -Path $env:userprofile\desktop\
start-sleep -s 3
&$env:userprofile\desktop\install-vscode.ps1 -Architecture '64-bit' -EnableContextMenus -AdditionalExtensions 'ms-python.python', 'ms-vscode.vscode-node-azure-pack', 'ms-vscode-remote.vscode-remote-extensionpack'
# https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client


# install FireFox
choco install firefox -y
# $source = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
# $destination = "c:\temp\firefox.exe"
# Invoke-WebRequest $source -OutFile $destination
# start-sleep -s 3
# Start-Process -FilePath "c:\temp\firefox.exe" -ArgumentList "/S"

# install Microsoft Edge
choco install microsoft-edge -y

# Install PowerShell Modules
$modules = @('az', 'Pester')
foreach ($module in $Modules)
{
    install-module $module -Scope AllUsers -Force
}


# this exit code is needed to report success back to terraform
exit 0