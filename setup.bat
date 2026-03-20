@echo off
setlocal

set "SBFLOW_DIR=%~dp0"
if "%SBFLOW_DIR:~-1%"=="\" set "SBFLOW_DIR=%SBFLOW_DIR:~0,-1%"

echo.
echo =============================================
echo   sb-flow Project Setup
echo =============================================
echo.

:: Windows folder picker dialog
for /f "delims=" %%i in ('powershell -noprofile -command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; $f.Description = 'Select or create your project folder'; $f.ShowNewFolderButton = $true; $f.RootFolder = 'Desktop'; if ($f.ShowDialog() -eq 'OK') { $f.SelectedPath } else { '' }"') do set "PROJECT_DIR=%%i"

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

echo   Target: %PROJECT_DIR%
echo.
echo   Copying files...

if exist "%SBFLOW_DIR%\templates\CLAUDE.md" (
    copy /y "%SBFLOW_DIR%\templates\CLAUDE.md" "%PROJECT_DIR%\CLAUDE.md" > nul
    echo   [OK] CLAUDE.md
) else echo   [SKIP] CLAUDE.md not found

if not exist "%PROJECT_DIR%\.claude\commands\" mkdir "%PROJECT_DIR%\.claude\commands"

for %%f in (sb-guide sb-oneshot sb-setup sb-bridge sb-sync) do (
    if exist "%SBFLOW_DIR%\templates\.claude\commands\%%f.md" (
        copy /y "%SBFLOW_DIR%\templates\.claude\commands\%%f.md" "%PROJECT_DIR%\.claude\commands\%%f.md" > nul
        echo   [OK] %%f.md
    )
)

for %%f in (sdd_guide.md SPEC_CONTEXT.md design.md constitution.md) do (
    if exist "%SBFLOW_DIR%\%%f" (
        copy /y "%SBFLOW_DIR%\%%f" "%PROJECT_DIR%\%%f" > nul
        echo   [OK] %%f
    )
)

if exist "%SBFLOW_DIR%\templates\design-tokens.css" (
    copy /y "%SBFLOW_DIR%\templates\design-tokens.css" "%PROJECT_DIR%\design-tokens.css" > nul
    echo   [OK] design-tokens.css
)

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
