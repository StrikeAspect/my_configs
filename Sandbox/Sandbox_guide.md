> **Version:** 0.1.0
>
> **Last Updated:** 2026-05-05

# Windows Sandbox VS Code Setup Guide

## 1. The Project Summary (The "What" and "Why")

**The Goal:** To create a "Zero-Touch," ephemeral coding environment using Windows Sandbox. Double-click a file, and seconds later, a fully configured Visual Studio Code instance opens, mapped to your local files. Close it, and all traces vanish.

**The Problem We Solved:** Standard VS Code installers (.exe or Winget .msix) frequently crash inside Windows Sandbox due to missing Microsoft Store background services, resulting in HRESULT 0x80073CF9 errors. Furthermore, extracting files over the Hyper-V shared folder layer can cause "Access Denied" locking errors.

**The Solution:**

- **Portable VS Code:** We strictly use the .zip (Portable) version of VS Code (win32-x64-archive). It bypasses the Windows Registry and installer services completely.
- **Local Extraction:** We extract the IDE directly to the Sandbox's native C:\VSCode drive to bypass Hyper-V network-share locks.
- **Security Stripping:** We use PowerShell's Unblock-File to strip the "Mark of the Web" from the downloaded ZIP, preventing Windows from blocking the extraction.
- **Dynamic Fallback:** The script looks for a local ZIP file to install instantly. If it doesn't find one, it safely falls back to downloading the latest version straight from Microsoft.

## 2. Prerequisites

Before you begin, ensure your system meets the following requirements:

- **Windows 10 Pro, Enterprise, or Education (Version 1903 or later)** or **Windows 11 Pro or Enterprise**.
- **Virtualization enabled in BIOS/UEFI** (Intel VT-x or AMD-V).
- **Windows Sandbox feature enabled:**
  1. Open the Start menu and search for "Turn Windows features on or off".
  2. Scroll down and check the box for "Windows Sandbox".
  3. Click "OK" and restart your computer if prompted.
- **Administrator privileges** (for enabling Windows features).
- **Internet connection** (for downloading VS Code if not using a local ZIP).

For more details on Windows Sandbox, refer to the official documentation: [Windows Sandbox Overview](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/).

## 3. Step-by-Step Setup

Follow these steps to set up your ephemeral VS Code environment in Windows Sandbox.

### Step 1: Create the Sandbox Folder on Your Host PC

1. On your host PC, navigate to the root of your C: drive (or any drive where you want to store your sandbox files).
2. Create a new folder named `Sandbox` (e.g., `C:\Sandbox`).
   - This folder will be mapped into the sandbox and used to store your project files and the setup scripts.

### Step 2: Download the Required Files

You need three files for this setup:
- `sandbox.wsb` (the Windows Sandbox configuration file)
- `sandbox.ps1` (the PowerShell setup script)
- (Optional but recommended) The portable VS Code ZIP file

1. Download `sandbox.wsb` and `sandbox.ps1` from this repository's `Sandbox/` folder.
2. Place both files into your `C:\Sandbox` folder.

### Step 3: Download Portable VS Code (Optional but Recommended)

To speed up the setup process, download the portable version of VS Code locally:

1. Go to the official VS Code download page: [https://code.visualstudio.com/download](https://code.visualstudio.com/download).
2. Under "Other downloads," select the **.zip (64-bit)** version for Windows (win32-x64-archive).
3. Download the file (approximately 130MB).
4. Rename it to something simple like `vscode.zip` (optional, but the script will detect any file starting with "VSCode-win32-").
5. Place the ZIP file into your `C:\Sandbox` folder.

If you skip this step, the script will automatically download the latest version during sandbox startup, which takes about 45 seconds.

### Step 4: Launch the Sandbox

1. Double-click the `sandbox.wsb` file in your `C:\Sandbox` folder.
   - This will start Windows Sandbox and automatically run the setup script.

### What Happens Automatically (Inside the Sandbox)

The `sandbox.ps1` script runs automatically and performs the following steps:

1. **Environment Check:** Verifies that the script is running inside Windows Sandbox (checks for username "WDAGUtilityAccount"). If not, it exits to prevent accidental execution on your host PC.

2. **UI Tweaks for Developer Experience:**
   - Shows hidden files and file extensions in File Explorer.
   - Enables Windows Clipboard History (accessible via Win + V).
   - Adds "Open PowerShell Here" to the right-click context menu.
   - Restarts Windows Explorer to apply changes immediately.

3. **VS Code Installation:**
   - Checks for a local VS Code ZIP file in the mapped `C:\Sandbox` folder.
   - If found and valid (>50MB), uses it for instant installation.
   - If not found, downloads the latest portable VS Code from Microsoft.
   - Strips the "Mark of the Web" security flag using `Unblock-File`.
   - Extracts the ZIP to `C:\VSCode` on the sandbox's local drive (bypassing Hyper-V share issues).
   - Creates a desktop shortcut for easy access.

4. **Launch VS Code:**
   - Opens VS Code and maps it to your `C:\Sandbox` folder, allowing you to work on files that sync back to your host PC.

The entire process takes 10-60 seconds, depending on whether you provided a local ZIP.

## 4. Usage

- **Working in the Sandbox:** Use VS Code as you normally would. All files saved in the mapped `C:\Sandbox` folder will persist on your host PC.
- **Reopening VS Code:** If you close VS Code accidentally:
  - Double-click the "VS Code" shortcut on the sandbox desktop.
  - Or navigate to `C:\VSCode\Code.exe` in File Explorer and double-click it.
- **Closing the Sandbox:** Simply close the Windows Sandbox window. Everything inside is deleted, but your files in `C:\Sandbox` remain safe.

## 5. Important Notes

- **Stateless Nature:** Windows Sandbox is ephemeral. Any changes made inside the sandbox (except files in the mapped folder) are lost when you close it. This ensures a clean, isolated environment every time.
- **File Saving:** Always save your work in the mapped `C:\Sandbox` folder to sync back to your host PC.
- **Network Dependency:** If downloading VS Code, ensure an internet connection. The download uses TLS 1.2 for security.
- **Security:** The script only runs inside Windows Sandbox due to the username check, preventing accidental execution on your host.
- **Performance:** Portable VS Code is lightweight and doesn't require installation, making it ideal for sandboxed environments.
- **Troubleshooting:** If the script fails, check the PowerShell output for error messages. Common issues include missing internet or corrupted ZIP files.

## 6. References

- [Windows Sandbox Official Documentation](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/)
- [Visual Studio Code Downloads](https://code.visualstudio.com/download)
- [Portable VS Code Archive](https://code.visualstudio.com/docs/setup/windows#_portable) (for more info on portable installations)