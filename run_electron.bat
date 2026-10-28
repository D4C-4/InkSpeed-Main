@echo off
echo Starting InkSpeed Desktop App (Electron)...
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
if not exist "frontend\node_modules" (
    echo [ERROR] Frontend dependencies not found. Run setup.bat first.
    pause
    exit /b 1
)
echo Make sure MySQL is running in XAMPP before continuing!
echo.
cd frontend
call npm run electron
pause
