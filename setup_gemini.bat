@echo off
setlocal

set "SBFLOW_DIR=%~dp0"
if "%SBFLOW_DIR:~-1%"=="\" set "SBFLOW_DIR=%SBFLOW_DIR:~0,-1%"

echo.
echo =============================================
echo   sb-flow Project Setup (Gemini)
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

:: GEMINI.md
if exist "%SBFLOW_DIR%\templates\GEMINI.md" (
    copy /y "%SBFLOW_DIR%\templates\GEMINI.md" "%PROJECT_DIR%\GEMINI.md" > nul
    echo   [OK] GEMINI.md
) else echo   [SKIP] GEMINI.md not found

:: .gemini/commands/
if not exist "%PROJECT_DIR%\.gemini\commands\" mkdir "%PROJECT_DIR%\.gemini\commands"

for %%f in (sb-guide sb-oneshot sb-setup sb-bridge sb-sync sb-design) do (
    if exist "%SBFLOW_DIR%\templates\.gemini\commands\%%f.toml" (
        copy /y "%SBFLOW_DIR%\templates\.gemini\commands\%%f.toml" "%PROJECT_DIR%\.gemini\commands\%%f.toml" > nul
        echo   [OK] .gemini/commands/%%f.toml
    )
)

:: 루트 파일
for %%f in (constitution.md SPEC_CONTEXT.md) do (
    if exist "%SBFLOW_DIR%\%%f" (
        copy /y "%SBFLOW_DIR%\%%f" "%PROJECT_DIR%\%%f" > nul
        echo   [OK] %%f
    )
)

:: guides/ → 프로젝트 루트 복사
for %%f in (sdd_guide.md) do (
    if exist "%SBFLOW_DIR%\guides\%%f" (
        copy /y "%SBFLOW_DIR%\guides\%%f" "%PROJECT_DIR%\%%f" > nul
        echo   [OK] %%f
    )
)

:: designs/ 폴더 생성 및 디자인 파일 복사
if not exist "%PROJECT_DIR%\designs\" mkdir "%PROJECT_DIR%\designs"

for %%f in (design.md design-tokens.css design-constitution.md) do (
    if exist "%SBFLOW_DIR%\designs\%%f" (
        copy /y "%SBFLOW_DIR%\designs\%%f" "%PROJECT_DIR%\designs\%%f" > nul
        echo   [OK] designs/%%f
    )
)

:: prd/ 폴더 생성
if not exist "%PROJECT_DIR%\prd\" mkdir "%PROJECT_DIR%\prd"
echo   [OK] prd/ (folder)

:: start.bat, end.bat
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
echo   1. Open Gemini App / Workspace
echo   2. Open folder: %PROJECT_DIR%
echo   3. Type:  /sb-setup
echo.
pause
