@echo off
setlocal

set "SBFLOW_DIR=%~dp0"
if "%SBFLOW_DIR:~-1%"=="\" set "SBFLOW_DIR=%SBFLOW_DIR:~0,-1%"

echo.
echo =============================================
echo   sb-flow Project Setup
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

:: CLAUDE.md
if exist "%SBFLOW_DIR%\templates\CLAUDE.md" (
    copy /y "%SBFLOW_DIR%\templates\CLAUDE.md" "%PROJECT_DIR%\CLAUDE.md" > nul
    echo   [OK] CLAUDE.md
) else echo   [SKIP] CLAUDE.md not found

:: .claude/commands/
if not exist "%PROJECT_DIR%\.claude\commands\" mkdir "%PROJECT_DIR%\.claude\commands"

for %%f in (sb-guide sb-oneshot sb-setup sb-bridge sb-sync sb-design) do (
    if exist "%SBFLOW_DIR%\templates\.claude\commands\%%f.md" (
        copy /y "%SBFLOW_DIR%\templates\.claude\commands\%%f.md" "%PROJECT_DIR%\.claude\commands\%%f.md" > nul
        echo   [OK] .claude/commands/%%f.md
    )
)

:: root files
for %%f in (constitution.md SPEC_CONTEXT.md) do (
    if exist "%SBFLOW_DIR%\%%f" (
        copy /y "%SBFLOW_DIR%\%%f" "%PROJECT_DIR%\%%f" > nul
        echo   [OK] %%f
    )
)

:: guides/
if not exist "%PROJECT_DIR%\guides\" mkdir "%PROJECT_DIR%\guides"

for %%f in (sdd_guide.md) do (
    if exist "%SBFLOW_DIR%\guides\%%f" (
        copy /y "%SBFLOW_DIR%\guides\%%f" "%PROJECT_DIR%\guides\%%f" > nul
        echo   [OK] guides/%%f
    )
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
echo   1. Open Claude Desktop
echo   2. Open folder: %PROJECT_DIR%
echo   3. Type:  /sb-setup
echo.
pause