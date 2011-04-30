@echo off
:: callls the logger s/set/export/gi s/%//gi s/%_/\$/gi s/\.cmd/.sh/gi for *nix ; ) 
set _BaseDir=E:\cas\cas.0.7.5.dev.ysg\sfw\perl
set _ProjectName=ExcelToHtml
set _ProjectVersion=1.3
set _ProjectType=dev
set _ProjectOwner=ysg

set _EnvironmentName=%_ProjectName%.%_ProjectVersion%.%_ProjectType%.%_ProjectOwner%

set _ProjectVersionDir=%_BaseDir%\%_ProjectName%\%_EnvironmentName%

set _TmpBat=%_ProjectVersionDir%\sfw\cmd\tmp.bat


cd %_ProjectVersionDir%

for /f %%i in ('dir *.log *.cmd *.ini *.sh *.pl *.pm /s /b') do start /max  textpad "%%i"

::call tmp.cmd 