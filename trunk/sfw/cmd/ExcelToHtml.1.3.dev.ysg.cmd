@echo off
set _ProjectName=ExcelToHtml
:: the version of the current project 
set _ProjectVersion=1.3
:: could be dev , test , qa , prod
set _ProjectType=dev
:: who owns this project / environment 
set _ProjectOwner=ysg
:: an environment is defined by its parts 
set _EnvironmentName=%_ProjectName%.%_ProjectVersion%.%_ProjectType%.%_ProjectOwner%
:: the basedir 
set _BaseDir=E:\cas\cas.0.7.5.dev.ysg\sfw\perl
:: The version directory of the project 
set _ProjectVersionDir=%_BaseDir%\%_ProjectName%\%_EnvironmentName%
:: The Perl script performing all the tasks
set _PerlScript=%_ProjectVersionDir%\sfw\perl\%_ProjectName%.pl
:: the IniFile containing all the configuration 
:: Note the %computername% which must be replaced with the hostName of the 
:: running host 
set _IniFile=%_ProjectVersionDir%\conf\%_EnvironmentName%.%ComputerName%.ini
:: where the error logs of this call are situated 
set _ErrorLog=%_ProjectVersionDir%\data\log\%_ProjectName%.cmd.error.log
:: where the running of this 
set _RunLog=%_ProjectVersionDir%\data\log\%_ProjectName%.cmd.log
ECHO Check the variables 
echo date is %date% time is %time% > %_RunLog%
echo date is %date% time is %time% > %_ErrorLog%
set _ >> %_RunLog%
:: Action !!!
perl %_PerlScript% %_IniFile% >> %_RunLog% 2>> %_ErrorLog%

cmd /c start /max textpad %_RunLog%
cmd /c start /max textpad %_ErrorLog%
:: ping localhost -n 5
