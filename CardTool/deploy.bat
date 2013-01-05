@echo off
set TARGETDIR=target
set RarPath=C:\Program Files\WinRAR
set PackageName=CardTool.rar
del /s /q %PackageName%
del /s /q %TARGETDIR%
mkdir %TARGETDIR%
mkdir %TARGETDIR%\bin
mkdir %TARGETDIR%\config
mkdir %TARGETDIR%\doc
mkdir %TARGETDIR%\print
mkdir %TARGETDIR%\import
mkdir %TARGETDIR%\dll
copy bin\*.* %TARGETDIR%\bin
copy config\*.* %TARGETDIR%\config
copy doc\*.* %TARGETDIR%\doc
copy import\*.* %TARGETDIR%\import
copy print\*.* %TARGETDIR%\print
copy dll\*.* %TARGETDIR%\dll
"%RarPath%\rar.exe" a -ep1 %PackageName% %TARGETDIR%
echo "package finish..."
pause