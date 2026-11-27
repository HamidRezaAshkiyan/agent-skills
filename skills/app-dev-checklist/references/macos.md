# macOS Application Checklist

Applies to **SwiftUI**, **AppKit**, **SwiftPM `.app` bundles**, **Objective-C**, and **Rust / Tauri / Electron** on macOS (Apple Silicon & Universal binaries).

## 1. Icons & Visual Assets

- [ ] **`AppIcon.icns` with Complete Retina `.iconset`**:
  - Generate `AppIcon.icns` via `iconutil -c icns AppIcon.iconset` (or `Assets.xcassets/AppIcon.appiconset` via `actool`) containing all 10 required PNG entries:
    - `icon_16x16.png`, `icon_16x16@2x.png`
    - `icon_32x32.png`, `icon_32x32@2x.png`
    - `icon_128x128.png`, `icon_128x128@2x.png`
    - `icon_256x256.png`, `icon_256x256@2x.png`
    - `icon_512x512.png`, `icon_512x512@2x.png` (`1024x1024` sRGB PNG)
- [ ] **macOS Big Sur+ Squircle Grid Geometry**:
  - Keep the rounded-rect squircle body at **~80–82% of the `1024x1024` canvas** (`~824x824` centered with ~100px transparent margin on each side and subtle drop shadow). Never fill 100% of the square canvas — full-bleed icons look oversized and broken in the Dock next to Apple apps.
- [ ] **Menu Bar (`NSStatusItem`) Icon**:
  - Use `18x18 pt` (`18x18` @1x + `36x36` @2x) monochrome black-with-alpha PNG or SF Symbol with `image.isTemplate = true` so macOS automatically inverts/tints it across light menu bars, dark wallpapers, and inactive screens.

## 2. `.app` Bundle Layout & `Info.plist`

- [ ] **Standard Bundle Hierarchy**:
  ```text
  MyApp.app/
  └── Contents/
      ├── Info.plist
      ├── PkgInfo                 # Optional ("APPL????")
      ├── MacOS/
      │   └── MyApp               # chmod +x executable
      ├── Resources/
      │   └── AppIcon.icns
      └── Frameworks/             # Embedded dylibs / frameworks (@rpath)
  ```
- [ ] **Required `Info.plist` Keys**:
  - `CFBundleIdentifier`: Reverse-DNS (`com.<author>.<app>`).
  - `CFBundleName` & `CFBundleDisplayName`: Short menu-bar name and user-visible app name.
  - `CFBundleExecutable`: Exact binary filename inside `Contents/MacOS/`.
  - `CFBundleIconFile`: `AppIcon` (or `AppIcon.icns`) matching `Contents/Resources/AppIcon.icns`.
  - `CFBundlePackageType`: `APPL`.
  - `CFBundleShortVersionString` (marketing SemVer, e.g. `1.2.0`) & `CFBundleVersion` (monotonic build number, e.g. `120`).
  - `LSMinimumSystemVersion`: Explicit minimum macOS version (e.g. `14.0`) matching deployment target.
  - `NSHighResolutionCapable`: `true` (ensures crisp Retina rendering).
  - `LSApplicationCategoryType`: e.g. `public.app-category.developer-tools`, `public.app-category.productivity`, `public.app-category.music`.
  - `NSHumanReadableCopyright`: Copyright string shown in the standard About panel.
  - `LSUIElement`: Set `true` **only** for menu-bar/background utilities that should hide their Dock icon and main menu bar; omit or set `false` for standard windowed apps.
- [ ] **TCC Privacy Usage Descriptions (Crash Prevention)**:
  - macOS **terminates the process immediately (`SIGABRT`)** if it accesses protected APIs without the matching `Info.plist` string:
    - Microphone → `NSMicrophoneUsageDescription`
    - Camera → `NSCameraUsageDescription`
    - Bluetooth → `NSBluetoothAlwaysUsageDescription`
    - Local Network → `NSLocalNetworkUsageDescription`
    - AppleEvents / Automation → `NSAppleEventsUsageDescription`
    - Note: Screen Recording (`CGPreflightScreenCaptureAccess` / `SCShareableContent`) and Accessibility (`AXIsProcessTrustedWithOptions`) are checked via runtime APIs and System Settings prompts — always provide a clear onboarding screen with a deep link to the relevant System Settings pane.

## 3. Native macOS UX, Menus & SwiftPM Gotchas

- [ ] **Standard Application & Edit Menus**:
  - Even in custom AppKit / SwiftPM apps without storyboards, wire a standard `NSMenu` containing **App** (`About`, `Settings…` `⌘,`, `Hide` `⌘H`, `Hide Others` `⌥⌘H`, `Quit` `⌘Q`), **Edit** (`Undo` `⌘Z`, `Redo` `⇧⌘Z`, `Cut` `⌘X`, `Copy` `⌘C`, `Paste` `⌘V`, `Select All` `⌘A` — without an Edit menu in the responder chain, `⌘C`/`⌘V` silently fail in `NSTextField` and SwiftUI `TextField`!), and **Window** (`Minimize` `⌘M`, `Close` `⌘W`).
- [ ] **Activation Policy & Window Lifecycle**:
  - When launching a SwiftPM executable bundled as `.app`, set `NSApp.setActivationPolicy(.regular)` (or `.accessory` for menu-bar apps) and handle `applicationShouldTerminateAfterLastWindowClosed` intentionally (`true` for single-window utilities, `false` for document/studio/menu-bar apps).
- [ ] **Appearance & Vibrancy**:
  - Test both **Light** and **Dark** appearance (`NSVisualEffectView` materials, semantic colors `NSColor.labelColor` / SwiftUI `.primary`, `.secondary`).
- [ ] **Launch at Login**:
  - On macOS 13+, prefer `SMAppService.mainApp.register()` / `.unregister()` over legacy `LaunchAgents` plist files for GUI apps, and read `SMAppService.mainApp.status` to stay synced if the user toggles it in System Settings → General → Login Items.
- [ ] **CommandLineTools vs Full Xcode Compatibility (SwiftPM)**:
  - If supporting headless/CLI builds with only CommandLineTools installed (no `/Applications/Xcode.app`), verify `swift build -c release` succeeds without macro plugins (`SwiftUIMacros`) or `XCTest` framework assumptions, or document Xcode requirement clearly.

## 4. Storage Paths, Universal Binaries, Signing & DMG

- [ ] **Standard macOS Directories**:
  - App data & config → `~/Library/Application Support/<AppName>/`
  - Caches → `~/Library/Caches/<BundleID>/`
  - Preferences → `UserDefaults.standard` (`~/Library/Preferences/<BundleID>.plist`)
  - Secrets / tokens → macOS **Keychain** (`Security.framework`), never plain JSON files.
- [ ] **Architecture (`arm64` / Universal2)**:
  - Build native `arm64` or Universal binary (`lipo -create -output MyApp MyApp-arm64 MyApp-x86_64`, verified via `file` / `lipo -info`).
- [ ] **Code Signing, Hardened Runtime & Notarization**:
  - **Local / Open-Source Unsigned Distribution**: Always at minimum apply an ad-hoc signature (`codesign --force --deep --sign - MyApp.app`) — Apple Silicon **refuses to execute completely unsigned arm64 binaries** (`SIGKILL / Code Signature Invalid`), and document `xattr -cr /Applications/MyApp.app` for non-notarized downloads.
  - **Public Distribution**: Sign nested dylibs/helpers inside-out (`--force --options runtime --timestamp --entitlements App.entitlements --sign "Developer ID Application: ..."` — avoid `--deep` for notarized builds), verify with `codesign --verify --deep --strict --verbose=2` and `spctl -a -t exec -vv`, submit via `xcrun notarytool submit --wait`, and staple (`xcrun stapler staple`).
- [ ] **Archive & DMG Packaging**:
  - Package `.zip` with `ditto -c -k --sequesterRsrc --keepParent MyApp.app MyApp.zip` (plain `zip -r` breaks symlinks inside `.framework` bundles and strips extended metadata).
  - For `.dmg`, include a `/Applications` symlink for drag-and-drop install and verify mounting cleanly.
