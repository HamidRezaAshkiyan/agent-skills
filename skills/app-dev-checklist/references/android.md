# Android Application Checklist

Applies to **Kotlin**, **Jetpack Compose**, **Android Views**, and **Multiplatform / Hybrid** Android apps built with Gradle (`AGP 8+`).

## 1. Icons, Adaptive Theming & Splash Screen

- [ ] **Adaptive Launcher Icon (`API 26+`)**:
  - Configure `res/mipmap-anydpi-v26/ic_launcher.xml` and `ic_launcher_round.xml` with `<background>`, `<foreground>`, and `<monochrome>` layers.
  - **Safe Zone Geometry**: Canvas is `108x108 dp`, visible mask is `72x72 dp`, and **critical artwork must stay inside the central `66x66 dp` circle** (~61% of canvas) so OEM squircle/circle/teardrop masks never clip logos or text.
- [ ] **Android 13+ Themed (`monochrome`) Icon**:
  - Always include `<monochrome android:drawable="@drawable/ic_launcher_monochrome" />` (single-color vector with alpha) so the icon blends seamlessly when users enable Material You **Themed Icons** on their home screen instead of standing out as the lone un-themed tile.
- [ ] **Legacy Mipmap Fallbacks & Store Icon**:
  - Include WebP/PNG fallbacks in `mipmap-mdpi` (`48px`), `hdpi` (`72px`), `xhdpi` (`96px`), `xxhdpi` (`144px`), `xxxhdpi` (`192px`), plus a `512x512` 32-bit PNG store listing icon.
- [ ] **Notification Small Icon**:
  - Notification `SmallIcon` **must** be a pure white-on-transparent vector drawable (`24x24 dp`) — multi-color PNGs render as solid grey/white squares in the Android status bar.
- [ ] **Android 12+ Splash Screen (`androidx.core:core-splashscreen`)**:
  - Call `installSplashScreen()` before `super.onCreate()` in `MainActivity` and configure `windowSplashScreenBackground`, `windowSplashScreenAnimatedIcon`, and `postSplashScreenTheme` so cold launches never show a blank white/black window.

## 2. `AndroidManifest.xml`, Permissions & Privacy

- [ ] **Unique Identity & SDK Targets**:
  - Distinct `namespace` and `applicationId` (never ship `com.example.*`); debug suffix `applicationIdSuffix = ".debug"` so debug and release builds can coexist on the same device.
  - Current `compileSdk` & `targetSdk` (`35+`), deliberate `minSdk`, monotonic integer `versionCode`, and SemVer `versionName`.
- [ ] **Strict Permission Hygiene (Audit the Merged Manifest!)**:
  - Declare only strictly required `<uses-permission>` entries; mark optional hardware with `<uses-feature android:name="..." android:required="false" />` (e.g. `android.hardware.camera`, `android.hardware.microphone`) so tablets/Chromebooks without that hardware aren't excluded on stores.
  - **Verify transitive dependencies haven't injected unwanted permissions** (`INTERNET`, `ACCESS_NETWORK_STATE`, `AD_ID`, `READ_EXTERNAL_STORAGE`) by inspecting `app/build/intermediates/merged_manifests/release/AndroidManifest.xml` or running:
    ```bash
    aapt2 dump permissions app/build/outputs/apk/release/app-release.apk
    ```
  - For strictly offline/privacy-first apps (e.g. finance, card scanners, SMS trackers), enforce **zero `android.permission.INTERNET`** in CI and remove unintended library permissions via `tools:node="remove"`.
- [ ] **Runtime Permissions UX**:
  - Request dangerous permissions (`CAMERA`, `RECORD_AUDIO`, `POST_NOTIFICATIONS` on API 33+, `READ_SMS`) in context right when needed, handle `shouldShowRequestPermissionRationale`, and provide a non-broken fallback state + "Open App Settings" button when permanently denied.
  - Prefer zero-permission system pickers (**Photo Picker** `PickVisualMedia`, **Storage Access Framework** `CreateDocument` / `OpenDocument` for backups/exports) over broad storage permissions.
- [ ] **Component Security & Backup Rules**:
  - Explicitly set `android:exported="true"` or `"false"` on every `<activity>`, `<service>`, `<receiver>`, and `<provider>`.
  - Configure `android:allowBackup` deliberately along with `android:dataExtractionRules="@xml/data_extraction_rules"` and `android:fullBackupContent="@xml/backup_rules"` (excluding auth tokens, encrypted keys, or sensitive caches from cloud backup).
  - If using HTTP only for localhost dev, restrict cleartext via `network_security_config.xml` rather than global `usesCleartextTraffic="true"` in release.

## 3. Modern UI, Edge-to-Edge, RTL & Lifecycle

- [ ] **Edge-to-Edge & Window Insets (Mandatory on Android 15 / API 35+)**:
  - Call `enableEdgeToEdge()` in `MainActivity` and apply `Scaffold` inner padding, `systemBarsPadding()`, `navigationBarsPadding()`, and `imePadding()` properly so bottom buttons/FABs never collide with the gesture bar or soft keyboard.
- [ ] **Material 3 Theme & Dark Mode**:
  - Support Light & Dark color schemes (and optional Material You `dynamicDarkColorScheme` / `dynamicLightColorScheme` on Android 12+ with curated brand fallback on older APIs).
- [ ] **Predictive Back Gesture**:
  - Set `android:enableOnBackInvokedCallback="true"` in `<application>` and use Compose `BackHandler` / `OnBackPressedDispatcher` instead of deprecated `Activity.onBackPressed()`.
- [ ] **RTL & Localization Readiness**:
  - Set `android:supportsRtl="true"`, use start/end modifiers (`padding(start = ...)`, `Arrangement.spacedBy`), set `autoMirrored = true` on directional arrows/back icons, and keep numbers/IBANs/codes wrapped in `BidiFormatter` or explicit LTR direction (`CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Ltr)`) when rendering Persian/Arabic UI.
  - Support Per-App Language Preferences (`LocaleConfig` / `android:localeConfig`) if multi-language.
- [ ] **Configuration Changes, Process Death & Accessibility**:
  - Survive screen rotation, split-screen resize, foldable posture changes, and background **process death** (`rememberSaveable` for UI primitives, `SavedStateHandle` in `ViewModel` for route/form IDs — test with `adb shell am kill <package>` while app is backgrounded).
  - Ensure `>= 48x48 dp` touch targets and meaningful `contentDescription` on interactive icons (`null` on purely decorative graphics).

## 4. Release Build, R8 Shrinking & Signing

- [ ] **R8 Minification & Resource Shrinking Tested**:
  - Enable `isMinifyEnabled = true` and `isShrinkResources = true` in the `release` build type, plus `proguard-android-optimize.txt` and project `proguard-rules.pro` (keep rules for `@Serializable`, Retrofit/Gson DTOs, Room entities, JNI).
  - **Always smoke-test the actual R8 release APK/AAB**, not just `debug` — reflection crashes only surface when R8 strips classes in release!
- [ ] **Signing & Secrets Hygiene**:
  - Never commit `.jks` / `.keystore` files or passwords; load signing configs from `keystore.properties` (gitignored) or CI environment variables.
  - Enable APK Signature Scheme v2 + v3.
- [ ] **Verification Commands**:
  ```bash
  ./gradlew lintRelease testDebugUnitTest assembleRelease bundleRelease
  ```
