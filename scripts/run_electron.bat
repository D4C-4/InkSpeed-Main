@echo off
setlocal
cd /d "%~dp0.."
echo Starting InkSpeed desktop app (Electron)...
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
if not exist "frontend\node_modules" (
    echo [ERROR] frontend\node_modules not found. Run scripts\setup.bat first.
    pause
    exit /b 1
)
echo Make sure MySQL is running in the XAMPP Control Panel.
echo Electron starts the backend (port 5000) and Vite (port 5174) itself.
echo.
cd frontend
call npm run electron
pause
