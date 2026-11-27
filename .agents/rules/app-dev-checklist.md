---
trigger: model_decision
description: Production readiness and polish checklist for building, auditing, packaging, or shipping Windows, macOS, Android, and Web / PWA applications (icons, manifests, dark mode, DPI/viewport, permissions, RTL/a11y, installers/signing).
---

# Multi-Platform App Development & Release Checklist Rules

- Never ship default placeholder icons: ensure complete multi-size `.ico` + `AppWindow.SetIcon` / tray cleanup (Windows), squircle-padded `AppIcon.icns` + template menu-bar icons (macOS), Adaptive + `<monochrome>` + splash + vector notification icons (Android), and `favicon.svg`/`.ico` + opaque `apple-touch-icon.png` + `maskable` PWA icons + Open Graph image (Web).
- Verify manifests and metadata: `app.manifest` (`PerMonitorV2`, `longPathAware`, Win10/11 GUID, version info), `Info.plist` (`CFBundle*`, TCC `NS*UsageDescription`, Edit menu for `⌘C`/`⌘V`), `AndroidManifest.xml` (audit merged permissions with `aapt2`, `exported`, backup rules), and `manifest.webmanifest` + `<meta name="viewport" content="..., viewport-fit=cover">`.
- Enforce zero-flash Light/Dark mode, HiDPI / Retina / `enableEdgeToEdge()` / `safe-area-inset-*` scaling, logical LTR/RTL layout, keyboard/screen-reader accessibility, OS-standard user data paths, and release-signed/minified packaging.
- Activate the `app-dev-checklist` skill and read the matching `references/{windows,macos,android,webapp}.md` file for the complete platform checklist.
