# inputFunction.ps1

# Load the necessary assembly for Windows Forms
Add-Type -AssemblyName Microsoft.VisualBasic

function Get-UserInput {
    param (
        [string]$Prompt = "Please enter a value:", 
        [string]$Title = "Input Required"
    )

    # Initialize the value as an empty string
    $value = ""

    # Loop until the user enters a non-empty value
    while ([string]::IsNullOrWhiteSpace($value)) {
        # Show the input box
        $value = [Microsoft.VisualBasic.Interaction]::InputBox($Prompt, $Title, "")

        # Check if the input is empty
        if ([string]::IsNullOrWhiteSpace($value)) {
            [System.Windows.Forms.MessageBox]::Show("Input cannot be empty. Please try again.", "Input Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
    }

    # Return the non-empty value
    return $value
}
