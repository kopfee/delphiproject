@echo off
set str0=abcdefghijklmnopqrstuvwxyz0123456789
:re
set /p str1="please input a new project name :"
echo %str1%|findstr "[^^%str0%]">nul&&(echo 请重新输入&goto :re)
rem echo %str1%
mkdir %str1%

mkdir %str1%\bin
mkdir %str1%\dcu
mkdir %str1%\doc
mkdir %str1%\src
mkdir %str1%\dll
mkdir %str1%\log
mkdir %str1%\config