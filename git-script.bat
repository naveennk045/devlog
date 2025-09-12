@echo off
:: Git cycle script - add, commit, pull, push
:: Auto commit with timestamp to origin main

:: Check if inside a Git repo
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ❌ Not a Git repository. Exiting...
    pause
    exit /b
)

:: Generate timestamp (format: YYYY-MM-DD HH:MM:SS)
for /f "tokens=2 delims==" %%i in ('"wmic os get localdatetime /value"') do set datetime=%%i
set timestamp=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%

:: Commit message
set msg=last updated on %timestamp%

echo.
echo 🚀 Running Git Cycle with commit message:
echo "%msg%"
echo ========================

:: Add all changes
git add -A
if errorlevel 1 (
    echo ❌ Error while adding files.
    pause
    exit /b
)

:: Commit changes
git commit -m "%msg%"
if errorlevel 1 (
    echo ⚠️ Nothing to commit, skipping commit.
)

:: Pull latest from origin main
git pull --rebase origin main
if errorlevel 1 (
    echo ❌ Error during pull. Resolve conflicts manually.
    pause
    exit /b
)

:: Push to origin main
git push origin main
if errorlevel 1 (
    echo ❌ Error during push.
    pause
    exit /b
)

echo.
echo ✅ Git cycle completed successfully at %timestamp% on origin/main!
pause
