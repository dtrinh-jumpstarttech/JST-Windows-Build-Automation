Add-Type -AssemblyName System.Windows.Forms


function Show-BitLockerKey {

    # Retrieve the BitLocker Recovery Key Protector for the C drive
    $bitLockerVolume = Get-BitLockerVolume -MountPoint C
    $recoveryKeyProtector = $bitLockerVolume.KeyProtector | Where-Object { $_.KeyProtectorType -eq 'RecoveryPassword' } | Select-Object -ExpandProperty RecoveryPassword

    if (-not $recoveryKeyProtector) {
        $recoveryKeyProtector = "No Recovery Password found."
    }

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "BitLocker Recovery Key"
    $form.Size = New-Object System.Drawing.Size(500, 300)
    $form.StartPosition = "CenterScreen"

    # Create a label to display the Recovery Key Protector
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "BitLocker Recovery Key Protector. Please copy this. It will not be shown again:"
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.AutoSize = $true
    $form.Controls.Add($label)

    # Create a textbox to display the BitLocker Recovery Key (readonly)
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Multiline = $true
    $textBox.ReadOnly = $true
    $textBox.Text = $recoveryKeyProtector
    $textBox.Size = New-Object System.Drawing.Size(450, 100)
    $textBox.Location = New-Object System.Drawing.Point(10, 50)
    $form.Controls.Add($textBox)

    # Create a checkbox for the user to confirm they have copied the key
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = "I have copied this into ConnectWise Automate"
    $checkBox.AutoSize = $true
    $checkBox.Location = New-Object System.Drawing.Point(10, 170)
    $checkBox.MaximumSize = New-Object System.Drawing.Size(450, 0)  # Maximum width of the checkbox
    $form.Controls.Add($checkBox)

    # Create a "Copy to Clipboard" button
    $copyButton = New-Object System.Windows.Forms.Button
    $copyButton.Text = "Copy to Clipboard"
    $copyButton.Location = New-Object System.Drawing.Point(10, 160)
    $form.Controls.Add($copyButton)
    
    # Event handler to copy text to clipboard
    $copyButton.Add_Click({
            [System.Windows.Forms.Clipboard]::SetText($copyTextBox.Text)
            [System.Windows.Forms.MessageBox]::Show("Text copied to clipboard!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        })

    # Create the OK button (Initially disabled)
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Enabled = $false
    $okButton.Location = New-Object System.Drawing.Point(380, 220)
    $form.Controls.Add($okButton)

    # Event handler to enable the OK button when the checkbox is checked
    $checkBox.Add_CheckedChanged({
            if ($checkBox.Checked) {
                $okButton.Enabled = $true
            }
            else {
                $okButton.Enabled = $false
            }
        })

    # Event handler for OK button click to close the form
    $okButton.Add_Click({
            $form.Close()
        })

    # Show the form
    $form.ShowDialog()
}