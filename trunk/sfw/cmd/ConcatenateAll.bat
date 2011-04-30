ECHO EMPTY THE FILE 
ECHO REMOVE THE OUTPUT FILE ALREADY ...
ECHO. >all.txt

ECHO FOR EACH LOG FILE IN THE CURRENT DIRECTORY DO CONTCATENATE IT 
ECHO IN THE ALL.TXT FILE 
for /f %%i in ('dir /b /a-d') do echo . >>all.txt&ECHO START ===== %%i>>all.txt&type %%i>>all.txt&ECHO. >>all.txt&echo END ================== %%i>>all.txt&ECHO. >>all.txt
PAUSE
ECHO OPEN THE ALL.TXT FILE 
all.txt