
@echo off
goto start

:drawHeader
echo ษออออออออออออออออออออออออออออออออออออออออออออออออป
echo บ                                                บ
echo บ         PGdP Submission autoloader!            บ
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
 
:start
cls
call :drawHeader

echo  Welcome to PGdP src to test-folder autoload!
echo.
echo  Choose wisely:
echo    1) run behavior-tests: mvn clean test
echo    2) copy new student solution
echo    3) exit

choice /N /C 123
if errorlevel 255 goto start
if errorlevel 3 exit
if errorlevel 2 goto newSolution
if errorlevel 1 goto runTests
if errorlevel 0 goto start

:: RUN TESTS
:runTests
cls 
call :drawHeader
echo  Running tests ...
echo. 
cd behavior
call mvn clean test
cd ..
echo.
echo  Press Enter to go back ...
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

rd /S /Q studentSolution

git clone %repo% studentSolution
if %errorlevel%==0 goto cloneSuccess
goto falseGit

:cloneSuccess
rd /S /Q assignment
mkdir assignment
xcopy /E studentSolution/src assignment

call :drawMessage "Successfully cloned students solution ... "
echo. 
pause
goto start

:: False repo
:falseGit
call :drawMessage "This is not a valid git repo ... "
echo.
pause
goto start


goto start