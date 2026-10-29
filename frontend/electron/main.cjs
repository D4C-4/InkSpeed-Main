const { app, BrowserWindow, dialog } = require("electron");
const { spawn, spawnSync } = require("node:child_process");
const fs = require("node:fs");
const net = require("node:net");
const path = require("node:path");

const projectRoot = path.resolve(__dirname, "..", "..");
const backendRoot = path.join(projectRoot, "backend");
const frontendRoot = path.resolve(__dirname, "..");
const python = path.join(backendRoot, ".venv", "Scripts", "python.exe");
const apiUrl = "http://127.0.0.1:5000/api/health";
const webUrl = "http://127.0.0.1:5174";
const webPort = 5174;

const ownedChildren = new Set();
let quitting = false;

function log(message) {
  console.log(`[InkSpeed] ${message}`);
}

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function startProcess(label, command, args, cwd) {
  log(`Starting ${label}: ${command} ${args.join(" ")}`);
  const child = spawn(command, args, {
    cwd,
    env: { ...process.env, BROWSER: "none" },
    shell: false,
    windowsHide: true,
    stdio: "pipe",
  });
  const handle = { label, child, stderr: "", spawnError: null };
  ownedChildren.add(handle);
  child.stdout.on("data", (data) => process.stdout.write(data));
  child.stderr.on("data", (data) => {
    handle.stderr = (handle.stderr + data.toString()).slice(-4000);
    process.stderr.write(data);
  });
  child.on("error", (error) => {
    handle.spawnError = error;
    console.error(`Unable to start ${label}:`, error);
  });
  child.on("exit", (code, signal) => {
    ownedChildren.delete(handle);
    if (!quitting && code !== 0 && code !== null) {
      log(`${label} exited unexpectedly (code ${code}${signal ? `, signal ${signal}` : ""}).`);
    }
  });
  return handle;
}

function lastOutput(handle) {
  const tail = handle && handle.stderr.trim();
  return tail ? `\n\nLast output from ${handle.label}:\n${tail}` : "";
}

function isRunning(handle) {
  return Boolean(handle) && !handle.spawnError && handle.child.exitCode === null;
}

function isPortInUse(port) {
  return new Promise((resolve) => {
    const socket = net.connect({ host: "127.0.0.1", port });
    const finish = (inUse) => {
      socket.removeAllListeners();
      socket.destroy();
      resolve(inUse);
    };
    socket.setTimeout(1000);
    socket.once("connect", () => finish(true));
    socket.once("timeout", () => finish(true));
    socket.once("error", () => finish(false));
  });
}

async function fetchText(url, timeoutMs = 4000) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  try {
    const response = await fetch(url, { signal: controller.signal });
    return { ok: response.ok, status: response.status, text: await response.text() };
  } finally {
    clearTimeout(timer);
  }
}

async function probe(url, timeoutMs) {
  try {
    return await fetchText(url, timeoutMs);
  } catch {
    return null;
  }
}

function portOwnerHint(port) {
  return [
    "InkSpeed did not stop that process because it cannot prove it belongs to this app.",
    "Check the owner, then stop it only if it is an old InkSpeed/Vite process:",
    `  Get-NetTCPConnection -LocalPort ${port} -State Listen | Select-Object LocalAddress,LocalPort,OwningProcess`,
    "  Get-Process -Id <process id>",
    "  Stop-Process -Id <process id>",
  ].join("\n");
}

async function ensureWebServer() {
  if (await isPortInUse(webPort)) {
    const existing = await probe(webUrl, 5000);
    if (existing && existing.ok && existing.text.toLowerCase().includes("inkspeed")) {
      log(`Reusing the InkSpeed dev server already running at ${webUrl}.`);
      log("That server was not started by this window, so it will be left running on exit.");
      return null;
    }
    if (existing) {
      throw new Error(
        `Port ${webPort} is already used by another application (HTTP ${existing.status}) ` +
          `that does not look like the InkSpeed dev server.\n\n${portOwnerHint(webPort)}`,
      );
    }
    throw new Error(
      `Port ${webPort} is in use by a process that is not responding. ` +
        `A previous Vite dev server was probably left behind.\n\n${portOwnerHint(webPort)}`,
    );
  }

  const npmCommand = process.platform === "win32" ? process.env.ComSpec : "npm";
  const npmArgs =
    process.platform === "win32"
      ? ["/d", "/s", "/c", "npm.cmd run dev -- --host 127.0.0.1 --port 5174 --strictPort"]
      : ["run", "dev", "--", "--host", "127.0.0.1", "--port", "5174", "--strictPort"];
  return startProcess("Vite dev server", npmCommand, npmArgs, frontendRoot);
}

async function ensureApiServer() {
  if (await isPortInUse(5000)) {
    const existing = await probe(apiUrl, 5000);
    if (existing && existing.ok) {
      log(`Reusing the InkSpeed API already running at ${apiUrl}.`);
      log("That API was not started by this window, so it will be left running on exit.");
      return null;
    }
    throw new Error(
      `Port 5000 is already in use by a process that is not the InkSpeed API.\n\n` +
        portOwnerHint(5000),
    );
  }

  if (!fs.existsSync(python)) {
    throw new Error(
      `Python was not found at:\n${python}\n\n` +
        "Create backend/.venv and install backend/requirements.txt " +
        "(see README.md, steps 1 and 2).",
    );
  }
  return startProcess("InkSpeed API", python, ["main.py"], backendRoot);
}

async function waitFor(url, handle, timeoutMs = 60000) {
  const started = Date.now();
  while (Date.now() - started < timeoutMs) {
    if (handle && handle.spawnError) {
      throw new Error(
        `${handle.label} could not be started: ${handle.spawnError.message}${lastOutput(handle)}`,
      );
    }
    if (handle && !isRunning(handle)) {
      throw new Error(
        `${handle.label} stopped before ${url} became available ` +
          `(exit code ${handle.child.exitCode}).${lastOutput(handle)}`,
      );
    }
    const response = await probe(url, 1500);
    if (response && response.ok) return;
    await delay(250);
  }
  throw new Error(`Timed out waiting for ${url}.${lastOutput(handle)}`);
}

function stopProcess(handle) {
  if (!handle || !handle.child || handle.child.exitCode !== null) return;
  const { pid } = handle.child;
  log(`Stopping ${handle.label} (pid ${pid}).`);
  if (process.platform === "win32") {
    // The dev server is launched through cmd.exe, so killing only the direct
    // child leaves node/vite orphaned and holding the port. Kill the tree.
    spawnSync("taskkill", ["/pid", String(pid), "/T", "/F"], {
      windowsHide: true,
      stdio: "ignore",
    });
  } else {
    handle.child.kill("SIGTERM");
  }
}

function stopOwnedChildren() {
  for (const handle of [...ownedChildren]) {
    stopProcess(handle);
  }
  ownedChildren.clear();
}

async function createWindow() {
  let apiHandle = null;
  let webHandle = null;
  try {
    apiHandle = await ensureApiServer();
    webHandle = await ensureWebServer();
    await waitFor(apiUrl, apiHandle);
    await waitFor(webUrl, webHandle);

    const window = new BrowserWindow({
      width: 1280,
      height: 820,
      minWidth: 960,
      minHeight: 640,
      backgroundColor: "#f4efe0",
      webPreferences: {
        contextIsolation: true,
        nodeIntegration: false,
      },
    });
    await window.loadURL(webUrl);
  } catch (error) {
    console.error("[InkSpeed] Startup failed:", error.message);
    dialog.showErrorBox("InkSpeed could not start", error.message);
    quitting = true;
    stopOwnedChildren();
    app.quit();
  }
}

app.whenReady().then(createWindow);

app.on("window-all-closed", () => {
  quitting = true;
  stopOwnedChildren();
  if (process.platform !== "darwin") app.quit();
});

app.on("before-quit", () => {
  quitting = true;
  stopOwnedChildren();
});
