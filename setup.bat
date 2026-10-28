@echo off
echo ========================================
echo InkSpeed Setup Helper
echo ========================================
echo.

REM Check if running from project root
if not exist "backend\main.py" (
    echo [ERROR] Please run this script from the InkSpeed project root directory.
    echo         Current directory: %CD%
    pause
    exit /b 1
)

echo [1/5] Checking Python installation...
py --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Python is not found or not in PATH.
    echo         Please install Python 3.10+ from https://www.python.org/
    echo         Make sure to check "Add Python to PATH" during installation.
    pause
    exit /b 1
)
py --version

echo.
echo [2/5] Checking Node.js installation...
node --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not found or not in PATH.
    echo         Please install Node.js LTS from https://nodejs.org/
    pause
    exit /b 1
)
node --version
npm --version

echo.
echo [3/5] Creating Python virtual environment...
if exist "backend\.venv" (
    echo [INFO] Virtual environment already exists. Skipping creation.
) else (
    py -m venv backend\.venv
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo [OK] Virtual environment created.
)

echo.
echo [4/5] Installing backend dependencies...
backend\.venv\Scripts\python.exe -m pip install --upgrade pip >nul 2>&1
backend\.venv\Scripts\python.exe -m pip install -r backend\requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install backend dependencies.
    pause
    exit /b 1
)
echo [OK] Backend dependencies installed.

echo.
echo [5/5] Checking frontend dependencies...
if exist "frontend\node_modules" (
    echo [INFO] Node modules already exist. Skipping npm install.
    echo        If you need to update dependencies, run: cd frontend && npm install
) else (
    echo [INFO] Installing frontend dependencies (this may take a few minutes)...
    cd frontend
    call npm install
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to install frontend dependencies.
        cd ..
        pause
        exit /b 1
    )
    cd ..
    echo [OK] Frontend dependencies installed.
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo NEXT STEPS (One-time database setup):
echo 1. Start XAMPP Control Panel and start MySQL
echo 2. Open http://localhost/phpmyadmin and create database 'inkspeed_db'
echo 3. Import backend\database\schema.sql into the database
echo    (Or just start the backend - it will auto-initialize)
echo.
echo TO RUN THE APPLICATION:
echo - Option 1 (Two terminals): See README.md for detailed instructions
echo - Option 2 (Electron): Start MySQL in XAMPP, then run run_electron.bat
echo.
echo See README.md for complete step-by-step instructions.
echo.
pause
