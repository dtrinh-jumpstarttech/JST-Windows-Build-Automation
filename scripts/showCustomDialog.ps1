function Show-CustomDialog {
    param (
        [string]$Title = "Custom Dialog",
        [string]$Dialog = "This is your dialog content.",
        [string]$TextToCopy = "This is the text that you can copy.",
        [string]$CheckboxText = "I have acknowledged the information."
    )

    # Load the required assembly for Windows Forms
    Add-Type -AssemblyName System.Windows.Forms

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size(600, 350)
    $form.StartPosition = "CenterScreen"

    # Create a label for the dialog content
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Dialog
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $label.Size = New-Object System.Drawing.Size(550, 40)
    $label.AutoSize = $true
    $form.Controls.Add($label)

    # Create a textbox to display the text to be copied (readonly)
    $copyTextBox = New-Object System.Windows.Forms.TextBox
    $copyTextBox.Multiline = $true
    $copyTextBox.ReadOnly = $true
    $copyTextBox.Text = $TextToCopy
    $copyTextBox.Size = New-Object System.Drawing.Size(550, 80)
    $copyTextBox.Location = New-Object System.Drawing.Point(10, 70)
    $form.Controls.Add($copyTextBox)

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

    # Create a checkbox for user confirmation
    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $CheckboxText
    $checkBox.AutoSize = $true
    $checkBox.Location = New-Object System.Drawing.Point(10, 200)
    $checkBox.MaximumSize = New-Object System.Drawing.Size(550, 0)
    $form.Controls.Add($checkBox)

    # Create the OK button (Initially disabled)
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Enabled = $false
    $okButton.Location = New-Object System.Drawing.Point(480, 250)
    $form.Controls.Add($okButton)

    # Event handler to enable the OK button when the checkbox is checked
    $checkBox.Add_CheckedChanged({
        if ($checkBox.Checked) {
            $okButton.Enabled = $true
        } else {
            $okButton.Enabled = $false
        }
    })

    # Event handler for OK button click to close the form
    $okButton.Add_Click({
        $form.Close()
    })

    # Show the form as a modal dialog
    $form.ShowDialog()
}

# Example usage of the function
Show-CustomDialog -Title "BitLocker Key" -Dialog "Please copy your BitLocker Recovery Key below." -TextToCopy "XYZ12345-ABC67890-EXAMPLE" -CheckboxText "I have copied this key into ConnectWise Automate"
