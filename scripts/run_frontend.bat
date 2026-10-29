@echo off
setlocal
cd /d "%~dp0..\frontend"
echo Starting InkSpeed frontend (browser mode)...
if not exist "node_modules" (
    echo [ERROR] frontend\node_modules not found. Run scripts\setup.bat first.
    pause
    exit /b 1
)
echo Frontend dev server: http://localhost:5173
echo The backend must already be running at http://127.0.0.1:5000
echo Press Ctrl+C to stop.
echo.
call npm run dev
pause
