---
name: app-dev-checklist
description: >-
  Production readiness and polish checklist for building, scaffolding, auditing,
  packaging, or shipping Windows, macOS, Android, and Web / PWA applications.
  Covers app icons and visual assets, manifests and bundle metadata, themes and
  DPI/viewport scaling, permissions and privacy, storage paths, accessibility and
  RTL/i18n, installers/signing, and CI verification. Use whenever creating a new
  client/GUI/web app, preparing a release, or auditing an app for missing polish.
---

# Multi-Platform App Development & Release Checklist

Ensure client applications across **Windows**, **macOS**, **Android**, and **Web / PWA** ship with complete native polish — never default placeholder icons, missing manifests, broken dark mode, unrequested permissions, or fragile packaging.

## Workflow

1. **Identify target platform(s) & stack**:
   - Inspect the repository (`*.csproj`, `Package.swift`, `Info.plist`, `tauri.conf.json`, `build.gradle.kts`, `AndroidManifest.xml`, `package.json`, `manifest.webmanifest`, `index.html`).
2. **Apply the Universal Baseline Checklist** below to every target.
3. **Load only the relevant platform reference(s)** for deep platform-specific requirements:
   - **Windows** (WinUI 3, WPF, WinForms, Win32, Rust/Tauri): read [`references/windows.md`](./references/windows.md)
   - **macOS** (SwiftUI, AppKit, SwiftPM `.app` bundles, Rust/Tauri): read [`references/macos.md`](./references/macos.md)
   - **Android** (Kotlin, Jetpack Compose, Android Views, Gradle): read [`references/android.md`](./references/android.md)
   - **Web & PWA** (Next.js, React, Vite, Vanilla HTML/CSS/JS): read [`references/webapp.md`](./references/webapp.md)
4. **Verify artifacts & builds** using platform CLI commands before declaring readiness.

## Universal Baseline Checklist (All Platforms)

- **App Identity & Versioning**:
  - Unique reverse-DNS identifier (`com.<org>.<app>`) or AUMID; consistent human-readable display name, publisher, copyright, and SemVer across all targets.
- **Icons & Visual Assets (Never Ship Placeholders)**:
  - Crisp, properly padded icons across launcher/Dock/taskbar, window titlebar, system tray/menu bar (monochrome/template where appropriate), notifications, installer/DMG, and store/social previews.
- **Theme, Scaling & Window/Viewport Ergonomics**:
  - Respect system **Light / Dark** mode (plus manual override if applicable) without white flashes on startup; crisp rendering across HiDPI / Retina / multi-monitor DPI; safe-area / window-bounds clamping.
- **Keyboard, Accessibility & RTL / Localization**:
  - Full keyboard navigation & standard shortcuts (`Esc`, `Enter`, platform Quit/Settings/Copy/Paste); screen-reader labels on icon-only buttons; `>= 4.5:1` text contrast; logical layout properties so **LTR and RTL** (e.g., Persian/Arabic) render cleanly without mirrored code blocks or broken icons; respect reduced-motion preferences.
- **Privacy, Permissions & Secrets**:
  - Strict least-privilege permissions (zero unused `INTERNET`, mic, camera, or filesystem entitlements); clear user-facing permission rationale and graceful denied-state UI; **zero** API keys, signing certs, or `.env` files committed or bundled into client binaries.
- **State, Storage & Offline Resilience**:
  - Write config, cache, and logs only to OS-standard user directories (never inside app bundle / install directory); handle offline/network timeouts, empty states, loading skeletons, and fatal crashes gracefully without silent data loss.
- **Build, Scripts & Release Packaging**:
  - When providing build/install helper scripts, ship paired **macOS Bash (`.sh`)** and **Windows PowerShell 7 (`.ps1` with `#Requires -Version 7.0`)** scripts; reproducible release builds with checksums (`SHA-256`) and clean uninstall behavior.

## Platform Quick-Reference Matrix

| Concern | Windows | macOS | Android | Web / PWA |
| :--- | :--- | :--- | :--- | :--- |
| **Primary App Icon** | Multi-size `.ico` (`16`–`256` px) + `<ApplicationIcon>` / `.rc` | `AppIcon.icns` (`16`–`1024` px squircle ~80% canvas) | Adaptive icon (`108dp` canvas, `66dp` safe zone + `monochrome`) | `favicon.svg`, `favicon.ico` (`32`), `apple-touch-icon.png` (`180`), `192`/`512` + `maskable` |
| **Tray / Bar / Small Icon** | DPI-aware `.ico`, clean `Dispose` on exit | `NSStatusItem` `18pt` @1x/@2x `isTemplate = true` | Monochrome white-on-transparent vector `24dp` | Tab `favicon.svg` (`prefers-color-scheme` aware) |
| **Manifest / Metadata** | `app.manifest` (`PerMonitorV2`, `longPathAware`) + `.csproj` / `.rc` | `Contents/Info.plist` (`CFBundle*`, `LSMinimumSystemVersion`, `NS*UsageDescription`) | `AndroidManifest.xml` (`minSdk`/`targetSdk`, `exported`, backup rules) | `manifest.webmanifest` + `<meta name="viewport">`, Open Graph / Twitter tags |
| **User Data Path** | `%LOCALAPPDATA%\<App>` & `%APPDATA%\<App>` | `~/Library/Application Support/<App>` | `context.filesDir` / `DataStore` / `Room` + SAF | `localStorage` / `IndexedDB` (quota & private-mode safe) |
| **Distribution Artifact** | Signed `.exe` / Inno Setup / MSIX / Velopack (`.zip` portable) | Signed + notarized `.app` inside `.dmg` or `ditto` `.zip` | R8-minified signed `.aab` (Play) & `.apk` (GitHub/FDroid) | Minified static/SSR bundle + `sw.js` safe update strategy |

## Audit Output Format (When Reviewing an Existing App)

When asked to audit or check an app against this checklist, group findings by platform and status:

```markdown
## App Readiness Audit — <App Name> (<Platforms>)

### 🔴 Missing / Ship Blockers
- **[Platform] <Item>** (`path/to/file`) — <Impact and exact fix>.

### 🟠 Polish & UX Gaps
- **[Platform] <Item>** (`path/to/file`) — <Recommended improvement>.

### ✅ Verified Ready
- <Concise summary of icons, manifests, permissions, storage, and packaging confirmed present>
```
