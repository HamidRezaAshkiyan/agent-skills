# Windows Application Checklist

Applies to **WinUI 3 / Windows App SDK**, **WPF**, **WinForms**, **Native Win32 / C++ / Rust**, and **Tauri / Electron** on Windows 10 & 11.

## 1. Icons & Visual Identity

- [ ] **Multi-resolution `.ico` file**: Embed PNG-compressed layers for `16x16`, `24x24`, `32x32`, `48x48`, `64x64`, `128x128`, and `256x256` so Explorer (list, tiles, extra-large icons), taskbar, and Alt-Tab stay razor-sharp at 100%–250% DPI.
- [ ] **Executable resource icon**:
  - **.NET (`.csproj`)**: Set `<ApplicationIcon>Assets\app.ico</ApplicationIcon>`.
  - **Rust / C++ / Win32**: Compile a `.rc` resource (`IDI_ICON1 ICON "assets/app.ico"`) via `winresource` / `embed-resource` / `rc.exe` so `.exe` properties and File Explorer show the icon.
  - **Tauri**: Populate `src-tauri/icons/icon.ico` (plus `32x32.png`, `128x128.png`, `128x128@2x.png`, Square logos).
- [ ] **Runtime window & taskbar icon**:
  - **WinUI 3 (unpackaged)**: `<ApplicationIcon>` alone does **not** set the WinUI 3 titlebar icon — call `AppWindow.SetIcon(Path.Combine(AppContext.BaseDirectory, "Assets", "app.ico"))` explicitly.
  - **WPF**: Set `Icon="pack://application:,,,/Assets/app.ico"` on `Window` or inherit via `Application` icon.
- [ ] **System Tray (`NotifyIcon` / `Shell_NotifyIconW`)**:
  - Provide crisp `16x16` / `20x20` / `24x24` / `32x32` variants loaded via `LoadIconMetric` (`LIM_SMALL`) so tray icons don't blur on 125%/150%/200% displays.
  - Remove the tray icon cleanly (`NIM_DELETE` / `.Dispose()`) on `Application.Exit` and crash handlers so ghost icons don't linger in the tray until hovered.
  - Include a right-click context menu with at least **Open/Show** and **Exit/Quit**, plus left-click / double-click restore behavior.
- [ ] **MSIX / Packaged Assets (if packaged)**:
  - Provide `Square44x44Logo` (including `targetsize-16/24/32/48/256_altform-unplated` & `lightunplated`), `Square150x150Logo`, `Wide310x150Logo`, `SplashScreen`, and `StoreLogo` (`50x50` scale variants) in `Package.appxmanifest`.

## 2. Manifest, Metadata & Process Identity

- [ ] **Application Manifest (`app.manifest`)**:
  - **DPI Awareness**: Enable `PerMonitorV2` (`<dpiAwareness>PerMonitorV2, PerMonitor</dpiAwareness>` and `<dpiAware>true/pm</dpiAware>`).
  - **Long Paths**: `<longPathAware>true</longPathAware>` inside `windowsSettings`.
  - **Supported OS GUIDs**: Include Windows 10/11 GUID (`{8e0f7a12-bfb3-4fe8-b9a5-48fd50a15a9a}`) so `Environment.OSVersion` and modern Win32 APIs don't lie via Windows 8 compatibility shims.
  - **UAC Execution Level**: `<requestedExecutionLevel level="asInvoker" uiAccess="false" />` unless administrative elevation is strictly required (prefer elevating only a helper sub-command rather than the entire GUI).
  - **Win32 Common Controls v6**: Include `Microsoft.Windows.Common-Controls` `6.0.0.0` dependency for native visual styles in Win32/WinForms dialogs.
- [ ] **Executable Version Info** (visible in File Explorer → Properties → Details & Task Manager):
  - Set `Product` / `ProductName`, `Company` / `CompanyName`, `Description` (`FileDescription` — shown as process name in **Task Manager**!), `Version` / `FileVersion`, and `Copyright`.
- [ ] **AppUserModelID (AUMID)**:
  - For unpackaged desktop apps sending Windows Toast notifications or pinning to taskbar, call `SetCurrentProcessExplicitAppUserModelID("Company.AppName")` before creating windows and register the matching Start Menu shortcut AUMID.

## 3. Windowing, Theme & Native UX

- [ ] **System Dark / Light & High-Contrast Sync**:
  - Sync UI theme with `UISettings.GetColorValue(UIColorType.Background)` or registry `AppsUseLightTheme`.
  - For WPF / Win32 / Rust custom windows, set `DwmSetWindowAttribute(..., DWMWA_USE_IMMERSIVE_DARK_MODE, 1)` (attribute `20`) so native titlebars and window borders match dark mode, and use `MicaBackdrop` / `DesktopAcrylicBackdrop` on Windows 11 with a solid fallback on Windows 10.
- [ ] **Multi-Monitor Window Placement Persistence**:
  - Persist window size, position, and maximized state, **clamping restored coordinates** against `MonitorFromRect(..., MONITOR_DEFAULTTONEAREST)` work areas so unplugging an external monitor never spawns an invisible off-screen window.
- [ ] **Single-Instance Guard (when appropriate)**:
  - Use a named Mutex or Windows App SDK `AppInstance.FindOrRegisterForKey("main")` and bring the existing window to the foreground (`SetForegroundWindow` + `ShowWindow(SW_RESTORE)`).
- [ ] **Autostart Hygiene**:
  - Write optional "Launch at Startup" entries to `HKCU\Software\Microsoft\Windows\CurrentVersion\Run` (quoting the `.exe` path `"C:\...\App.exe" --minimized`), or `StartupTask` in MSIX — never `HKLM` for per-user apps.

## 4. Filesystem, Antivirus & Clean Uninstall

- [ ] **Standard User Directories**:
  - Roaming config/user settings → `%APPDATA%\<AppName>` (`Environment.SpecialFolder.ApplicationData` / `FOLDERID_RoamingAppData`).
  - Cache, databases, logs, WebView2 `UserDataFolder` → `%LOCALAPPDATA%\<AppName>` (`LocalApplicationData` — **critical** for WebView2/Tauri so launching from `C:\Program Files` never crashes with `UnauthorizedAccessException`).
- [ ] **Explicit Architecture & Publish Settings**:
  - Build/publish explicitly for `win-x64` and `win-arm64` (`-p:Platform=x64` / `-p:Platform=ARM64`).
  - Verify whether distribution is **self-contained** (`--self-contained true` — zero runtime prerequisites for end users) or framework-dependent (document `.NET Desktop Runtime` / `Windows App Runtime` installer bootstrap).
- [ ] **Installer, Signing & Uninstall**:
  - Inno Setup / WiX / MSIX / Velopack / NSIS sets `DisplayIcon`, `Publisher`, `DisplayVersion`, `EstimatedSize`, closes running app instances gracefully (`CloseApplications=yes`), and removes Start Menu/Desktop shortcuts cleanly on uninstall.
  - Sign `.exe`, `.dll`, and installer with Authenticode (`signtool sign /fd SHA256 /tr http://timestamp.digicert.com /td SHA256`) when distributing publicly to avoid SmartScreen blocks, and publish `SHA256SUMS.txt`.
  - Provide PowerShell 7 build/install scripts (`build.ps1`, `install.ps1`) starting with `#Requires -Version 7.0` and `$ErrorActionPreference = 'Stop'`.
