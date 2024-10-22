@echo off
:: Check if running as admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c, %~dpnx0' -WorkingDirectory '%~dp0' -Verb runAs"
    exit /b
)

:: Set the script directory dynamically (the same location as the .bat file)
set scriptDir=%~dp0

:: Run the PowerShell script with RemoteSigned execution policy
powershell -NoExit -ExecutionPolicy Bypass -File "%scriptDir%master.ps1"
