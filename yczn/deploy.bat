@echo off
set TARGETDIR=target
set RarPath=C:\Program Files\WinRAR
set PackageName=yczn.rar
del /s /q %PackageName%
del /s /q %TARGETDIR%
mkdir %TARGETDIR%
mkdir %TARGETDIR%\bin
mkdir %TARGETDIR%\config
mkdir %TARGETDIR%\third
mkdir %TARGETDIR%\doc
copy bin\* %TARGETDIR%\bin
copy config\device-default.ini %TARGETDIR%\config\device.ini
xcopy/s third\*.* %TARGETDIR%\third
copy doc\install.txt %TARGETDIR%\doc

"%RarPath%\rar.exe" a -ep1 %PackageName% %TARGETDIR%
echo "package finish..."
pause