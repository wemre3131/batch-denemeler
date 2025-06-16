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

:findinterface
set "activeInterface="
for /f "tokens=3*" %%a in ('netsh interface show interface ^| findstr "Bağlı Connected"') do (
    set "activeInterface=%%a %%b"
    set "activeInterface=!activeInterface:~0,-1!"
    goto :eof
)
goto :eof

:setdns
call :findinterface

echo.
if "!activeInterface!"=="" (
    echo [HATA] Aktif ağ arayüzü bulunamadı / No active interface detected
    pause
    goto menu
)

echo [BILGI] Aktif ağ arayüzü / Active network interface: "!activeInterface!"
echo Cloudflare DNS ayarlanıyor / Setting Cloudflare DNS...

netsh interface ipv4 set dns name="!activeInterface!" static 1.1.1.1 primary validate=no
if errorlevel 1 goto dnsError
netsh interface ipv4 add dns name="!activeInterface!" 1.0.0.1 index=2 validate=no
if errorlevel 1 goto dnsError

echo ✅ DNS ayarları başarıyla güncellendi / DNS settings updated successfully
pause
goto menu

:dnsError
echo ❌ HATA: DNS ayarlanamadı / ERROR: Failed to set DNS
echo Arayüz adı / Interface name: "!activeInterface!"
echo.
echo COZUM / SOLUTION:
echo 1. Scripti Yönetici olarak çalıştırın / Run script as Administrator
echo 2. Arayüz adını kontrol edin / Check interface name
echo 3. Elle ayarlamayı deneyin / Try manual setup: 
echo    netsh interface ipv4 set dns name="Arayuz_Adi" static 1.1.1.1
pause
goto menu

:cleardns
call :findinterface

echo.
if "!activeInterface!"=="" (
    echo [HATA] Aktif ağ arayüzü bulunamadı / No active interface detected
    pause
    goto menu
)

echo [BILGI] Aktif ağ arayüzü / Active network interface: "!activeInterface!"
echo DNS ayarları varsayılana sıfırlanıyor / Resetting DNS to default...

netsh interface ipv4 set dns name="!activeInterface!" dhcp
if errorlevel 1 (
    echo ❌ HATA: DNS sıfırlanamadı / ERROR: Failed to reset DNS
) else (
    echo ✅ DNS ayarları başarıyla sıfırlandı / DNS reset successfully
)
pause
goto menu
