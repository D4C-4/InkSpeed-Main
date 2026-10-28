@echo off
echo Starting InkSpeed Frontend...
cd /d "%~dp0\frontend"
if not exist "node_modules" (
    echo [ERROR] Node modules not found. Run setup.bat first or run npm install.
    pause
    exit /b 1
)
echo Frontend dev server will start (usually at http://localhost:5173)
echo Press Ctrl+C to stop.
echo.
call npm run dev
pause
