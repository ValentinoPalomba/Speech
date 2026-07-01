# AGENTS.md — Speech – Talk Timer

Guidance for AI coding agents working on this repository. Read this before making changes.

## What this is

**Speech – Talk Timer** is a **standalone watchOS app** (a timer for speeches/presentations).
Set a duration with the Digital Crown, add "stops" (milestones) along the ring that fire a haptic
notification, then start a **date-based** countdown. An end-of-timer haptic fires too. Timers can be
saved as colour-coded presets. Works with **no iPhone**; nothing leaves the device.

- App Store name: **Speech – Talk Timer** · on-device name (`CFBundleDisplayName`): **Speech**
- Min deployment target: **watchOS 10** · Swift 5 · SwiftUI · Xcode 26.x
- Localised **IT + EN** (String Catalog) · Private by design (no analytics/network/accounts)

## Targets & structure

Three targets (see `Speech.xcodeproj`):

| Target | Type | Bundle id | Notes |
|---|---|---|---|
| `Speech` | `watchapp2-container` (iOS stub) | `com.valentinopalomba.speechtalk` | Empty stub that **embeds** the watch app. Required for install/submission. No source code. |
| `Speech Watch App` | watchOS app | `com.valentinopalomba.speechtalk.watchkitapp` | The real app. `PRODUCT_MODULE_NAME = Speech`. |
| `SpeechTests` | unit test bundle | — | Swift Testing, host = watch app. |

```
Speech Watch App/
  SpeechApp.swift            # @main; scenePhase wiring, notification auth
  Models/                    # Milestone, SavedTimer, TimeFormat
  ViewModels/TimerViewModel.swift   # single source of truth (@MainActor)
  Services/                  # PersistenceService, NotificationService (nonisolated)
  Views/                     # ContentView (root), SetMilestonesView, TimerActiveView,
                             #   SelectTimerView, EditTimersView, SaveTimerView, SavedTimerRow
  DesignSystem/              # Palette, Typography, PillButtonStyle, DialLayout  (see Design.md)
  Localizable.xcstrings      # IT + EN, with plurals
  Assets.xcassets            # AppIcon (1024), AccentColor (#0A84FF)
  PrivacyInfo.xcprivacy      # UserDefaults reason CA92.1, no tracking
SpeechTests/                 # SpeechTests.swift + Mocks.swift
AppStore/                    # screenshots/ + metadata.md + privacy-policy.md
docs/                        # GitHub Pages: support + privacy (index.html, privacy.html)
```

## Build / test / run

Module name is **`Speech`** (via `PRODUCT_MODULE_NAME`), so tests use `@testable import Speech`.
There is intentionally **no shared scheme**; Xcode/xcodebuild auto-create one named `Speech Watch App`
that runs the watch app and archives the container (same as Xcode's watch-only template).

```bash
# Build
xcodebuild -project Speech.xcodeproj -scheme "Speech Watch App" \
  -destination 'platform=watchOS Simulator,name=Apple Watch SE 3 (40mm)' -configuration Debug build

# Test (17 unit tests)
xcodebuild -project Speech.xcodeproj -scheme "Speech Watch App" \
  -destination 'platform=watchOS Simulator,name=Apple Watch SE 3 (40mm)' test

# Archive (produces the container with the watch app embedded in Watch/)
xcodebuild -project Speech.xcodeproj -scheme "Speech Watch App" -configuration Release \
  -destination 'generic/platform=watchOS' -archivePath build/Speech.xcarchive archive
```

The bar for changes: **build Debug + Release with ZERO warnings, and all tests green.**

## Critical watchOS gotchas (do not regress)

1. **Watch-only ≠ single target.** A standalone watch app MUST have `INFOPLIST_KEY_WKWatchOnly = YES`
   on the watch target **and** the `watchapp2-container` iOS stub embedding it. Removing either causes
   the install/upload error *"WatchKit 2.0 app … Missing WKCompanionAppBundleIdentifier"*.
2. **Bundle id hierarchy is enforced by App Store:** the watch app id must be exactly
   `<container id>.watchkitapp`. Keep `…speechtalk` / `…speechtalk.watchkitapp` in sync.
3. **The timer is date-based.** `TimerViewModel` stores an `endDate`; `remaining` is always derived
   from the wall clock, never accumulated. It survives suspension/relaunch. On restore
   (`restoreSessionIfNeeded`) the ticker MUST be (re)started — `onChange(of:scenePhase)` does NOT fire
   for the initial `.active` on cold launch.
4. **`.contextMenu` / Force Touch is deprecated on watchOS** — preset navigation uses a `.toolbar`
   button, not a force-press menu.
5. **`Menu` is unavailable on watchOS** — don't use it.
6. Keep milestones clamped to `0 < m < total` (in `toggleMilestone`, `prepareActiveIfNeeded`,
   `savePreset`) and guard dial angle math against `total == 0` (no divide-by-zero / NaN).
7. Services (`PersistenceService`, `NotificationService`) are `nonisolated`; the VM is `@MainActor`.

## Conventions

- **Localization:** every user-facing string goes through the String Catalog. Use `Text("key")`
  (auto-extracted) for literals; use `Text(verbatim:)` for pure numbers/empty strings so they do NOT
  pollute the catalog (e.g. the dial number, `navigationTitle(Text(verbatim: ""))`).
- **Design:** use the `DesignSystem/` tokens (colours, typography, `PillButtonStyle`, dial layout).
  Do not hardcode colours/fonts/sizes; drive dial/knob/spotlight sizes from `GeometryReader` so the UI
  adapts across 40–49 mm. See `Design.md`.
- **Accessibility:** dials expose `accessibilityAdjustableAction`; decorative shapes are
  `accessibilityHidden(true)`; numerals use `minimumScaleFactor`.
- **Screenshots (Debug only):** `TimerViewModel.applyUITestSetup()` / `uiTestScreen` seed state from
  launch env `SPEECH_UITEST=1` + `SPEECH_SCREEN=setMinute|setStops|active|presets`. This code is
  `#if DEBUG` and never ships. Launch via `SIMCTL_CHILD_SPEECH_*` + `-AppleLanguages "(en)"`.

## Publishing

Signed **Distribution** archive of the `Speech` container → App Store Connect (Team `8JS222QZL3`).
Support/Privacy pages live at `https://valentinopalomba.github.io/speech-talk-timer/`.
Store metadata (IT/EN) in `AppStore/metadata.md`; screenshots in `AppStore/screenshots/`.

## Don't

- Don't reintroduce a real iOS app target (the container is a stub only).
- Don't make the countdown accumulate ticks; keep it derived from `endDate`.
- Don't add third-party SDKs, networking, analytics, or anything that would break the
  "Data Not Collected" privacy manifest.
