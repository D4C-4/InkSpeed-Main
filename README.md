# InkSpeed

InkSpeed is a typing-speed application with three modes: **Classic**, **Memory Rush**, and **Key Chaos**. It uses a React/TypeScript frontend (with Vite and optional Electron), a Python Flask API backend, and **MySQL/MariaDB** for persistent data storage.

## Table of Contents

- [What does InkSpeed do?](#what-does-inkspeed-do)
- [Verified Features](#verified-features)
- [Technology Stack](#technology-stack)
- [Requirements](#requirements)
- [Important Files and Project Structure](#important-files-and-project-structure)
- [Downloading the Project (ZIP Method - Recommended for Presentations)](#downloading-the-project-zip-method---recommended-for-presentations)
- [Extracting and Opening the Project](#extracting-and-opening-the-project)
- [Setting Up Prerequisites](#setting-up-prerequisites)
- [Step 1: Create and Activate Python Virtual Environment](#step-1-create-and-activate-python-virtual-environment)
- [Step 2: Install Backend Dependencies](#step-2-install-backend-dependencies)
- [Step 3: Set Up Environment Configuration](#step-3-set-up-environment-configuration)
- [Step 4: Install and Start XAMPP (MySQL/MariaDB)](#step-4-install-and-start-xampp-mysqlmariadb)
- [Step 5: Create and Import the Database](#step-5-create-and-import-the-database)
- [Step 6: Install Frontend Dependencies](#step-6-install-frontend-dependencies)
- [Step 7: Run the Application](#step-7-run-the-application)
- [Running as a Desktop App (Optional)](#running-as-a-desktop-app-optional)
- [Everyday Startup (After First-Time Setup)](#everyday-startup-after-first-time-setup)
- [Where Data is Stored](#where-data-is-stored)
- [Stopping the Application Safely](#stopping-the-application-safely)
- [Troubleshooting](#troubleshooting)
- [Common Questions](#common-questions)
- [Known Limitations](#known-limitations)
- [Additional Notes](#additional-notes)

## What does InkSpeed do?

InkSpeed lets you practice and test your typing speed across different game modes. It tracks your results, saves personal bests per mode, and awards achievements as you improve. User profiles, challenges, results, and round-by-round details are all persisted in a MySQL/MariaDB database managed through XAMPP.

## Verified Features

- **Three Game Modes**: Classic (timed test), Memory Rush (memorize then type blind), Key Chaos (type with scrambled keys)
- **User Management**: Create, rename, and switch between users
- **Results Tracking**: WPM, accuracy, errors, score, and round-by-round details
- **Achievements System**: Unlock achievements based on your performance
- **Personal Bests**: Track your best score per mode
- **Challenge System**: Multiple difficulty levels and categories
- **Leaderboard Support**: View top scores per mode
- **Desktop App Option**: Run via Electron

## Technology Stack

| Component | Technology | Notes |
| --- | --- | --- |
| Frontend | React 19, TypeScript, Vite 8, TanStack Router/Start | Located in `frontend/` |
| UI Components | Tailwind CSS 4, Radix UI | Styled with Tailwind |
| Backend API | Python 3.10+, Flask 3.0 | Located in `backend/` (`api_server.py`, `main.py`) |
| Database | MySQL/MariaDB (via XAMPP) | Port 3306 by default, database name `inkspeed_db` |
| Desktop | Electron 38 | Optional desktop launcher in `frontend/electron/main.cjs` |

## Requirements

Before you begin, install the following on your Windows laptop:

| Software | Minimum Version | Download Link | Notes |
| --- | --- | --- | --- |
| **Python** | 3.10 or newer | [python.org/downloads](https://www.python.org/downloads/) | During installation, check "Add Python to PATH". |
| **Node.js** | LTS (v18+ recommended) | [nodejs.org](https://nodejs.org/) | npm comes bundled with Node.js. |
| **XAMPP** | Recent version with MariaDB/MySQL | [apachefriends.org/download.html](https://www.apachefriends.org/download.html) | Required for the MySQL database. |
| **Visual Studio Code** | Latest | [code.visualstudio.com](https://code.visualstudio.com/) | Recommended for opening and running the project. |

## Important Files and Project Structure

```text
InkSpeed-main/
├── backend/                    # Python Flask API
│   ├── api_server.py          # Main API server (Flask)
│   ├── main.py                # Backend entry point
│   ├── requirements.txt       # Python dependencies
│   ├── database/              # Database connection, schema, and manager
│   │   ├── connection.py      # MySQL connection & auto-initialization
│   │   ├── database_manager.py# Database operations
│   │   ├── schema.sql         # Base database schema
│   │   └── seed.sql           # Sample seed data
│   ├── models/                # Data models
│   └── tests/                 # Backend tests
├── frontend/                  # React frontend
│   ├── package.json           # Node dependencies & scripts
│   ├── electron/              # Electron desktop app
│   │   └── main.cjs
│   └── src/                   # Frontend source code
├── .env.example               # Example environment variables
├── .gitignore
└── README.md
```

**Key entry points:**
- **Backend API**: `backend/main.py` (starts Flask on `http://127.0.0.1:5000`)
- **Frontend Dev Server**: `frontend/package.json` script `dev` (starts Vite, typically on `http://localhost:5173`)
- **Electron**: `frontend/electron/main.cjs` (launches both backend and frontend)

## Downloading the Project (ZIP Method - Recommended for Presentations)

If you're downloading this for a presentation on another laptop (no Git knowledge required):

1. Go to the GitHub repository in your web browser.
2. Click the green **"Code"** button near the top of the repository.
3. Select **"Download ZIP"** from the dropdown menu.
4. The ZIP file (e.g., `InkSpeed-main.zip`) will download to your default Downloads folder.

> **Note:** Downloading as ZIP is different from cloning with `git clone`. The ZIP method is what this guide uses and requires no Git installation.

## Extracting and Opening the Project

1. **Extract the ZIP:**
   - Navigate to your Downloads folder
   - Right-click `InkSpeed-main.zip` → **Extract All...**
   - Choose a destination (e.g., `C:\Users\YourName\Documents\` or just extract to a simple location like `C:\InkSpeed\`)
   - Click **Extract**

2. **Find the correct folder to open:**
   - After extraction, you'll see a folder (commonly named `InkSpeed-main` or `InkSpeed-main-main`)
   - **Open THIS folder** in VS Code - not the parent folder containing it
   - To verify it's correct, this folder must contain `README.md`, `backend/`, `frontend/`, and `.env.example` at the root level

3. **Open in Visual Studio Code:**
   - Open VS Code
   - Go to **File → Open Folder...**
   - Select the extracted project folder (e.g., `C:\InkSpeed-main`)
   - Click **Select Folder**

4. **Open a terminal:**
   - In VS Code, go to **Terminal → New Terminal**
   - This will open a PowerShell terminal in the project root
   - Verify you're in the correct directory by typing: `pwd` or checking the path shown. You should see the path to your InkSpeed folder.

## Setting Up Prerequisites

### Verify Installations

Open a terminal in the project root and verify your installations:

```powershell
py --version
node --version
npm --version
```

- `py --version` should show Python 3.10+
- `node --version` and `npm --version` should show versions

If any command is not recognized, reinstall that software and make sure it's added to PATH (especially Python).

## Step 1: Create and Activate Python Virtual Environment

From the **project root** in PowerShell:

```powershell
py -m venv backend\.venv
```

Activate the virtual environment:

```powershell
.\backend\.venv\Scripts\Activate.ps1
```

> **If you get a PowerShell execution policy error:** Run this command once to allow local scripts (only for your user): 
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
> Then try activating again.

When activated, you should see `(.venv)` at the beginning of your terminal prompt.

## Step 2: Install Backend Dependencies

With the virtual environment activated:

```powershell
pip install -r backend\requirements.txt
```

This installs Flask, mysql-connector-python, and pytest.

## Step 3: Set Up Environment Configuration

The app uses MySQL with defaults that work with a fresh XAMPP installation. You have two options:

**Option A (Recommended for most users):** No `.env` file needed - the app uses safe defaults (`127.0.0.1:3306`, user `root`, empty password, database `inkspeed_db`).

**Option B (If you customized XAMPP):** If you changed MySQL credentials, create a `.env` file.

To create `.env` if needed:
1. Copy `.env.example` to `.env` in the project root
2. Edit `.env` with your actual MySQL credentials
3. **Never commit `.env` to Git** - it's already in `.gitignore`

The backend reads these variables via `os.getenv()` in `backend/database/connection.py`. If the database connection fails, check these values match your XAMPP MySQL setup.

## Step 4: Install and Start XAMPP (MySQL/MariaDB)

1. **Download and install XAMPP** from [apachefriends.org](https://www.apachefriends.org/download.html) if not already installed.
2. **Open XAMPP Control Panel** (search for "XAMPP Control Panel" in Windows Start Menu).
3. **Start MySQL/MariaDB**: Click the **Start** button next to "MySQL". Wait until it shows green "Running".
4. **(Optional) Start Apache**: Only needed if you want to access phpMyAdmin via web, which we will use below. Click Start next to "Apache" if not running.

> **Note:** The default XAMPP MySQL setup uses user `root` with no password on `127.0.0.1:3306`. If you've customized this, adjust your `.env` accordingly.

## Step 5: Create and Import the Database

You need to create the `inkspeed_db` database and import the schema.

### Using phpMyAdmin (Recommended)

1. With Apache and MySQL running in XAMPP, open your browser and go to: [http://localhost/phpmyadmin/](http://localhost/phpmyadmin/)
2. Click the **"Databases"** tab at the top
3. Under "Create database", type `inkspeed_db` and select collation `utf8mb4_unicode_ci` (or leave default)
4. Click **"Create"**
5. Select the newly created `inkspeed_db` database from the left sidebar
6. Click the **"Import"** tab at the top
7. Under "File to import", click **"Choose File"** and select `backend/database/schema.sql` from your project
8. Scroll down and click **"Go"**
9. You should see a success message. The tables will be created.

> **Note:** The backend also auto-initializes and migrates the database on startup (see `backend/database/connection.py`). The schema.sql provides the base structure. Running the app will apply additional migrations automatically to ensure all required tables/columns exist.

### Verify Database

In phpMyAdmin, with `inkspeed_db` selected, you should see tables like: `users`, `challenges`, `results`, `round_results`, `achievements`, `user_achievements`, `app_settings`, and additional tables created by migrations.

## Step 6: Install Frontend Dependencies

Open a **second terminal** in VS Code (Terminal → Split Terminal or New Terminal) - keep the backend terminal separate.

Navigate to the frontend folder and install dependencies:

```powershell
cd frontend
npm install
```

This may take a few minutes. Wait for it to complete successfully.

## Step 7: Run the Application

You need **two terminals** running simultaneously - one for the backend, one for the frontend.

### Terminal 1 - Backend API

In your first terminal (project root), with virtual environment activated:

```powershell
.\backend\.venv\Scripts\python.exe .\backend\main.py
```

You should see output indicating the server is running. The API will be available at:
- **API Base**: `http://127.0.0.1:5000`
- **Health Check**: `http://127.0.0.1:5000/api/health`

Leave this terminal running.

### Terminal 2 - Frontend Dev Server

In your second terminal, in the frontend directory:

```powershell
npm run dev
```

Vite will start the dev server. Look for a message like:
```
➜  Local:   http://localhost:5173/
```
or similar. Open that URL in your web browser.

**InkSpeed should now be running!** You can create users, play games, and all data will be saved to your local MySQL database.

## Running as a Desktop App (Optional)

If you want to run InkSpeed as a standalone desktop application using Electron:

1. Make sure MySQL is running in XAMPP
2. Dependencies are installed (backend venv + frontend node_modules)
3. From the `frontend` folder in a terminal:

```powershell
npm run electron
```

The Electron app will automatically start the backend API and the Vite dev server, wait for them to be ready, then open the desktop window.

## Everyday Startup (After First-Time Setup)

Once everything is set up, you only need these steps for daily use:

1. **Start XAMPP**: Open XAMPP Control Panel and start **MySQL** (and Apache if needed)
2. **Start Backend**: Open terminal in project root, activate venv (`.\backend\.venv\Scripts\Activate.ps1`), run `.\backend\.venv\Scripts\python.exe .\backend\main.py`
3. **Start Frontend**: Open another terminal in `frontend/`, run `npm run dev`
4. **Open Browser**: Go to `http://localhost:5173` (or the URL shown)

Or use Electron: Just start MySQL in XAMPP, then run `npm run electron` from the `frontend` folder.

## Where Data is Stored

| Data Type | Location |
| --- | --- |
| **User data, results, challenges, achievements** | MySQL/MariaDB database `inkspeed_db` (managed by XAMPP) |
| **Backend dependencies** | `backend/.venv/` (local, not committed) |
| **Frontend dependencies** | `frontend/node_modules/` (local, not committed) |
| **Database backups** | `backend/backups/` if created (excluded from Git) |

## Stopping the Application Safely

- **Frontend/Backend terminals**: Press `Ctrl+C` in each terminal
- **Electron app**: Close the window - it will automatically stop the backend and frontend processes
- **XAMPP**: Stop MySQL (and Apache) from the XAMPP Control Panel when done

## Troubleshooting

| Symptom / Error | Likely Cause | How to Diagnose | Step-by-Step Fix | Alternative Solution |
| --- | --- | --- | --- | --- |
| `'py' is not recognized` or `'python' not found` | Python not installed or not in PATH | Run `py --version` - if error, Python missing | Reinstall Python from python.org, check "Add Python to PATH" during install. Restart terminal/VS Code. | Use `python` or `py -3` instead, or find Python in its install location. |
| PowerShell won't activate venv | Execution policy restriction | Try `.\backend\.venv\Scripts\Activate.ps1` and see error | Run `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` in PowerShell, then try again. | Use Command Prompt (cmd) instead: `backend\.venv\Scripts\activate.bat` |
| `ModuleNotFoundError: No module named 'flask'` or similar | Dependencies not installed in venv | Check if venv is activated (`(.venv)` in prompt) | Activate venv, run `pip install -r backend\requirements.txt` from project root. | Verify with `pip list` that flask, mysql-connector-python are installed. |
| `Can't reach the database. Make sure MySQL is running in XAMPP...` | MySQL not running or wrong credentials | Check XAMPP Control Panel - MySQL should be green/running. Try phpMyAdmin. | Start MySQL in XAMPP. Verify database `inkspeed_db` exists. Check defaults match (root, no password). | Create `.env` with correct `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`. Check if MySQL is on different port. |
| XAMPP MySQL won't start | Port 3306 in use or config issue | Check XAMPP logs, or see if another MySQL is running | Stop other MySQL instances. Check port conflicts. Try changing MySQL port in XAMPP config if needed. | Use different port and update `MYSQL_PORT` in `.env`. |
| Database `inkspeed_db` doesn't exist | Not created yet | Check phpMyAdmin - database not listed | Create database in phpMyAdmin or let backend auto-create it. Backend calls `initialize_database()` on startup. | Import `backend/database/schema.sql` via phpMyAdmin Import tab. |
| Tables missing | Schema not imported | Check tables in phpMyAdmin under `inkspeed_db` | Run the app once - backend auto-initializes. Or manually import schema.sql. | The app's `initialize_database()` will create tables and run migrations automatically. |
| SQL import fails in phpMyAdmin | File too large, encoding issue, or syntax error | Check phpMyAdmin error message | Use the app's auto-initialization (just start backend) instead of manual import. Or split/import differently. | Ensure schema.sql is from the project as-is. The backend is designed to initialize on startup. |
| `npm install` fails | Network issue or Node version problem | Check Node version with `node --version` | Use Node LTS. Clear npm cache: `npm cache clean --force`. Try again. | Delete `frontend/node_modules` and `frontend/package-lock.json`, run `npm install` again. |
| `npm run dev` fails or port in use | Port 5173 already in use | Error will say port in use | Kill the process using port 5173, or Vite will suggest another port. | Use `npx kill-port 5173` or stop other dev servers. |
| Backend port 5000 in use | Another process using port 5000 | Flask will fail to bind | Find and stop the process using port 5000. | Change port in `backend/main.py` and `backend/api_server.py`, update frontend API URL. |
| Wrong folder opened in VS Code | Opened parent folder | Check - should see `backend/`, `frontend/` directly in explorer root | Close VS Code, open the correct extracted folder that contains README.md at its root. | Verify by looking for `backend/main.py` and `frontend/package.json`. |
| Electron can't start Python | Wrong path or venv missing | Electron looks for `backend/.venv/Scripts/python.exe` | Create venv and install deps as per Step 1-2. Verify the file exists. | Check `frontend/electron/main.cjs` - it expects the venv at `backend/.venv/`. |
| App opens but can't load data | Backend not running or DB issue | Check browser console/network tab, backend terminal for errors | Ensure backend is running on port 5000. Check MySQL is running. Test health: `http://127.0.0.1:5000/api/health` | Check CORS - backend allows requests from browser. Verify API URL in frontend defaults to `http://127.0.0.1:5000/api`. |
| Frontend can't connect to backend | API URL misconfigured | Check `frontend/src/lib/inkspeed.ts` - defaults to `http://127.0.0.1:5000/api` | Ensure backend is running. If needed, set `VITE_API_URL` in frontend `.env`. | Test backend health endpoint directly in browser. |

## Common Questions

**Q: Do I need to install Git?**  
A: No. For presentation, download as ZIP from GitHub - no Git required.

**Q: What's the difference between downloading ZIP and cloning?**  
A: ZIP downloads all files as-is without Git history. Cloning with `git clone` requires Git installed and creates a `.git` folder. Both work fine; ZIP is easier for non-technical users.

**Q: Do I need Apache running?**  
A: Only if you want to use phpMyAdmin through the browser. The InkSpeed app itself doesn't need Apache - it uses Flask backend directly. MySQL/MariaDB is required though.

**Q: Can I use a different MySQL port or credentials?**  
A: Yes. Create a `.env` file in the project root (copy from `.env.example`) and set `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE` to match your setup.

**Q: Will the database be created automatically?**  
A: The backend's `initialize_database()` function (called by `main.py`) will create the database if it doesn't exist and run schema migrations automatically. However, it's safer to ensure MySQL is running and you can access it. The base schema is in `backend/database/schema.sql`.

**Q: Do I need to import seed data?**  
A: Not strictly necessary. The backend has `seed_defaults()` in `database_manager.py` that seeds achievements and some challenges on startup. `seed.sql` provides additional sample data if you want to import it.

**Q: The app says "Can't reach the database" - what do I do?**  
A: Make sure MySQL is running in XAMPP (green in Control Panel). Verify the database exists. Check that your credentials match (default is root with no password). Try the health check at `http://127.0.0.1:5000/api/health` after starting the backend.

## Known Limitations

- **Windows-focused instructions**: These instructions are written for Windows. Linux/Mac may work but paths and commands differ.
- **XAMPP dependency**: Designed to work with XAMPP's MySQL/MariaDB setup. Other MySQL servers can work with proper configuration.
- **Development mode**: Running via `npm run dev` and `main.py` is for development. Not configured for production deployment.
- **Port assumptions**: Defaults to ports 5000 (backend) and 5173 (frontend). If these are in use, you'll need to adjust.
- **Virtual environment required**: Backend must run in the Python virtual environment with dependencies installed.

## Additional Notes

- **Backend tests**: Run with `.\backend\.venv\Scripts\python.exe -m pytest .\backend\tests` from project root
- **Frontend tests**: Run with `npm test` from `frontend/` folder
- **Linting**: Run `npm run lint` from `frontend/` folder
- **The backend auto-migrates**: `initialize_database()` adds missing columns/tables and applies extensions on each startup, so it's safe to run repeatedly.

**Ready to start?** Follow the steps in order from [Step 1](#step-1-create-and-activate-python-virtual-environment) through [Step 7](#step-7-run-the-application). If you run into issues, check the [Troubleshooting](#troubleshooting) section above.
