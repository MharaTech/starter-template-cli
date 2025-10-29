# 🚀 Production-Ready Project Template Generator

## 📘 Overview

This repository contains cross-platform scripts that help developers quickly scaffold **production-ready starter templates** for:

- 🟦 Java (Maven)
- 🐍 Python
- 🟩 Node.js
- ⚛️ React.js (Vite)
- 🌐 Next.js

Both Bash (`.sh`) and PowerShell (`.ps1`) versions are provided.

---

## 🧰 Features

- ✅ Interactive CLI prompts
- ✅ Automatic directory creation and initialization
- ✅ Dependency and version checks
- ✅ Production-ready folder structures
- ✅ Optional Git initialization
- ✅ Colorized terminal output
- ✅ OS detection (Linux, macOS, or WSL only)

---

## ⚙️ Supported OS

- **Linux**
- **macOS**
- **Windows Subsystem for Linux (WSL)**

If you run it on unsupported environments (like Git Bash or Cygwin), it will exit with a message:

> ❌ Unsupported OS detected.  
> This script can only run on Linux, macOS, or WSL.

---

## 🧾 Prerequisites

| Language / Framework        | Required Tools              | Version Check Command                              |
| --------------------------- | --------------------------- | -------------------------------------------------- |
| **Java (Maven)**            | `java`, `mvn`, `git`        | `java -version`, `mvn -version`                    |
| **Python**                  | `python3`, `git`            | `python3 --version`                                |
| **NodeJS / React / NextJS** | `node`, `npm`, `npx`, `git` | `node --version`, `npm --version`, `npx --version` |

---

## 💻 Usage

### 🐧 Linux / macOS / WSL

1. Make the script executable:

   ```bash
   chmod +x create-starter-template.sh
   ```

2. Run it:

   ```bash
   ./create-starter-template.sh
   ```

3. Follow the prompts.

---

### 💠 Windows (PowerShell)

1. Open PowerShell **as Administrator**.

2. Allow temporary script execution:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```

3. Run the script:
   ```powershell
   .\create-starter-template.ps1
   ```

---

## 🧩 Example

```bash
🧠 Detected OS: Linux
🔍 Checking Git...
✅ git version 2.43.0
🚀 Project Template Generator
==============================
Enter project name: myapp
Select language/framework:
1) Java (Maven)
2) Python
3) NodeJS
4) ReactJS (Vite)
5) NextJS
Enter choice [1-5]: 3

🟩 Setting up NodeJS project...
✅ Project 'myapp' setup completed successfully!
```

---

## 🧠 Notes

- The script exits if a required dependency is missing.
- React and NextJS projects require internet access.
- Git is initialized automatically for Java, Python, and NodeJS projects.
- The script will prompt before overwriting an existing folder.

---
