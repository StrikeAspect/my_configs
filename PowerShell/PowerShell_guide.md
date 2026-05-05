> **Version:** 0.1.0
>
> **Last Updated:** 2026-05-05

# PowerShell Configuration Guide

## 1. Summary (The "What" and "Why")

**The Goal:** To transform the standard PowerShell experience into a modern, high-productivity terminal. This configuration adds visual flair with icons, a powerful theme engine, intelligent command predictions, and time-saving navigation shortcuts.

**The Solution:**
- **Terminal Icons:** Adds file and folder icons to `ls` and `dir` outputs for better visual recognition.
- **Oh My Posh:** A custom prompt engine that provides contextual information (like Git status) with a clean aesthetic.
- **PSReadLine Enhancements:** Enables "IntelliSense-like" history completion and a searchable list view for previous commands.
- **Navigation Shortcuts:** Quick-access functions to jump up directory levels instantly.

---

## 2. Prerequisites

To use this configuration, you need to install a few modules and tools:

1.  **Nerd Fonts (Required for Icons):**
    -   Download and install a "Nerd Font" (e.g., *MesloLGM NF* or *CaskaydiaCove NF*) from [nerdfonts.com](https://www.nerdfonts.com/).
    -   Set your terminal (Windows Terminal or VS Code) to use this font.
2.  **Oh My Posh:**
    -   Install via winget: `winget install JanDeDobbeleer.OhMyPosh -s winget`
3.  **Terminal-Icons Module:**
    -   Run in PowerShell: `Install-Module -Name Terminal-Icons -Repository PSGallery -Force`
4.  **WinGet Command Not Found (Optional):**
    -   Part of PowerToys, helps suggest packages when a command is missing.

---

## 3. Step-by-Step Setup

### Step 1: Access Your Profile
The PowerShell profile is a script that runs every time you start a new session. To edit it, use one of the following commands:

- **Using VS Code (Recommended):**
  ```powershell
  code $PROFILE
  ```
- **Using Notepad:**
  ```powershell
  notepad $PROFILE
  ```

*Note: If the file doesn't exist, PowerShell will ask if you want to create it. Select "Yes".*

### Step 2: Copy the Configuration
Copy the contents of `profile.ps1` from this repository and paste them into your profile file opened in Step 1.

### Step 3: Reload Your Session
Save the file and restart your terminal, or run:
```powershell
. $PROFILE
```

---

## 4. Configuration Details

### Visuals & Theming
- **Terminal Icons:** Automatically active. Your file listings will now show icons based on file type.
- **Oh My Posh:** Uses the `catppuccin_mocha` theme. It provides a beautiful, color-coded prompt with environment info.

### Productivity Features
- **History Prediction:** As you type, PowerShell will suggest commands from your history in a greyed-out text (Predictive IntelliSense).
- **List View:** Press `F2` or use the configured list view to see a scrollable list of historical commands.
- **Command Not Found:** If you type a command that isn't installed, PowerShell will check WinGet and suggest the installation command.

### Navigation Shortcuts
Stop typing `cd ..` multiple times. Use these instead:
- `..` : Go up one level.
- `....` : Go up two levels.
- `......` : Go up three levels.

---

## 5. References
- [Oh My Posh Documentation](https://ohmyposh.dev/)
- [Terminal-Icons GitHub](https://github.com/devblackops/Terminal-Icons)
- [PSReadLine Documentation](https://learn.microsoft.com/en-us/powershell/module/psreadline/)
