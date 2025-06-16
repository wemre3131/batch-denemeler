@echo off
setlocal enabledelayedexpansion
title DNS Configuration Menu - DNS Setup Menu

:menu
cls
echo ================================
echo        DNS MENU (TR/EN)
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

:findinterface
set "activeInterface="
for /f "tokens=3*" %%a in ('netsh interface show interface ^| findstr "Connected"') do (
    set "activeInterface=%%a %%b"
    set "activeInterface=!activeInterface:~0,-1!"
    goto :eof
)
goto :eof

:setdns
call :findinterface

echo.
if "!activeInterface!"=="" (
    echo [ERROR] No active network interface detected
    pause
    goto menu
)

echo [INFO] Active network interface: "!activeInterface!"
echo Setting Cloudflare DNS...

netsh interface ipv4 set dns name="!activeInterface!" static 1.1.1.1 primary validate=no
if errorlevel 1 goto dnsError
netsh interface ipv4 add dns name="!activeInterface!" 1.0.0.1 index=2 validate=no
if errorlevel 1 goto dnsError

echo ✅ DNS settings updated successfully
pause
goto menu

:dnsError
echo ❌ ERROR: Failed to set DNS
echo Interface name: "!activeInterface!"
echo.
echo TROUBLESHOOTING:
echo 1. Run script as Administrator
echo 2. Verify your interface name
echo 3. Try manual setup with:
echo    netsh interface ipv4 set dns name="Interface_Name" static 1.1.1.1
pause
goto menu

:cleardns
call :findinterface

echo.
if "!activeInterface!"=="" (
    echo [ERROR] No active network interface detected
    pause
    goto menu
)

echo [INFO] Active network interface: "!activeInterface!"
echo Resetting DNS to default...

netsh interface ipv4 set dns name="!activeInterface!" dhcp
if errorlevel 1 (
    echo ❌ ERROR: Failed to reset DNS
) else (
    echo ✅ DNS reset successfully
)
pause
goto menu
