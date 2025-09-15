@echo off
:: Git cycle script - add, commit, pull, push
:: Auto commit with timestamp to origin main

:: Check if inside a Git repo
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ERROR: Not a Git repository. Exiting...
    pause
    exit /b
)

:: Generate timestamp using PowerShell (more reliable)
for /f "delims=" %%i in ('powershell -command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"') do set timestamp=%%i

:: Alternative method using standard Windows commands if PowerShell fails
if "%timestamp%"=="" (
    for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
        set datestr=%%c-%%a-%%b
    )
    for /f "tokens=1-2 delims=: " %%a in ('time /t') do (
        set timestr=%%a:%%b
    )
    set timestamp=%datestr% %timestr%
)

:: Commit message
set msg=last updated on %timestamp%

echo.
echo Running Git Cycle with commit message:
echo "%msg%"
echo ========================

:: Add all changes
echo Adding all changes...
git add -A
if errorlevel 1 (
    echo ERROR: Failed to add files.
    pause
    exit /b
)

:: Commit changes
echo Committing changes...
git commit -m "%msg%"
if errorlevel 1 (
    echo WARNING: Nothing to commit, working tree clean.
) else (
    echo SUCCESS: Changes committed successfully.
)

:: Pull latest from origin main
echo Pulling latest changes from origin main...
git pull --rebase origin main
if errorlevel 1 (
    echo ERROR: Failed to pull changes. Resolve conflicts manually.
    pause
    exit /b
)

:: Push to origin main
echo Pushing to origin main...
git push origin main
if errorlevel 1 (
    echo ERROR: Failed to push changes.
    pause
    exit /b
)

echo.
echo SUCCESS: Git cycle completed successfully at %timestamp% on origin/main
pause