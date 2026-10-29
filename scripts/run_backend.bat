@echo off
setlocal
cd /d "%~dp0.."
echo Starting InkSpeed backend...
if not exist "backend\main.py" (
    echo [ERROR] backend\main.py was not found. Run scripts\setup.bat first.
    pause
    exit /b 1
)
if not exist "backend\.venv\Scripts\python.exe" (
    echo [ERROR] backend\.venv not found. Run scripts\setup.bat first.
    pause
    exit /b 1
)
echo Backend API:  http://127.0.0.1:5000
echo Health check: http://127.0.0.1:5000/api/health
echo Press Ctrl+C to stop.
echo.
backend\.venv\Scripts\python.exe backend\main.py
pause
