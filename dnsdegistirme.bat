@echo off
setlocal enabledelayedexpansion
title DNS Configuration Menu

:menu
cls
echo ================================
echo        DNS Configuration Menu
echo ================================
echo (1) Set Cloudflare DNS (1.1.1.1)
echo (2) Reset to automatic (DHCP)
echo (3) Exit
echo.
set /p choice=Enter your choice (1-3): 

if "%choice%"=="1" goto setdns
if "%choice%"=="2" goto cleardns
if "%choice%"=="3" exit
goto menu

:setdns
echo Setting Cloudflare DNS for Ethernet...
echo.
netsh interface ipv4 set dns name="Ethernet" static 1.1.1.1 primary
if errorlevel 1 goto dnsError
netsh interface ipv4 add dns name="Ethernet" 1.0.0.1 index=2
if errorlevel 1 goto dnsError

echo ✅ Successfully set DNS to:
echo Primary:   1.1.1.1
echo Secondary: 1.0.0.1
pause
goto menu

:dnsError
echo ❌ ERROR: Failed to configure DNS
echo.
echo TROUBLESHOOTING:
echo 1. MUST run as Administrator (right-click -> Run as administrator)
echo 2. Confirm interface name is "Ethernet" (no quotes)
echo 3. Check network cable/WiFi is connected
echo.
pause
goto menu

:cleardns
echo Resetting Ethernet to DHCP...
netsh interface ipv4 set dns name="Ethernet" dhcp
if errorlevel 1 (
    echo ❌ ERROR: Failed to reset DNS
) else (
    echo ✅ Successfully reset to automatic DNS
)
pause
goto menu
