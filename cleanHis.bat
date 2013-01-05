@echo off
set TARGETDIR=target

echo "clean log files..."
del /s /q *.log

echo "clean dcu files..."
del /s /q *.dcu

echo "clean  history files..."
del /s /q *.~*
del /s /q *.local
del /s /q *.identcache
del /s /q *.drc
del /s /q *.map


echo "clean temp files finish..."
pause