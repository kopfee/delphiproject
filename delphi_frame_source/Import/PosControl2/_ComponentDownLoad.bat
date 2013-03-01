@ECHO OFF
ECHO WARNING: Your POS Fundamental-Dev-Environment in Current Directory will be refreshed with SourceDir unconditionally. (*.dpr, main.* not included)
set sourcedir=O:\COMMON\COMPONENT\PosControl2\
ECHO Source Directory:
ECHO %sourcedir%
ECHO Objective Directory:
cd
pause
@ECHO ON

@ECHO Fundamental-Security ...
copy %sourcedir%*.pas *.* /y
copy %sourcedir%*.dfm *.* /y
copy %sourcedir%*.dcr *.* /y
copy %sourcedir%*.bmp *.* /y
copy %sourcedir%*.dpk *.* /y
copy %sourcedir%*.dll *.* /y
copy %sourcedir%*.res *.* /y
copy %sourcedir%*.dcp *.* /y
copy %sourcedir%*.d32 *.* /y

