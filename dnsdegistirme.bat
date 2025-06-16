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

:: ----- Aktif arayüzü bulma fonksiyonu -----
:findinterface
set "activeInterface="
for /f "tokens=1,*" %%a in ('netsh interface show interface ^| findstr /C:"Bağlandı" /C:"Connected"') do (
    set activeInterface=%%b
)
set "activeInterface=!activeInterface:~1!"
goto :eof

:setdns
call :findinterface

echo.
echo [TEST] Tespit edilen aktif ag arayuzu / Detected active network interface: '!activeInterface!'

if "!activeInterface!"=="" (
    echo HATA / ERROR: Aktif baglanti bulunamadi! / No active connection found!
    pause
    goto menu
)

echo Cloudflare DNS ayarlaniyor / Setting Cloudflare DNS...
netsh interface ip set dns name="!activeInterface!" static 1.1.1.1
netsh interface ip add dns name="!activeInterface!" 1.0.0.1 index=2

if errorlevel 1 (
    echo ❌ HATA / ERROR: DNS ayarlanamadi. Muhtemelen arayuz adi gecersiz.
) else (
    echo ✅ Tamamlandi / Done.
)

pause
goto menu

:cleardns
call :findinterface

echo.
echo [TEST] Tespit edilen aktif ag arayuzu / Detected active network interface: '!activeInterface!'

if "!activeInterface!"=="" (
    echo HATA / ERROR: Aktif baglanti bulunamadi! / No active connection found!
    pause
    goto menu
)

echo DNS ayarlari varsayilana donuluyor / Resetting DNS to automatic...
netsh interface ip set dns name="!activeInterface!" dhcp

if errorlevel 1 (
    echo ❌ HATA / ERROR: DNS sifirlanamadi.
) else (
    echo ✅ Tamamlandi / Done.
)

pause
goto menu
