# InkSpeed

InkSpeed is a typing-speed game with three modes:

- **Classic** — type a passage before the timer runs out.
- **Memory Rush** — memorize a passage, then type it from memory.
- **Key Chaos** — type while the keys are scrambled.

It uses a React 19 / TypeScript frontend (Vite 8, TanStack Router) with an optional Electron desktop window, a Python Flask API, and a local MySQL/MariaDB database managed through XAMPP.

The application ships with **78 typing challenges across 8 categories** (`Proverbs`, `Nature`, `Technology`, `Literature`, `Science`, `Education`, `Health`, `Business`). On a new computer they are created automatically the first time the backend starts. No database files need to be copied from another machine.

---

## 1. What you need

| Software | Supported version | Verified with |
| --- | --- | --- |
| Windows | Windows 10 or Windows 11, 64-bit | Windows 11 |
| Python | **3.11 or newer** | Python 3.14.8 |
| Node.js | **20.19.x LTS or 22.12+** (Vite 8 requirement) | Node.js 24.12.0, npm 11.6.2 |
| XAMPP | Any recent version with MySQL/MariaDB | XAMPP with MariaDB 10.4.32 |
| VS Code | Latest | Latest |

Notes:

- Python 3.11+ is required because the code uses `enum.StrEnum`.
- Node.js 18 and early 20.x **do not work** with the installed Vite 8.1.5. Install the current Node.js LTS from <https://nodejs.org/>.
- XAMPP provides both MySQL/MariaDB (required) and Apache (only needed for phpMyAdmin).
- Git is **not** required. The ZIP download below is enough.

### Ports used

| Port | Used by | Started by |
| --- | --- | --- |
| 3306 | MySQL/MariaDB | XAMPP Control Panel |
| 5000 | Flask backend API | Electron, or `backend\main.py` |
| 5173 | Vite dev server (browser mode) | `npm run dev` |
| 5174 | Vite dev server (Electron mode) | Electron launcher |
| 80 / 443 | Apache / phpMyAdmin | XAMPP Control Panel |

Only one copy of the app should run at a time.

---

## 2. Download the correct repository as a ZIP

1. Open this address in a web browser:
   **<https://github.com/D4C-4/InkSpeed-Main>**
2. Click the green **Code** button.
3. Click **Download ZIP**.
4. The file downloads as `InkSpeed-Main-main.zip` (usually into `Downloads`).

> Download the ZIP from `D4C-4/InkSpeed-Main`, not from any other InkSpeed repository. This is the presentation copy.

---

## 3. Extract the ZIP

1. Open **File Explorer** and go to your **Downloads** folder.
2. Right-click `InkSpeed-Main-main.zip` → **Extract All…**
3. Extract it to a simple local folder, for example `C:\InkSpeed-Main-main`.
   - Avoid extracting into `C:\Program Files`, and do not run the app from inside the ZIP preview.
4. Open the extracted folder. Its root must directly contain:

```text
README.md
.env.example
backend\
frontend\
database\
scripts\
```

If you see another folder inside the extracted folder (for example `InkSpeed-Main-main\InkSpeed-Main-main`), open the inner folder that contains `backend\main.py`.

---

## 4. Open the folder in VS Code

1. Open **Visual Studio Code**.
2. **File → Open Folder…**
3. Select the folder from step 3 (the one containing `backend`, `frontend`, and `README.md`).
4. **Terminal → New Terminal**. A **PowerShell** terminal opens in the project root.

Verify the location before continuing:

```powershell
Get-Location
Test-Path .\backend\main.py
```

Expected result: the path ends with your extracted folder name, and `Test-Path` prints `True`.

All PowerShell commands below are run **from the project root** unless a step says otherwise.

---

## 5. Create and activate the Python virtual environment

In the **VS Code PowerShell terminal** (project root):

```powershell
python -m venv backend\.venv
.\backend\.venv\Scripts\Activate.ps1
```

Expected result: the prompt now begins with `(.venv)`.

If PowerShell blocks the activation script:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\backend\.venv\Scripts\Activate.ps1
```

If `python` opens the Microsoft Store or is not found, install Python 3.11+ from <https://www.python.org/downloads/> and tick **Add python.exe to PATH**. You can also use `py -3` instead of `python` for the commands below.

> The virtual environment must live at exactly `backend\.venv`. The Electron launcher starts `backend\.venv\Scripts\python.exe`; an environment created anywhere else will not be found.

---

## 6. Install Python dependencies

With `(.venv)` active, from the project root:

```powershell
python -m pip install --upgrade pip
python -m pip install -r backend\requirements.txt
```

Expected result: the last line contains `Successfully installed ...` (or `Requirement already satisfied`).

This installs Flask, `mysql-connector-python`, and pytest. No additional `.env` library is needed — the backend loads `.env` itself.

---

## 7. Install frontend dependencies

From the project root:

```powershell
cd .\frontend
npm ci
cd ..
```

Expected result: npm finishes without `ERESOLVE` errors and creates `frontend\node_modules`.

`npm ci` installs exactly the committed `frontend\package-lock.json`. Do not delete that lockfile. If `npm ci` reports that the lockfile is out of sync, run `npm install`, then `cd ..`.

Check the versions:

```powershell
node --version
npm --version
```

Node must print `v20.19.x` (the 20.x LTS line), `v22.12.x` or newer, or `v24.x`. Node 18, Node 21, and Node 22.0–22.11 are not supported by this Vite version.

---

## 8. Install and start XAMPP

1. Install XAMPP from <https://www.apachefriends.org/download.html> if it is not already installed.
2. Open **XAMPP Control Panel** from the Windows Start Menu.
3. Click **Start** next to **MySQL**. Wait for the module to turn green and show a PID.
4. Click **Start** next to **Apache** if you want to use phpMyAdmin in a browser.

Default XAMPP MySQL settings (the app assumes these unless `.env` says otherwise):

```text
Host:     127.0.0.1
Port:     3306
User:     root
Password: (empty)
```

If port 3306 is already occupied, see [Troubleshooting](#15-troubleshooting). Do not click **Stop** while the game is running.

---

## 9. Create the `.env` file

In the **VS Code PowerShell terminal**, from the project root:

```powershell
Copy-Item .env.example .env
Get-Content .env
```

Expected result: the file lists the five `MYSQL_*` variables.

The default file is already correct for a fresh XAMPP install:

```env
MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=
MYSQL_DATABASE=inkspeed_db
```

- `MYSQL_DATABASE=inkspeed_db` is the **fresh-install** database. InkSpeed creates it automatically.
- `inkspeed_db_recovered` is a local database on the development laptop only. Do **not** use that name on a new computer.
- If your XAMPP root account has a password, put it in `MYSQL_PASSWORD` (no quotes needed).
- `.env` is ignored by Git. `.env.example` is the tracked template. Never commit real passwords.

The backend reads `.env` from the project root (and `backend\.env` if present) every time it starts, but real Windows environment variables take priority over the file. If you edit `.env`, restart the backend/Electron.

---

## 10. Initialize the database and starter data

This happens automatically. You do not have to create tables or import SQL.

To initialize and verify it manually, from the project root:

```powershell
.\backend\.venv\Scripts\python.exe .\backend\main.py
```

Expected output (order may vary slightly):

```text
INFO database.connection: Preparing database `inkspeed_db`.
INFO database.connection: Database `inkspeed_db` is ready.
 * Running on http://127.0.0.1:5000
 * Debug mode: off
```

What happened during those seconds:

1. Database `inkspeed_db` was created if it did not exist.
2. All tables, lookup rows (roles, game modes), indexes, and foreign keys were created.
3. Achievements were seeded.
4. The 78 challenges in `backend\database\challenge_seed.json` and their 8 categories were inserted.

The initialization and seeding are idempotent: starting the backend again does **not** duplicate challenges, categories, or achievements.

Stop the manual backend with **Ctrl+C** before launching Electron, so port 5000 is free.

> Flask may print: `Tip: There are .env files present. Install python-dotenv to use them.` You can ignore this. InkSpeed loads `.env` itself in `backend\database\connection.py`; `python-dotenv` is not required.

Verify in a browser: <http://127.0.0.1:5000/api/health>

Expected result: a JSON response `{"ok": true}` while the backend is running.

### Verify the database in phpMyAdmin (browser)

1. Make sure **Apache** and **MySQL** are running in the XAMPP Control Panel.
2. Open <http://localhost/phpmyadmin/> in a browser.
3. Click **Databases** → `inkspeed_db`.
4. Open the **SQL** tab and run:

```sql
SELECT COUNT(*) AS challenges FROM challenges;
SELECT COUNT(*) AS categories FROM challenge_categories;
SELECT COUNT(*) AS users FROM users;
```

Expected result: **78** challenges, **8** categories, and **0** users on a fresh installation. Users appear only after you create a profile in the game.

> Do not import `database\inkspeed_schema.sql` or `backend\database\seed.sql` by hand on a fresh laptop. The backend performs the schema creation, migrations, and starter-data seed automatically. Those SQL files are legacy/reference files and are not required.

---

## 11. Launch InkSpeed

### Recommended: Electron desktop app

1. Confirm **MySQL is running** in XAMPP.
2. In the **VS Code PowerShell terminal**, from the project root:

```powershell
.\scripts\run_electron.bat
```

Or, equivalently:

```powershell
cd .\frontend
npm run electron
```

Expected result: the InkSpeed desktop window opens. The launcher starts the Flask backend on port 5000 and its own Vite server on port **5174**, waits for both, then opens the window. First launch can take 30–60 seconds while Vite starts.

The Electron launcher notes:

- If a healthy InkSpeed backend is already running on port 5000, it reuses it.
- If a healthy InkSpeed Vite server is already running on port 5174, it reuses it and leaves it running after the window closes.
- Processes started by the window are stopped when the window closes.
- If port 5174 or 5000 is held by something else, an error dialog explains how to find the owner. See [Troubleshooting](#15-troubleshooting).

### Alternative: browser mode (two terminals)

**Terminal 1 — backend** (project root):

```powershell
.\backend\.venv\Scripts\python.exe .\backend\main.py
```

**Terminal 2 — frontend** (new terminal, project root):

```powershell
cd .\frontend
npm run dev
```

Open the URL printed by Vite, normally <http://localhost:5173/>. Keep both terminals running; stop them with **Ctrl+C**.

The frontend always calls the API at `http://127.0.0.1:5000/api` unless `VITE_API_URL` is set in `frontend\.env`.

---

## 12. Test the game

1. **Create a profile**: enter a username (4–20 characters; letters, numbers, `_`, `.`, `-`) and confirm. It appears in the header/profile list.
2. **Play Classic**: choose Classic and a difficulty, type the passage, finish the round.
3. **Save the result**: the result screen shows WPM, accuracy, errors, and score. Confirm it saved without an error.
4. **Check history**: open the history/dashboard view; the result you just saved must appear.
5. **Play Memory Rush**: complete at least one round and save it.
6. **Play Key Chaos**: complete a round and save it.
7. **Check achievements**: the result screen or profile should show unlocked achievements (for example *First Ink* after the first saved result).
8. **Check database**: refresh phpMyAdmin and confirm rows now exist in `results`, `round_results`, `user_achievements`, and `personal_bests`. The `challenges` table must still contain **78** rows (playing the game does not add or remove challenges).

---

## 13. Close InkSpeed safely

- **Electron**: close the window. The launcher stops the backend and Vite processes that it started.
- **Browser mode**: press **Ctrl+C** in both terminals.
- **XAMPP**: leave MySQL running while you present. Stop it from the XAMPP Control Panel only when you are finished.

Reopening the app later requires only: XAMPP MySQL running → `.\scripts\run_electron.bat`.

---

## 14. Everyday startup (after the first setup)

In the **VS Code PowerShell terminal**, from the project root:

```powershell
.\scripts\run_electron.bat
```

No reinstall and no database import are needed. The `.venv`, `node_modules`, and `inkspeed_db` database already exist on that laptop.

Other helper scripts (all must be started from the project root and all fix their own working directory):

| Script | Purpose |
| --- | --- |
| `scripts\setup.bat` | Creates or updates the venv, installs Python deps, runs `npm ci` |
| `scripts\run_backend.bat` | Starts only the Flask API on port 5000 |
| `scripts\run_frontend.bat` | Starts only Vite (browser mode) on port 5173 |
| `scripts\run_electron.bat` | Starts the full Electron desktop app |

---

## 15. Troubleshooting

### `Missing .env` / environment variables are ignored

The app works with XAMPP defaults even without `.env`, but create it anyway:

```powershell
Copy-Item .env.example .env
```

`.env` must be in the project root next to `README.md`, not in `backend\` or `frontend\`. Restart the backend after editing it. Windows environment variables override `.env`, so make sure no old `MYSQL_*` variables are set system-wide:

```powershell
Get-ChildItem Env:MYSQL_*
```

### Wrong database name

If `MYSQL_DATABASE` is not `inkspeed_db`, InkSpeed creates a database with whatever name is there and seeds it. Check `.env`, then look for that exact name in phpMyAdmin. A fresh laptop should use:

```env
MYSQL_DATABASE=inkspeed_db
```

### Connection refused / access denied

Typical messages:

```text
Can't connect to MySQL server on '127.0.0.1' (10061)
Access denied for user 'root'@'localhost'
```

Fix:

1. Open **XAMPP Control Panel** and confirm **MySQL** is green/running.
2. Confirm the port in `.env` matches XAMPP (default `3306`).
3. If you set a MySQL root password, put it in `MYSQL_PASSWORD`.
4. Test the API again: <http://127.0.0.1:5000/api/health>.

The backend prints a clear error and exits instead of starting with a broken database.

### MariaDB will not start / port 3306 is occupied

In an **administrator PowerShell**:

```powershell
Get-NetTCPConnection -LocalPort 3306 -State Listen | Select-Object LocalAddress,LocalPort,OwningProcess
Get-Process -Id <PID>
```

- If the owner is another MySQL/MariaDB service, stop that service (Services app) or change XAMPP's MySQL port.
- If you change the XAMPP port, update `MYSQL_PORT` in `.env` to the same value.
- Read the XAMPP MySQL log (`C:\xampp\mysql\data\mysql_error.log`) for the real reason when startup fails.

Do not delete MySQL data files to "fix" startup; that destroys the database.

### Missing tables or error 1932 (`doesn't exist in engine`)

InkSpeed checks for unreadable InnoDB tables before changing anything and stops with:

```text
MariaDB cannot open table(s) ... (error 1932: "doesn't exist in engine")
```

`CREATE TABLE IF NOT EXISTS` cannot repair a damaged InnoDB tablespace, so the app refuses to continue rather than silently pretending the table exists.

Fix on the presentation laptop (fresh install, no data to keep):

1. Stop MySQL in XAMPP.
2. In phpMyAdmin (Apache + MySQL running), drop the broken database, or simply set a new name in `.env` (for example `MYSQL_DATABASE=inkspeed_db_new`).
3. Start the backend again — it creates the full schema and seeds 78 challenges.

On a machine with data you need, restore the database from a SQL dump/backup instead of dropping it. Keep the damaged files until the data has been reviewed.

### Missing Python or Node.js dependencies

- Python: `ModuleNotFoundError: No module named 'flask'` → from the project root:

  ```powershell
  .\backend\.venv\Scripts\Activate.ps1
  python -m pip install -r backend\requirements.txt
  ```

- Node: `Cannot find module ...` or `vite is not recognized` → from the project root:

  ```powershell
  cd .\frontend
  npm ci
  cd ..
  ```

### Incompatible Node.js version

Vite 8.1.5 requires Node `^20.19.0 || >=22.12.0`. Symptoms include engine warnings/errors and startup crashes.

```powershell
node --version
```

If it prints `v18.x` or `v20.x` below `20.19`, install the current Node.js LTS from <https://nodejs.org/>, close VS Code, reopen it, and run `npm ci` again.

### Port 5174 is already in use (Electron)

This means a previous Vite dev server is still running. The Electron launcher will not kill a process it cannot prove it owns, so stop the old process manually:

```powershell
Get-NetTCPConnection -LocalPort 5174 -State Listen | Select-Object LocalAddress,LocalPort,OwningProcess
Get-Process -Id <PID>
Stop-Process -Id <PID>
```

Do the same for port 5000 if the dialog reports the API port. Only stop a PID whose process path/name clearly belongs to Node/Vite or Python/InkSpeed. Do not kill unrelated applications.

To avoid the conflict, close old InkSpeed windows and terminals, and do not run two copies of the app at once. In browser mode Vite uses port 5173, so it does not collide with Electron's 5174.

### Incorrect project or working directory

Symptoms: `backend\main.py was not found`, `backend\.venv not found`, `Could not read the challenge starter data ...`, or `npm` errors about a missing `package.json`.

Check:

```powershell
Get-Location
Test-Path .\backend\main.py
Test-Path .\frontend\package.json
```

Both `Test-Path` commands must print `True`. If not, run `cd` into the extracted folder that contains `backend`, `frontend`, and `README.md`, or double-click `scripts\setup.bat` from that folder.

### The window opens but shows no data

1. Check <http://127.0.0.1:5000/api/health>.
2. Look at the terminal/Electron console for Python errors.
3. Confirm MySQL is running and `.env` points at the right database.
4. Restart the app after fixing `.env`.

---

## 16. Project structure

```text
InkSpeed-Main-main\
├── backend\
│   ├── api_server.py              Flask routes
│   ├── main.py                    Initializes DB + seeds + starts API on 5000
│   ├── requirements.txt           Python dependencies
│   ├── database\
│   │   ├── connection.py          .env loader, DB creation, migrations, health checks
│   │   ├── database_manager.py    Repository layer + seeding
│   │   ├── challenge_seed.json    Portable 78-challenge starter library
│   │   ├── schema.sql             Base schema (applied automatically)
│   │   └── seed.sql               Legacy sample SQL (not needed for fresh install)
│   ├── migrations\                Additive schema migrations
│   └── models\                    Domain models (users, challenges, results)
├── frontend\
│   ├── electron\main.cjs          Desktop launcher (ports 5000 + 5174)
│   ├── src\                       React application
│   ├── package.json
│   └── package-lock.json          Committed lockfile used by npm ci
├── database\                      Legacy reference SQL files
├── scripts\                       setup.bat / run_*.bat helpers
├── .env.example                   Tracked configuration template
├── .gitignore
└── README.md
```

Not included in the ZIP (created locally): `.env`, `backend\.venv\`, `frontend\node_modules\`.

---

## 17. Development notes

- Backend tests: this snapshot does not include a `backend\tests` folder, so `pytest` collects no tests. Do not treat a bare `pytest` run as verification.
- Frontend tests: `npm test` runs `vitest run`; this snapshot does not include test files, so it exits with “No test files found”.
- Linting: `cd frontend; npm run lint`.
- Database initialization is additive and safe to rerun. It never drops existing tables or user data.
- The challenge library is read from `backend\database\challenge_seed.json` at startup. Editing that file and restarting the backend adds new passages (matched by passage text) without duplicating existing ones.

---

## 18. Quick checklist for presentation day

- [ ] XAMPP Control Panel: MySQL is green.
- [ ] `C:\...\InkSpeed-Main-main\.env` exists with `MYSQL_DATABASE=inkspeed_db`.
- [ ] `backend\.venv\Scripts\python.exe` exists.
- [ ] `frontend\node_modules` exists.
- [ ] `.\scripts\run_electron.bat` opens the window.
- [ ] A test profile can save a Classic result and show it in history.
- [ ] phpMyAdmin shows 78 challenges and 8 categories.

If any item fails, see the matching troubleshooting section before the presentation.
