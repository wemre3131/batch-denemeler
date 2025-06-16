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
echo Setting Cloudflare DNS...
echo.
netsh interface ipv4 set dns name="Dedicated Ethernet" static 1.1.1.1 primary validate=no
if errorlevel 1 goto dnsError
netsh interface ipv4 add dns name="Dedicated Ethernet" 1.0.0.1 index=2 validate=no
if errorlevel 1 goto dnsError

echo ✅ Success! DNS set to:
echo     Primary: 1.1.1.1
echo     Secondary: 1.0.0.1
pause
goto menu

:dnsError
echo ❌ ERROR: Failed to set DNS
echo.
echo SOLUTION:
echo 1. Right-click the script and select "Run as administrator"
echo 2. Make sure your interface is named exactly "Dedicated Ethernet"
echo 3. Check your connection is active
echo.
pause
goto menu

:cleardns
echo Resetting DNS to automatic (DHCP)...
netsh interface ipv4 set dns name="Dedicated Ethernet" dhcp
if errorlevel 1 (
    echo ❌ ERROR: Failed to reset DNS
) else (
    echo ✅ Success! DNS reset to automatic
)
pause
goto menu
