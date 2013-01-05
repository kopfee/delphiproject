@echo off
set TARGETDIR=target
set RarPath=C:\Program Files\WinRAR
set PackageName=CrmTool.rar
del /s /q %PackageName%
del /s /q %TARGETDIR%
mkdir %TARGETDIR%
mkdir %TARGETDIR%\bin
mkdir %TARGETDIR%\config
mkdir %TARGETDIR%\doc
mkdir %TARGETDIR%\import

copy bin\*.* %TARGETDIR%\bin
copy config\*.* %TARGETDIR%\config
copy doc\*.* %TARGETDIR%\doc
copy import\*.* %TARGETDIR%\import
"%RarPath%\rar.exe" a -ep1 %PackageName% %TARGETDIR%
echo "package finish..."
pause