$ROOT = "C:\Software\"

# Run the following:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Import Dependencies
# Dot Sourcing: Imports contents of a script into the current script to bring functions in.
. scripts\getUserInput.ps1
. scripts\getValidURL.ps1
. scripts\runInstall.ps1
. scripts\enableBitLocker.ps1
. scripts\showBitLockerKey.ps1
. scripts\showCustomDialog.ps1

# Ask the user for the following.
# 1] Rename the Computer
# Load the necessary assembly for Windows Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# Initialize the value as an empty string
$computer_name = Get-UserInput -Prompt "Enter the desired computer name: " -Title "Renaming Computer"

# Show the user what they entered
Write-Host "You entered: $computer_name"

mkdir $ROOT -ErrorAction SilentlyContinue

# 2] Install Automate
$automate_install_location = $ROOT + "Automate\"
mkdir $automate_install_location -ErrorAction SilentlyContinue

$automate_url = Get-ValidURL -Prompt "Log into Automate on the Web and Copy the Automate Installer URL: " -Title "Installing Automate"

$output = $automate_install_location + "automate-installer.zip"

wget $automate_url -O $output
Expand-Archive -Path $output -DestinationPath $automate_install_location
cd $automate_install_location
Write-Output "Installing Automate..."
msiexec /quiet /i "Agent_Install.msi" TRANSFORMS="Agent_Install.mst" -Wait
Write-Output "Installing Automate... done."


# 3] Install Sophos
$sophos_url = Get-ValidURL -Prompt "Enter Sophos URL: " -Title "Installing Sophos"

$output = $ROOT + "sophos_installer.exe"

Write-Output "Installing Sophos..."
wget $sophos_url -O $output
Start-Process -FilePath $output

# 4] Enable BitLocker
Enable-BitLockerTPM

# 5] Show BitLocker Key for user to copy
$bitLockerVolume = Get-BitLockerVolume -MountPoint C
$recoveryKeyID = $bitLockerVolume.KeyProtector.KeyProtectorId[0]
$recoveryKeyProtector = $bitLockerVolume.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' } | Select-Object -ExpandProperty RecoveryPassword
Show-CustomDialog -Title "BitLocker Key" -Dialog "Please copy the following BITLOCKER KEY into configurations." -TextToCopy "Recovery Key ID: $recoveryKeyID / Recovery Key PW: $recoveryKeyProtector" -CheckboxText "I have copied this into ConnectWise."


# 6] Software Deployment for Chrome, 7Zip, Google Drive, and Zoom using Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install googlechrome -y
choco install zoom -y
choco install adobereader -y
choco install 7zip -y

# 6] Jump Start Admin Account
net user jstadmin /add
$password = (wget https://www.dinopass.com/password/strong).Content
net user jstadmin $password




Show-CustomDialog -Title "JSTAdmin PW" -Dialog "Please copy the following password into configurations." -TextToCopy "JSTAdmin PW: $password" -CheckboxText "I have copied this into ConnectWise."

# 8] Runs Windows Updates and Driver Updates
.\scripts\TriggerWindowsUpdate.ps1

# 9] Reboot Machine
shutdown.exe /r /t 120 /c "The system will restart in 2 minutes. Please save your work." /f