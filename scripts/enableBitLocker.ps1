function Enable-BitLockerTPM {

    # Get BitLocker status on the C: drive
    $bitLockerStatus = Get-BitLockerVolume -MountPoint "C:"

    # Check if BitLocker is in "Waiting for Activation" state or not fully encrypted
    if ($bitLockerStatus.ProtectionStatus -eq "Off" -and $bitLockerStatus.VolumeStatus -eq "FullyEncrypted" -and $bitLockerStatus.LockStatus -eq "Unlocked") {
        # This means BitLocker is waiting for activation (no key protector added yet)
        Write-Host "BitLocker is waiting for activation. Adding key protector and starting encryption."
        
        # Resume BitLocker
        Resume-BitLocker -MountPoint C:

        # Add TPM Protector and Recovery Password Protector
        Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector

        Write-Host "BitLocker is being activated and encryption has started on the C: drive."
    }
    elseif ($bitLockerStatus.VolumeStatus -ne "FullyEncrypted" -and $bitLockerStatus.VolumeStatus -ne "EncryptionInProgress" -and $bitLockerStatus.VolumeStatus -ne "PendingEncryption") {
        # If BitLocker is not enabled or in progress, enable it
        Write-Host "BitLocker is not fully enabled. Enabling BitLocker on the C: drive."
        
        Enable-BitLocker -MountPoint "C:" -TpmProtector -SkipHardwareTest
        Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector
        Write-Host "BitLocker is being enabled on the C: drive with TPM unlock."
    }
    else {
        Write-Host "BitLocker is already enabled on the C: drive."
    }
}


(Get-BitLockerVolume -MountPoint C).KeyProtector