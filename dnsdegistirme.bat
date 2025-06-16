@echo off
setlocal enabledelayedexpansion
title DNS Ayar Menüsü - DNS Setup Menu

:menu
cls
echo ================================
echo        DNS MENU (TR/EN)
echo ================================
echo (1) Cloudflare DNS ayarla / Set Cloudflare DNS (1.1.1.1)
echo (2) Varsayilana cek / Reset to automatic (DHCP)
echo (3) Cikis / Exit
echo.
set /p choice=Seciminizi girin / Enter your choice (1-3): 

if "%choice%"=="1" goto setdns
if "%choice%"=="2" goto cleardns
if "%choice%"=="3" exit
goto menu

:: Improved interface detection function
:findinterface
set "activeInterface="
for /f "tokens=2 delims=:" %%a in ('netsh interface show interface ^| findstr "Connected"') do (
    for /f "tokens=*" %%b in ("%%a") do set "activeInterface=%%b"
)
goto :eof

:setdns
call :findinterface

echo.
if "!activeInterface!"=="" (
    echo [TEST] Aktif ağ arayüzü bulunamadı / No active interface detected
    echo HATA / ERROR: Aktif bağlantı bulunamadı! / No active connection found!
    pause
    goto menu
)

echo [TEST] Tespit edilen aktif ağ arayüzü / Detected active network interface: '!activeInterface!'
echo Cloudflare DNS ayarlanıyor / Setting Cloudflare DNS...
netsh interface ip set dns name="!activeInterface!" static 1.1.1.1
if errorlevel 1 goto dnsError
netsh interface ip add dns name="!activeInterface!" 1.0.0.1 index=2
if errorlevel 1 goto dnsError

echo ✅ Tamamlandı / Done.
pause
goto menu

:dnsError
echo ❌ HATA / ERROR: DNS ayarlanamadı / Failed to set DNS
echo Arayüz adı / Interface name: '!activeInterface!'
pause
goto menu

:cleardns
call :findinterface

echo.
if "!activeInterface!"=="" (
    echo [TEST] Aktif ağ arayüzü bulunamadı / No active interface detected
    echo HATA / ERROR: Aktif bağlantı bulunamadı! / No active connection found!
    pause
    goto menu
)

echo [TEST] Tespit edilen aktif ağ arayüzü / Detected active network interface: '!activeInterface!'
echo DNS ayarları varsayılan olarak sıfırlanıyor / Resetting DNS to automatic...
netsh interface ip set dns name="!activeInterface!" dhcp
if errorlevel 1 (
    echo ❌ HATA / ERROR: DNS sıfırlanamadı / Failed to reset DNS
) else (
    echo ✅ Tamamlandı / Done.
)
pause
goto menu
