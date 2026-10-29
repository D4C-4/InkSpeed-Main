@echo off
setlocal
cd /d "%~dp0.."
echo ========================================
echo InkSpeed Setup Helper
echo ========================================
echo.
echo Project folder: %CD%
echo.

if not exist "backend\main.py" (
    echo [ERROR] backend\main.py was not found.
    echo         Run this script from inside the extracted InkSpeed folder:
    echo         double-click scripts\setup.bat
    pause
    exit /b 1
)

echo [1/5] Checking Python 3.11 or newer...
set "PYTHON=python"
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    py -3 --version >nul 2>&1
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Python is not found on PATH.
        echo         Install Python 3.11 or newer from https://www.python.org/downloads/
        echo         During installation, tick "Add python.exe to PATH".
        pause
        exit /b 1
    )
    set "PYTHON=py -3"
)
%PYTHON% -c "import sys; sys.exit(0 if sys.version_info >= (3, 11) else 1)"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] InkSpeed needs Python 3.11 or newer. Found:
    %PYTHON% --version
    pause
    exit /b 1
)
%PYTHON% --version

echo.
echo [2/5] Checking Node.js 20.19 or 22.12+...
node --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not found on PATH.
    echo         Install the Node.js LTS release from https://nodejs.org/
    pause
    exit /b 1
)
node -e "const [a,b]=process.versions.node.split('.').map(Number);process.exit((a===20&&b>=19)||(a===22&&b>=12)||a>22?0:1)"
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] This Vite version needs Node.js 20.19+ or 22.12+. Found:
    node --version
    pause
    exit /b 1
)
node --version
call npm --version

echo.
echo [3/5] Creating Python virtual environment...
if exist "backend\.venv\Scripts\python.exe" (
    echo [INFO] Virtual environment already exists. Skipping creation.
) else (
    %PYTHON% -m venv backend\.venv
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Failed to create backend\.venv.
        pause
        exit /b 1
    )
    echo [OK] Virtual environment created at backend\.venv
)

echo.
echo [4/5] Installing Python dependencies...
backend\.venv\Scripts\python.exe -m pip install --upgrade pip
backend\.venv\Scripts\python.exe -m pip install -r backend\requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install backend dependencies.
    pause
    exit /b 1
)
echo [OK] Python dependencies installed.

echo.
echo [5/5] Checking frontend dependencies...
if exist "frontend\node_modules" (
    echo [INFO] frontend\node_modules already exists. Skipping npm ci.
) else (
    echo [INFO] Installing frontend dependencies from package-lock.json...
    pushd frontend
    call npm ci
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] npm ci failed. Check the messages above.
        popd
        pause
        exit /b 1
    )
    popd
    echo [OK] Frontend dependencies installed.
)

echo.
echo ========================================
echo Setup complete
echo ========================================
echo.
echo NEXT STEPS:
echo 1. In XAMPP Control Panel, click Start next to MySQL and wait for it
echo    to turn green. Port 3306 must be free.
echo 2. In this project folder, create the .env file:
echo       copy .env.example .env
echo    The default MYSQL_DATABASE=inkspeed_db is correct for a new computer.
echo 3. Start the app:
echo       scripts\run_electron.bat
echo    The first backend start creates the database, tables, and all
echo    78 starter challenges automatically.
echo.
echo See README.md for the full walkthrough and troubleshooting.
echo.
pause
