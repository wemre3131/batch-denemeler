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
echo Setting Cloudflare DNS for Ethernet interface...
netsh interface ipv4 set dns name="Ethernet" static 1.1.1.1 primary
if errorlevel 1 goto dnsError
netsh interface ipv4 add dns name="Ethernet" 1.0.0.1 index=2
if errorlevel 1 goto dnsError

echo ✅ DNS settings updated successfully
pause
goto menu

:dnsError
echo ❌ ERROR: Failed to set DNS
echo Please try these steps:
echo 1. Right-click and Run as Administrator
echo 2. Verify interface name is "Ethernet"
pause
goto menu

:cleardns
echo Resetting DNS to DHCP...
netsh interface ipv4 set dns name="Ethernet" dhcp
if errorlevel 1 (
    echo ❌ ERROR: Failed to reset DNS
) else (
    echo ✅ DNS reset successfully
)
pause
goto menu
