@echo off
title System Utility Launcher v26.1
color 0A

cls
echo ==========================================
echo        🚀 SYSTEM UTILITY LAUNCHER 🚀
echo              Version 26.1
echo ==========================================
echo.
echo [*] Navigating to Downloads folder...
cd /d C:\Users\{Username}\Downloads

timeout /t 1 >nul
echo [*] Initializing PowerShell script...
echo.

powershell -ExecutionPolicy Bypass -NoProfile -File "SU.v26.1.ps1"

echo.
echo [✓] Script execution finished.
pause

