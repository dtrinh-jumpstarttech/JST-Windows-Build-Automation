function Enable-BitLockerTPM {


    # Enable BitLocker
    # Check if BitLocker is already enabled on the C: drive, encryption is in progress, or will be completed.
    $bitLockerStatus = Get-BitLockerVolume -MountPoint "C:"
    if ($bitLockerStatus.VolumeStatus -ne "FullyEncrypted" -and $bitLockerStatus.VolumeStatus -ne "EncryptionInProgress" -and $bitLockerStatus.VolumeStatus -ne "PendingEncryption") {
        # Your code here
        # Enable BitLocker on C: Drive using TPM
        Enable-BitLocker -MountPoint "C:" -TpmProtector -SkipHardwareTest
        Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector
    
        Write-Host "BitLocker is being enabled on the C: drive with TPM unlock."
    }
    else {
        Write-Host "BitLocker is already enabled on the C: drive."
    }
}