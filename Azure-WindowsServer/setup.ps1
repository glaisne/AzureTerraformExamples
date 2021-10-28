
# update packageManager
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-Module -Name PackageManagement -Force -Scope AllUsers -AllowClobber -Repository PSGallery -Confirm:$false

# Install chocolaty
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# install VSCode
find-script install-vscode | save-script -Path $env:userprofile\desktop\
start-sleep -s 3
&$env:userprofile\desktop\install-vscode.ps1 -Architecture '64-bit' -EnableContextMenus

# install FireFox
$source = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
$destination = "c:\temp\firefox.exe"
Invoke-WebRequest $source -OutFile $destination
start-sleep -s 3
Start-Process -FilePath "c:\temp\firefox.exe" -ArgumentList "/S"

