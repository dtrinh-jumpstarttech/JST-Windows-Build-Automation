function Install-FromURL {
    param (
        [string]$install_url,
        [string]$destination_path = "C:\Software\Install_Package.msi"
    )

    # Check if the URL is not null and not empty
    if (-not [string]::IsNullOrEmpty($install_url)) {
        if ($install_url -eq "SKIP") {
            Write-Host "Installation skipped by the user."
        }
        else {
            Write-Host "You entered a valid URL: $install_url"
            # Attempt to download and install the package
            try {
                # Ensure the directory exists
                if (-not (Test-Path -Path (Split-Path $destination_path))) {
                    New-Item -ItemType Directory -Path (Split-Path $destination_path) | Out-Null
                }

                # Download the file
                Write-Host "Downloading the installer from $install_url..."
                wget -O $destination_path $install_url
                Write-Host "Download completed successfully." -ForegroundColor Green

                # Install the downloaded package
                Write-Host "Starting installation from $destination_path..."
                Start-Process msiexec "/i $destination_path /qn" -Wait
                Write-Host "Installation completed successfully." -ForegroundColor Green
            }
            catch {
                Write-Host "Failed to download or install the file. Please check your network or the URL." -ForegroundColor Red
            }        
        }
    }
    else {
        Write-Host "No URL entered. Exiting the installation."
    }
}