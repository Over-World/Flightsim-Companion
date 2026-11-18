# Flightsim Companion

Kneeboard and flight planning app for flight simulators: plan and fly VFR and IFR flights. Slightly playful, but realistic. Covers everything a pilot needs to know, write down or plan during a flight.

The full roadmap (milestones M1–M7) lives in OpenChamber's project knowledge (plan "Flightsim Companion – Projektplan").

**Targets:** Android only, tablet first (portrait *and* landscape, like a real kneeboard), phones must be usable. Web is dropped for now (worldwide navdata is too big for the browser).

**Simulators:** X-Plane 12 primary (web API on the LAN: REST for queries/writes, WebSocket for live data), MSFS secondary (needs a SimConnect bridge on the PC, M7).

## API keys

- Users never enter API keys. App-owned keys (OpenAIP, ChartFox client) are read only through `ServiceCredentials`.
- Phase 1 (private builds): keys come from `--dart-define` at build time and are never committed. Phase 2 (public release): a proxy holds the keys; only the `ServiceCredentials` implementation changes.
- Per-user tokens (ChartFox OAuth + PKCE login) live in `flutter_secure_storage`.
- A feature whose key is missing in the build is disabled with a hint, never crashes.

## Stack

- Flutter 3.47+, **`package:material_ui`** (decoupled Material) instead of `package:flutter/material.dart`; flex_color_scheme 9 requires it.
- Localizations: `AppLocalizations.delegate` + `GlobalMaterialLocalizations.delegates` from `material_ui`. Strings in `lib/l10n/app_en.arb` (template) and `app_de.arb`; no hardcoded UI text.
- State: provider + `ChangeNotifier`. Navigation: go_router with `StatefulShellRoute.indexedStack` (keeps tab state, e.g. running timers).
- Storage: drift (SQLite) for navdata and user data, shared_preferences for settings.
- Design: Material 3, followed closely. Light/dark, several accent colors. Clean, no decorative styling.

## Layout

- `lib/core/` – nav math (great circle, wind triangle), units, morse, theme, settings, router
- `lib/data/db/` – drift tables and database (`database.g.dart` is generated)
- `lib/data/navdata/` – OurAirports CSV parser and importer
- `lib/core/navlog.dart` – navlog computation; `core/e6b.dart` – flight computer formulas; `core/runways.dart` – runway ends, wind components, suggestion; `core/quantities.dart` – unit conversions; `core/wmm/` – magnetic variation (all pure and tested)
- `lib/data/repositories/` – queries used by the UI
- `lib/data/sim/` – X-Plane web API client
- `lib/features/<feature>/` – screens and controllers: `plan` (flights, route editor, navlog table, runway selector), `e6b` (calculators), `kneeboard` (`KneeboardController`: active flight, times, stopwatch), `fly` (kneeboard UI), `notes` (stylus notepad), `onboarding`, `settings`, `airports`, `aircraft`, `navdata`
- `lib/widgets/` – shared widgets
- `lib/app_scope.dart` – all providers; used by `main.dart` and widget tests

## Conventions

- Internal units: knots, feet, litres, kilograms. Convert only for display (`core/units.dart`).
- Directions: true internally; convert to magnetic with `magneticVariation()` (WMM2025, `core/wmm/`, valid until 2030 – replace coefficients with WMM2030 then). Never use OurAirports' `magnetic_variation_deg`, it is decades old.
- Navigation destinations: Plan, Fly, E6B, Logbook, Settings (max. 5 for the phone NavigationBar). Aircraft profiles live under Plan (`/plan/aircraft`).
- Layout breakpoint: `width >= 600` → NavigationRail, else NavigationBar. Every screen must work at 360 px wide and in both tablet orientations.
- Stylus input: a stylus always draws (inverted end / button erases); a finger draws only with the "draw with finger" setting, otherwise it scrolls/zooms. Only one pointer is tracked so a palm can't scribble. Notepad pages use 1000-unit-wide page coordinates and palette indices (not ARGB) so ink adapts to dark mode.
- Widget tests with drift: call `unmount` (pump an empty widget + short pumps) at the end, and run DB work inside `tester.runAsync`; see `test/screens_test.dart`.

## Commands

```sh
dart run build_runner build   # after changing drift tables
python3 tool/arb_add.py x.json # add strings to both .arb files (see script header)
flutter gen-l10n              # after changing .arb files
flutter analyze && flutter test
```

## Pitfalls

- drift_dev skips `database.g.dart` *silently* when `database.dart` contains something it can't handle (e.g. a top-level record-list constant). If the file is missing after `build_runner`, simplify `database.dart`, `rm -rf .dart_tool/build` and rebuild.
- `flutter_test` disables shadows and draws them as hard black outlines – not a real styling issue in screenshots.

## Data sources

- OurAirports (public domain): airports, runways, frequencies, navaids – downloaded in-app from `davidmegginson.github.io/ourairports-data`.
- Later: OpenAIP (airspaces, API key), SimBrief API (IFR OFP), aviationweather.gov (METAR/TAF), X-Plane CIFP/earth_awy.dat (IFR procedures).
