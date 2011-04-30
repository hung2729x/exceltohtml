@echo off
:: START FILE GetNiceTime.cmd ====================================================
:: HAVING THE FOLLOWING DATE TIME FORMATS time is 21:30:27,47 and date is to 20.05.2010 
:: START USAGE  ==================================================================
:: SET THE NICETIME 
:: SET NICETIME=BOO
:: CALL GetNiceTime.cmd 
:: ECHO %COMPUTERNAME% GETS HOSTNAME
:: ECHO NICETIME IS %NICETIME%
 
:: echo nice time is %NICETIME%
:: END USAGE  ==================================================================
 
echo set hhmmsss
:: this is Regional settings dependant so tweak this according your current settings
:: So this works for System Locale:fi;Finnish run the systeminfo commmand to see your own and adjust
for /f "tokens=1-3 delims=,: " %%a in ('echo %time%') do IF %%a GEQ 10 set hhmmsss=%%a%%b%%c
for /f "tokens=1-3 delims=,: " %%a in ('echo %time%') do IF %%a LSS 10 set hhmmsss=0%%a%%b%%c
for /f "tokens=1-3 delims=,: " %%a in ('echo %time%') do IF %%a GEQ 10 set _hhmmsss=%%a:%%b:%%c
for /f "tokens=1-3 delims=,: " %%a in ('echo %time%') do IF %%a LSS 10 set _hhmmsss=0%%a:%%b:%%c

 
set NICETIME=%yyyymmdd%_%hhmmsss%
set _NICETIME=%_yyyymmdd% - %_hhmmsss%

:: THIS NEEDS THE CLIP.EXE command line tool from the windows server 2003 resource kit 
echo %NICETIME% | CLIP

:: DEBUG PAUSE
echo THE NICETIME IS %NICETIME%
echo THE _NICETIME IS %_NICETIME%
:: DEBUG PAUSE
 
:: =========END FILE GetNiceTime.cmd ====================================================