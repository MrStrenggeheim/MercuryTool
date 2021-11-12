::mode con cols=50 lines=20
@echo off
goto setup

:drawHeader
echo ษออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ                                                บ
echo บ        Artemis Submission Autoloader!          บ
echo บ                                                บ
echo ศออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.
EXIT /B 0

:drawMessage
echo.
echo ษออออออออออออออออออออออออออออออออออออออออออออออออป
echo.
echo    %~1
echo.
echo ศออออออออออออออออออออออออออออออออออออออออออออออออผ
echo.
EXIT /B 0

:setup
:: load test Folder
if exist settings.mcy (
	set /p testFolder=<settings.mcy
) else (
	echo testFolder\>settings.mcy
	set testFolder=testFolder\
)
goto start


:start
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
echo  Welcome to PGdP Submission Autoloader!
echo  It seems there is no test-folder selected.
echo.
echo  Choose wisely:
echo    1) Select test-folder
echo.
echo    8) Update
echo    9) Help
echo    0) Exit

choice /N /C 1890
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

echo  Welcome to Artemis Submission Autoloader!
echo.
echo   Test-Folder: %testFolder%
echo.
echo    1) Run behavior-tests: mvn clean test
echo    2) Copy new student solution
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

:selectTestFolder
cls 
call :drawHeader
echo  Please enter the location of the test-folder:
set newTestFolder=exit
set /p "newTestFolder=->"
if "%newTestFolder%"=="exit" goto start
if exist %newTestFolder% ( 
	set testFolder=%newTestFolder%
	echo %testFolder%>settings.mcy
	echo.
	echo  Test-folder successfully selected ...	
	echo.
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
echo  Press Enter to go back ...
echo.
set /p nothing=
goto start


:newSolution
cls
call :drawHeader
echo  Please enter the http link to the students repo:
echo. 
set repo=exit
set /p repo="->"
if %repo% == exit goto start

cd %testFolder%

git clone %repo% studentSolution
if %errorlevel%==0 goto cloneSuccess
rd /S /Q studentSolution
goto falseGit

:cloneSuccess
rd /S /Q assignment/src
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

:help
cls
call :drawHeader
echo  Find more help on the github-page ...
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