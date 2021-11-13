::mode con cols=50 lines=20

@echo off
setlocal
title Mercury
goto setup

:: Helper Functions ---------------------------------------
:drawHeader
echo ษออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ                                                บ
echo บ                 M E R C U R Y                  บ
echo บ                                                บ
echo ศออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.
EXIT /B 0

:drawMessage
echo.
echo ออออออออออออออออออออออออออออออออออออออออออออออออออ
echo.
echo    %~1
echo.
echo ออออออออออออออออออออออออออออออออออออออออออออออออออ
echo.
EXIT /B 0
:: --------------------------------------- Helper Functions

:setup
:: if settings -> load test folder
if exist settings.mcy (
	set /p testFolder=<settings.mcy
	REM (
	REM set /p testFolder=
	REM )<settings.mcy
) else ( 
	:: else -> create default one
	echo testFolder\>settings.mcy
	set testFolder=testFolder\
)
goto start


:start
title Mercury

if not exist %testFolder% goto noDirTitle
FOR %%i IN ("%testFolder%") DO (
set dirName=%%~ni
)
title Mercury - %dirName%

:noDirTitle
:: decide which home screen to launch
if exist %testFolder% (
	cd %testFolder%
	goto home
) else (
	goto homeSelectFolder
)


:: HOME SCREEN - FOLDER SELECTION -------------------------
:: a second start screen that pops when no test folder is selected
:homeSelectFolder
cls
call :drawHeader
echo  Welcome to Mercury.
echo  An Artemis Submission Autoloader!
echo  It seems there is no test-folder selected.
echo.
echo  Choose wisely:
echo    5) Select test-folder
echo.
echo    8) Update
echo    9) Help
echo    0) Exit

choice /N /C 5890
if errorlevel 255 goto homeSelectFolder
if errorlevel 4 goto exitProgram
if errorlevel 3 goto help
if errorlevel 2 goto update
if errorlevel 1 goto selectTestFolder
if errorlevel 0 goto homeSelectFolder

:: HOME SCREEN --------------------------------------------
:home
cls
call :drawHeader

echo  Welcome to Mercury.
echo  An Artemis Submission Autoloader!
echo.
echo    Test-Folder: %testFolder%
echo.
echo    1) Run behavior-tests: mvn clean test
echo    2) Clone new student solution
echo.
echo    5) Select different test-folder
echo.
echo    8) Update
echo    9) Help
echo    0) Exit

choice /N /C 125890
if errorlevel 255 goto start
if errorlevel 6 goto exitProgram
if errorlevel 5 goto help
if errorlevel 4 goto update
if errorlevel 3 goto selectTestFolder
if errorlevel 2 goto newSolution
if errorlevel 1 goto runTests
if errorlevel 0 goto start
:: -------------------------------------------- HOME SCREEN


:: Select Folder ------------------------------------------
:selectTestFolder
cls 
call :drawHeader

echo Please enter the absolute path to the test-folder:
echo    Type 'pick' to open a file-picker.
echo    Type 'cancel' or nothing to go back.
echo. 
set newTestFolder=cancel
set /p "newTestFolder=->"
if "%newTestFolder%"=="cancel" goto start
if not "%newTestFolder%"=="pick" goto applyFolder

setlocal
setlocal enabledelayedexpansion
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a folder.',0,17).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "newTestFolder=%%I"


endlocal
REM echo    Type 'remove' to forget the current test-folder.
REM if not "%newTestFolder%"=="remove" goto :applyFolder
REM set "testFolder=nothing"
REM echo nothing>settings.mcy
REM goto start
:applyFolder
if exist %newTestFolder% (
	(
		echo %newTestFolder%
	)>settings.mcy
	echo.
	call :drawMessage "Test-folder successfully selected ..."
	echo.
	set testFolder=%newTestFolder%
	pause
	goto start
) else (
	echo.
	echo  This folder doesn't exist. Please try again ...
	echo.
	pause
	goto selectTestFolder
)
goto start
:: ------------------------------------------ Select Folder


:: RUN TESTS ----------------------------------------------
:runTests
cls 
call :drawHeader
echo  Running tests ...
echo. 
cd %testFolder%\behavior
call mvn clean test
cd ..
echo.
call :drawMessage "Press Enter to go back ..."
echo.
set /p nothing=
goto start

:: CloneSolution ------------------------------------------
:newSolution
cls
call :drawHeader
echo  Please enter the http link to the students repo:
echo    Type 'remove' to delete all existing student files.
echo    Type 'cancel' or nothing to go back.
echo. 
set repo=cancel
set /p repo="->"
if %repo%==cancel goto start
if %repo%==remove goto removeStudentSolution

cd %testFolder%

if exist studentSolution (
	rd /S /Q studentSolution
)
git clone %repo% studentSolution
if %errorlevel%==0 goto cloneSuccess
if exist studentSolution (
	rd /S /Q studentSolution
)
goto falseGit

:cloneSuccess
rd /S /Q assignment
mkdir assignment
xcopy /E studentSolution/src assignment
rd /S /Q studentSolution
call :drawMessage "Successfully cloned students solution ... "
echo. 
pause
goto start


:falseGit
call :drawMessage "This is not a valid git repo ... "
echo.
pause
goto start


:removeStudentSolution
cd %testFolder%
if exist studentSolution (
	rd /S /Q studentSolution
)
if exist assignment (
	rd /S /Q assignment
)
call :drawMessage "Student solution successfully removed ..."
pause
goto start


:: ------------------------------------------ CloneSolution


:: Update -------------------------------------------------
:update
cls
call :drawHeader
echo  Are you sure, you want to update MercuryTool?
echo  (This will replace all Files in this directory)
echo.
choice /C yn
if errorlevel 255 goto update
if errorlevel 2 goto start
if errorlevel 1 goto updateYes
if errorlevel 0 goto update

:updateYes
cls
call :drawHeader
echo  Updating MercuryTool ...
git fetch --all
git reset --hard origin/main
call :drawMessage "MercuryTool updated ...
pause
goto start
:: ------------------------------------------------- Update

:help
cls
call :drawHeader
echo  Find more help here: 'https://gitbub.com/MrStrenggeheim/MercuryTool'
echo.
pause
goto start

:exitProgram
cls 
call :drawHeader
echo  Thank you for using MercuryTool. See you soon ...
timeout >NUL /t 1
exit

goto start


