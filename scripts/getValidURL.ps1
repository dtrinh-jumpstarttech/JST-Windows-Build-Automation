Add-Type -AssemblyName System.Windows.Forms

function Get-ValidURL {
    param (
        [string]$Prompt = "Please enter the Automate URL:",
        [string]$Title = "Automate Installation"
    )

    # Create a new form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size(400, 200)
    $form.StartPosition = "CenterScreen"

    # Create label for the prompt
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Prompt
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10, 20)
    $form.Controls.Add($label)

    # Create a textbox for user input
    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Size = New-Object System.Drawing.Size(350, 20)
    $textbox.Location = New-Object System.Drawing.Point(10, 50)
    $form.Controls.Add($textbox)

    # Create an "OK" button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(190, 100)
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Controls.Add($okButton)

    # Create a "Skip" button
    $skipButton = New-Object System.Windows.Forms.Button
    $skipButton.Text = "Skip"
    $skipButton.Location = New-Object System.Drawing.Point(270, 100)
    $skipButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.Controls.Add($skipButton)

    # Set the form's Accept and Cancel buttons
    $form.AcceptButton = $okButton
    $form.CancelButton = $skipButton

    # Event to handle the TextChanged event of the textbox
    $textbox.Add_TextChanged({
        if ($textbox.Text.Length -ge 5) {
            $okButton.Enabled = $true
        } else {
            $okButton.Enabled = $false
        }
    })

    # Show the form and collect the result
    $dialogResult = $form.ShowDialog()

    # Return results based on the button clicked
    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK -and -not [string]::IsNullOrWhiteSpace($textbox.Text)) {
        return $textbox.Text  # Return the entered URL
    } elseif ($dialogResult -eq [System.Windows.Forms.DialogResult]::Cancel) {
        return $null  # Indicate the user chose to skip
    } else {
        return $null  # No valid URL entered, user closed the form
    }
}