# Flightsim Companion

Kneeboard and flight planning companion for X-Plane 12 (primary) and MSFS. Plan and fly VFR and IFR flights with navlog, stopwatch, frequencies and handwritten notes – optimised for Android tablets in portrait and landscape, usable on phones.

## Status

Work in progress. Implemented so far:

- Worldwide navigation data from OurAirports (airports, runways, frequencies, navaids), offline in SQLite
- Airport search and details with frequencies, runways and nearby navaids (magnetic radials via WMM2025)
- Aircraft profiles (cruise speed, fuel burn, weights)
- Flight planning: route from airports, navaids, radial/DME fixes and coordinates; navlog with wind triangle, magnetic headings, times and fuel
- Kneeboard (portrait and landscape): current leg with heading, ETA and overdue timer, off/on block, takeoff, waypoint passing, flight and block time, stopwatch, frequencies
- E6B flight computer with search: wind, fuel, altitudes, TAS/Mach, descent, turns, conversions
- Expected runways with wind components and crosswind limits
- METAR/TAF from aviationweather.gov, nearest station for small airfields, offline cache
- Stylus notepad with ATIS and CRAFT clearance templates, per flight or general; palm rejection
- First-start setup, X-Plane 12 web API connection test
- German and English UI, light and dark theme

## Build

```sh
flutter pub get
cp dart_defines.example.json dart_defines.json   # fill in app keys, optional
flutter run --dart-define-from-file=dart_defines.json
```

Without keys the app runs; features that need them are disabled with a hint.

## Data

- [OurAirports](https://ourairports.com/data/) – public domain
- [aviationweather.gov](https://aviationweather.gov/data/api/) – METAR/TAF
- [World Magnetic Model 2025](https://www.ncei.noaa.gov/products/world-magnetic-model) – NOAA NCEI, public domain

Not for real-world navigation.
