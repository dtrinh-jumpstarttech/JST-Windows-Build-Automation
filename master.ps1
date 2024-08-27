# Run the following:
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Import Dependencies
# Dot Sourcing: Imports contents of a script into the current script to bring functions in.
. D:\scripts\getUserInput.ps1
. D:\scripts\getValidURL.ps1
. D:\scripts\runInstall.ps1
. D:\scripts\enableBitLocker.ps1
. D:\scripts\showBitLockerKey.ps1
. D:\scripts\showCustomDialog.ps1

# Ask the user for the following.
# 1] Rename the Computer
# Load the necessary assembly for Windows Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# Initialize the value as an empty string
$computer_name = Get-UserInput -Prompt "Enter the desired computer name: " -Title "Renaming Computer"

# Show the user what they entered
Write-Host "You entered: $computer_name"

mkdir C:\Software -ErrorAction SilentlyContinue

# 2] Install Automate
$automate_url = Get-ValidURL -Prompt "Enter the Automate URL: " -Title "Installing Automate"
Install-FromURL -install_url $automate_url -destination_path "C:\Software\automate_installer.msi"

# 3] Install Sophos
$sophos_url = Get-ValidURL -Prompt "Enter Sophos URL: " -Title "Installing Sophos"
Install-FromURL -install_url $sophos_url -destination_path "C:\Software\sophos_installer.msi"

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
D:\scripts\TriggerWindowsUpdate.ps1

# 9] Reboot Machine
