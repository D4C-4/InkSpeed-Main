@echo off
echo Starting InkSpeed Backend...
cd /d "%~dp0"
if not exist "backend\main.py" (
    echo [ERROR] Please run this script from the InkSpeed project root.
    pause
    exit /b 1
)
if not exist "backend\.venv\Scripts\python.exe" (
    echo [ERROR] Virtual environment not found. Run setup.bat first.
    pause
    exit /b 1
)
echo Backend API will run at http://127.0.0.1:5000
echo Health check: http://127.0.0.1:5000/api/health
echo Press Ctrl+C to stop.
echo.
backend\.venv\Scripts\python.exe backend\main.py
pause
