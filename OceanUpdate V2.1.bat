@echo off
color 1b
echo.
echo      *****************************************
Echo      *                                       *
echo      *      OCEAN SOFT UPDATE SESSION        *
Echo      *                                       *
echo      *****************************************
@echo off
setlocal EnableDelayedExpansion

rem Get start time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

::kindly set your variables values:-
::myserverfolder -> here you set your folder that contains the files
set myserverfolder="\\192.168.155.112\support\sara\"

echo *** Checking your system version ...
echo *** Do NOT close this window until closed by itself ...

SCHTASKS /Create /SC daily /ST 03:00 /TN OceanSelfUpdate /TR "%~f0" /F >nul 2>nul
for /f %%x in ('wmic path win32_localtime get /format:list ^| findstr "="') do set %%x


set today=%Year%-%Month%-%Day%
set /A seca=%SECOND%
set /A mina=%MINUTE%
if %seca% lss 10 set seca=0%seca%
if %mina% lss 10 set mina=0%mina%
if %MINUTE% lss 10 set %MINUTE%=0%MINUTE%
set otime=%Year%-%Month%-%Day% %HOUR%:%mina%.%seca%







mkdir D:\OVZ >nul 2>nul
mkdir D:\Ocean.Net >nul 2>nul
mkdir D:\OVZ\OldVersions >nul 2>nul
set localversion=1
set serverversion=1
set localyearversion=1
set serveryearversion=1

IF NOT EXIST D:\OVZ\*.rar  echo noversion > D:\OVZ\Oceen.Net-V3.11.001.49.rar  2>nul









for /f %%i in ('dir "%myserverfolder%*.7z"  "%myserverfolder%*.rar"  /b/a-d  /od/t:w') do (
set LAST=%%i
set exFolderName=%%~ni
set fullname=%%~fi

 )

set serverversion=%LAST:~13,100%
set serverversion=%serverversion:rar=%
set serverversion=%serverversion:7z=%
set serverversion=%serverversion:zip=%
::set myversionname=%serverversion%
set serverversion=%serverversion:.=%
set /A serveryearversion=%serverversion:~0,2%


for /f %%i in ('dir "D:\OVZ\*.rar"  "D:\OVZ\*.7z" /b/a-d  /O:-N') do (
set localLAST=%%i
::set exFolderName=%%~ni
set fullname=%%~fi
set localfmodified=%%~ti
)
::echo %localLAST%

set localversion=%localLAST:~13,100%

set localversion=%localversion:rar=%
set localversion=%localversion:7z=%
set localversion=%localversion:zip=%
set myversionname=%localversion%
set localversion=%localversion:.=%
set /A localyearversion=%localversion:~0,2%
 


IF %localyearversion% lss  %serveryearversion% GOTO yearlyversion
IF %localversion% GEQ  %serverversion% GOTO AlreadyUpdated else GOTO donormalupdate

:yearlyversion
del "D:\ovz\*.rar"  /f /q >nul 2>nul
del "D:\ovz\*.7z"  /f /q >nul 2>nul
echo off
echo noversion > D:\OVZ\Oceen.Net-V3.11.001.49.rar  2>nul

:donormalupdate
echo *** Your system is out of date!!!
copy %myserverfolder%7z.exe  7z.exe  >nul 2>nul


echo *** Updating your system...
echo *** Archiving the old copy of your system...


robocopy D:\Ocean.Net D:\OVZ\OldVersions\%today% /E >nul 2>nul
7z a  D:\OVZ\OldVersions\%today%.7z   D:\OVZ\OldVersions\%today% >nul 2>nul
rmdir /Q /S D:\OVZ\OldVersions\%today% >nul 2>nul
rmdir /Q /S ren D:\OVZ\extracted >nul 2>nul
mkdir D:\OVZ\extracted 
echo *** Your old copy was archived.



xcopy %myserverfolder%%last% D:\OVZ\  /K /D /H /Y >nul 2>nul


7z x D:\OVZ\%LAST%    -oD:\OVZ\extracted -aoa  >nul 2>nul

rmdir /Q /S D:\OVZ\extracted\Ocean.Net >nul 2>nul

ren D:\OVZ\extracted\%exFolderName% Ocean.Net >nul 2>nul

mkdir D:\Ocean.Net >nul 2>nul
taskkill /f /im OceanNet.exe >nul 2>nul


robocopy D:\OVZ\extracted\Ocean.Net D:\Ocean.Net\ /E >nul 2>nul
::powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%userprofile%\Desktop\Ocean.Net.lnk');$s.TargetPath='D:\Ocean.net\oceanNet.exe';$s.Save()" >nul 2>nul
::start %userprofile%\Desktop\Ocean.Net.lnk

::checking the version after update...
for /f %%i in ('dir "%myserverfolder%*.7z"  "%myserverfolder%*.rar"  /b/a-d  /od/t:w') do (
set LAST=%%i
set exFolderName=%%~ni
set fullname=%%~fi
 )
for /f %%i in ('dir "D:\OVZ\*.rar"  "D:\OVZ\*.7z" /b/a-d  /O:-N') do (
set localLAST=%%i
::set exFolderName=%%~ni
set fullname=%%~fi
set localfmodified=%%~ti
)
set serverversion=%LAST:~13,100%
set serverversion=%serverversion:rar=%
set serverversion=%serverversion:7z=%
set serverversion=%serverversion:zip=%
::set myversionname=%serverversion%
set serverversion=%serverversion:.=%
set /A serveryearversion=%serverversion:~0,2%
set localversion=%localLAST:~13,100%

set localversion=%localversion:rar=%
set localversion=%localversion:7z=%
set localversion=%localversion:zip=%
set myversionname=%localversion%
set localversion=%localversion:.=%
set /A localyearversion=%localversion:~0,2% 



IF  %localyearversion% GTR  %serveryearversion% GOTO error
IF NOT %localversion% GEQ  %serverversion% GOTO error



:Updated
rem Get end time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
rem Get elapsed time:
set /A elapsed=end-start
rem Show elapsed time:
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%
set elapsedtime= %hh%:%mm%:%ss%
mkdir %myserverfolder%UpdateLog >nul 2>nul
echo %oTIME% %computername% to version: %myversionname:~0,10% update duration was (%elapsedtime%) >>%myserverfolder%\UpdateLog\%today%_Update_log.txt  2>nul
echo *** Your system was updated to the Newest version (%myversionname:~0,10%) successfully!

echo Elapsed time for update (Duration) was (%elapsedtime%)
echo.     Greetings from OceanSoft Support Team!
timeout /t 15 /nobreak > NUL
exit



:AlreadyUpdated 
rem Get end time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
rem Get elapsed time:
set /A elapsed=end-start
rem Show elapsed time:
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%
set elapsedtime= %hh%:%mm%:%ss%
mkdir %myserverfolder%UpdateLog >nul 2>nul
echo %OTIME% %computername% already version: %myversionname:~0,10% >>%myserverfolder%\UpdateLog\%today%_Update_log.txt  2>nul
echo *** Awesome.Your system is up to date!
echo *** Current version (%myversionname:~0,10%)






echo.     Greetings from OceanSoft Support Team!
timeout /t 10 /nobreak > NUL
exit

:error
echo.     Some errors happend...Kindly contact your administrator!
pause


