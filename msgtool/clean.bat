@echo off
set TARGETDIR=target
set PackageName=photo2012.rar
del /s /q %PackageName%
del /s /q %TARGETDIR%
for %%i in (%TARGETDIR%) do del /s/q %%i & rd /s/q %%i

echo "clean bin/  files..."
del /s /q bin\*.log
del /s /q bin\*.exe

echo "clean dcu/  files..."
del /s /q dcu\*.*

echo "clean src/ history files..."
del /s /q src\*.~*

echo "clean temp files finish..."
pause