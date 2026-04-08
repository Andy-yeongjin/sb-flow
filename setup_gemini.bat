@echo off
setlocal

set "SBFLOW_DIR=%~dp0"
if "%SBFLOW_DIR:~-1%"=="\" set "SBFLOW_DIR=%SBFLOW_DIR:~0,-1%"

echo.
echo =============================================
echo   sb-flow Project Setup (Gemini)
echo =============================================
echo.

:: Windows folder picker dialog (VBScript)
set "TMPVBS=%TEMP%\sb_picker.vbs"
echo Set oShell = CreateObject("Shell.Application") > "%TMPVBS%"
echo Set oFolder = oShell.BrowseForFolder(0, "Select your project folder", 0) >> "%TMPVBS%"
echo If Not oFolder Is Nothing Then >> "%TMPVBS%"
echo     WScript.Echo oFolder.Self.Path >> "%TMPVBS%"
echo End If >> "%TMPVBS%"
for /f "delims=" %%i in ('cscript //nologo "%TMPVBS%"') do set "PROJECT_DIR=%%i"
del "%TMPVBS%" 2>nul

if not defined PROJECT_DIR goto :manual
if "%PROJECT_DIR%"=="" goto :manual
goto :proceed

:manual
echo.
echo   [!] Folder picker failed. Please type the project folder path.
echo   [!] Example: C:\Users\YourName\Desktop\my-project
echo.
set /p PROJECT_DIR="  Folder path: "

if not defined PROJECT_DIR (
    echo Cancelled.
    pause
    exit /b 0
)
if "%PROJECT_DIR%"=="" (
    echo Cancelled.
    pause
    exit /b 0
)

:proceed

echo   Target: %PROJECT_DIR%
echo.
echo   Copying files...

:: GEMINI.md
if exist "%SBFLOW_DIR%\templates\GEMINI.md" (
    copy /y "%SBFLOW_DIR%\templates\GEMINI.md" "%PROJECT_DIR%\GEMINI.md" > nul
    echo   [OK] GEMINI.md
) else echo   [SKIP] GEMINI.md not found

:: .gemini/commands/
if not exist "%PROJECT_DIR%\.gemini\commands\" mkdir "%PROJECT_DIR%\.gemini\commands"

for %%f in (sb-guide sb-oneshot sb-setup sb-design) do (
    if exist "%SBFLOW_DIR%\templates\.gemini\commands\%%f.toml" (
        copy /y "%SBFLOW_DIR%\templates\.gemini\commands\%%f.toml" "%PROJECT_DIR%\.gemini\commands\%%f.toml" > nul
        echo   [OK] .gemini/commands/%%f.toml
    )
)

:: constitution.md
if exist "%SBFLOW_DIR%\constitution.md" (
    copy /y "%SBFLOW_DIR%\constitution.md" "%PROJECT_DIR%\constitution.md" > nul
    echo   [OK] constitution.md
)

:: designs/
if not exist "%PROJECT_DIR%\designs\" mkdir "%PROJECT_DIR%\designs"

for %%f in (design.md design-tokens.css design-constitution.md) do (
    if exist "%SBFLOW_DIR%\designs\%%f" (
        copy /y "%SBFLOW_DIR%\designs\%%f" "%PROJECT_DIR%\designs\%%f" > nul
        echo   [OK] designs/%%f
    )
)

:: prd/
if not exist "%PROJECT_DIR%\prd\" mkdir "%PROJECT_DIR%\prd"
echo   [OK] prd/ (folder)

:: start.bat end.bat
for %%f in (start.bat end.bat) do (
    if exist "%SBFLOW_DIR%\%%f" (
        copy /y "%SBFLOW_DIR%\%%f" "%PROJECT_DIR%\%%f" > nul
        echo   [OK] %%f
    )
)

echo.
echo =============================================
echo   Done!
echo =============================================
echo.
echo   1. Open Antigravity
echo   2. Open folder: %PROJECT_DIR%
echo   3. Type:  /sb-setup
echo.
pause
