# Design.md — Speech – Talk Timer

The visual language of the app. It revives the original **Speech (2020)** concept by Antonio Virgilio
([Behance](https://www.behance.net/gallery/91050347/Speech-2020)): a pure-black canvas, a blue/cyan
accent, thin circular dials, and a **volumetric spotlight** — the "speaker under a spotlight" metaphor.

All tokens live in `Speech Watch App/DesignSystem/`. **Do not hardcode** colours, fonts or sizes in
views — use these tokens and drive geometry from `GeometryReader` so the UI scales 40–49 mm.

## Colour — `Palette.swift`

| Token | Value | Use |
|---|---|---|
| `AppColor.accent` | `#0A84FF` (sRGB 0.039, 0.518, 1.0) | Primary — dials, arcs, knobs, pill outlines, start action |
| `AppColor.highlight` | cyan (0.35, 0.78, 1.0) | Spotlight top / gradient highlight |
| `AppColor.background` | pure black | Canvas (OLED-friendly), set explicitly per screen |
| `AppColor.faintStroke` | white @ 25% | Decorative, non-essential strokes (background ring, side ellipses) |
| `AppColor.destructive` | `#FF4D54` (1.0, 0.30, 0.33) | Remove / Stop only |

`TimerPalette.colors` — 6 accents cycled per saved preset (`colorIndex`): **blue, purple, green,
orange, pink, teal**. `TimerPalette.color(index)` wraps safely.

The asset catalog defines **AccentColor = #0A84FF** (system tint) and the **AppIcon** (see below).

## Typography — `Typography.swift`

- `Font.dialNumber(size)` → `.system(size:, weight: .light, design: .rounded)` — the big dial numerals.
- `Font.screenTitle` → `.system(.headline, design: .rounded)` — screen titles.
- `Font.pillLabel` → `.system(.footnote, design: .rounded).weight(.medium)` — buttons/rows.
- Numerals use `.minimumScaleFactor(0.5)`; titles use markdown emphasis, e.g. `Text("Set **minute**")`,
  which also localises (IT: `Imposta **minuti**`).

## Components

- **Pill buttons — `PillButtonStyle`**: a `Capsule` with a thin (1.5pt) accent outline; `prominent`
  variant fills at ~22% for the primary action. One consistent style everywhere; red reserved for
  destructive (Remove/Stop). Use `.buttonStyle(.pill)` / `.pill(tint:prominent:)`.
- **Dial**: thin background ring (`faintStroke`) + accent progress arc (`.trim`, `lineCap: .round`) +
  markers. Central numerals in white light-rounded.
- **Milestone marker — `MilestoneMarker`**: one shared style on every dial — a small accent-stroked,
  black-filled knob. Positioned with `ringOffset(radius:angle:)` / `dialAngle(value:total:)` from
  `DialLayout.swift` (0° = top, clockwise), so markers stay on the ring at any size.
- **Spotlight — `SpotlightShape`** (active screen): a light cone, narrow at the dial and flaring
  downward, filled with a graduated gradient `highlight(0.40) → accent(0.14) → clear`, softly blurred.
  It's the signature element; anchor it to the dial centre and scale with the dial.
- **Decorative side ellipses**: two faint ellipses flanking the root dial ("Set minute"), sized
  proportionally to the dial.
- **Preset row — `SavedTimerRow`**: a `Capsule` with a per-timer coloured outline (`colorIndex`),
  name left, `MM:SS` right (coloured). Lists use `.listStyle(.carousel)` with clear row backgrounds.

## Screens

1. **Set minute** (`ContentView`) — central dial with the chosen minutes (Digital Crown), flanked by
   the two faint ellipses; `Next` pill. Toolbar button → Presets.
2. **Set stops** (`SetMilestonesView`) — dial to place milestones; `Add`/`Remove` + `Done`; toolbar → save preset.
3. **Active** (`TimerActiveView`) — countdown `MM:SS` on the dial with the **spotlight** beneath,
   progress arc, milestone markers, running knob; `Start` / `Stop` / `Done` by run state.
4. **Presets** (`SelectTimerView`) — coloured pill list; tap to load. Toolbar → Manage.
5. **Manage / Save** (`EditTimersView` / `SaveTimerView`) — swipe-to-delete, edit; name + colour chips + `Done`.

## Adaptivity

Every dial, knob, spotlight and font size is proportional to the container (`GeometryReader`,
`min(width, height)` fractions) — verified on 40, 46 and 49 mm. Never use absolute point values that
assume one watch size.

## App icon

Full-bleed 1024×1024 (watchOS masks to a circle): a blue gradient orb (cyan `#54B5F7` top → deep blue
`#1A52E3` bottom) with the inner **downward light cone** and a soft pool at the bottom — the same
spotlight metaphor as the active screen. No alpha. Generated to match the 2020 orb; source approach in
`AppStore/` history. Reference screenshots: `AppStore/screenshots/`.
