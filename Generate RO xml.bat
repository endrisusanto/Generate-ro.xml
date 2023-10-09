@echo off
setlocal enabledelayedexpansion

rem Menjalankan perintah adb shell dan menangkap hasilnya ke dalam variabel
for /f %%i in ('adb shell getprop ro.build.fingerprint') do (
  set "fingerprint=%%i"
)
rem Menjalankan perintah adb shell dan menangkap hasilnya ke dalam variabel
for /f %%i in ('adb shell getprop ro.build.version.base_os') do (
  set "base_os=%%i"
)
rem Menjalankan perintah adb shell dan menangkap hasilnya ke dalam variabel
for /f %%i in ('adb shell getprop ro.build.version.security_patch') do (
  set "security_patchs=%%i"
)
rem Menjalankan perintah adb shell dan menangkap hasilnya ke dalam variabel
for /f %%i in ('adb shell getprop ro.build.PDA') do (
  set "buildPDA=%%i"
)
rem Menjalankan perintah adb shell dan menangkap hasilnya ke dalam variabel
for /f %%i in ('adb shell getprop ril.sw_ver') do (
  set "sw_ver=%%i"
)
rem Menjalankan perintah adb shell dan menangkap hasilnya ke dalam variabel
for /f %%i in ('adb shell getprop ril.official_cscver') do (
  set "official_cscver=%%i"
)
rem Menjalankan perintah adb shell dan menangkap hasilnya ke dalam variabel
for /f %%i in ('adb shell getprop ro.product.first_api_level') do (
  set "first_api_level=%%i"
)
rem Menjalankan perintah adb shell dan menangkap hasilnya ke dalam variabel
for /f %%i in ('adb shell getprop ro.sts.property') do (
  set "sts.property=%%i"
)

rem Membuat direktori dengan nama dari variabel buildPDA
set "targetFolder=Results\!buildPDA!"
set "counter=1"

:CheckFolderExistence
if exist "!targetFolder!" (
  set "targetFolder=Results\!buildPDA!_!counter!"
  set /A "counter+=1"
  goto CheckFolderExistence
)

mkdir "!targetFolder!"

rem Menampilkan loading progress
set "loadingProgress=>"
for /l %%A in (1,1,10) do (
  set "loadingProgress=!loadingProgress!>"
  echo Loading!loadingProgress!
  ping -n 2 127.0.0.1 > nul
  cls
)

rem Menyimpan string fingerprint ke dalam file XML
(
  echo ^<RO^>
  echo   ^<ro.build.fingerprint^>!fingerprint!^</ro.build.fingerprint^>
  echo   ^<ro.build.version.base_os^>!base_os!^</ro.build.version.base_os^>
  echo   ^<ro.build.version.security_patch^>!security_patchs!^</ro.build.version.security_patch^>
  echo   ^<ro.build.PDA^>!buildPDA!^</ro.build.PDA^>
  echo   ^<ril.sw_ver^>!sw_ver!^</ril.sw_ver^>
  echo   ^<ril.official_cscver^>!official_cscver!^</ril.official_cscver^>
  echo   ^<ro.product.first_api_level^>!first_api_level!^</ro.product.first_api_level^>
  echo   ^<ro.sts.property^>!sts.property!^</ro.sts.property^>
  echo ^</RO^>
) > "!targetFolder!\ro.xml"

echo ==============================================
echo ========== Tabel Informasi Perangkat ==========
echo ==============================================
echo [Informasi] ^| [Nilai]
echo ----------------------------------------------
echo Fingerprint ^| !fingerprint!
echo Base OS ^| !base_os!
echo Security Patch ^| !security_patchs!
echo AP Version ^| !buildPDA!
echo CP Version ^| !sw_ver!
echo CSC Version ^| !official_cscver!
echo First API Level ^| !first_api_level!
echo STS property State ^| !sts.property!
echo ==============================================

echo RO.xml File berhasil disimpan di "!targetFolder!"

endlocal

pause
