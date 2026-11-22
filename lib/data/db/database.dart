import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../aircraft_defaults.dart';
import '../repositories/aircraft_repository.dart';
import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Airports,
    Runways,
    AirportFrequencies,
    Navaids,
    AircraftProfiles,
    Flights,
    FlightWaypoints,
    ScratchPages,
    WeatherCache,
    Charts,
    ChartAnnotations,
    LogbookEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'flightsim_companion'));

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(flights, flights.windDirection);
        await m.addColumn(flights, flights.windSpeedKt);
        await m.addColumn(flights, flights.notes);
        await m.addColumn(flights, flights.blockOffAt);
        await m.addColumn(flights, flights.takeoffAt);
        await m.addColumn(flights, flights.landingAt);
        await m.addColumn(flights, flights.blockOnAt);
        await m.addColumn(flightWaypoints, flightWaypoints.refId);
        await m.createTable(scratchPages);
      }
      if (from < 3) {
        await m.addColumn(flights, flights.departureRunway);
        await m.addColumn(flights, flights.arrivalRunway);
        await m.addColumn(aircraftProfiles, aircraftProfiles.maxCrosswindKt);
        // Fill the new field for the seeded default aircraft.
        const defaults = {'C172': 15, 'SR22': 21, 'PA18': 10, 'BE58': 22};
        for (final MapEntry(key: type, value: kt) in defaults.entries) {
          await (update(aircraftProfiles)
                ..where((a) => a.icaoType.equals(type)))
              .write(AircraftProfilesCompanion(maxCrosswindKt: Value(kt)));
        }
      }
      if (from < 4) {
        await m.createTable(weatherCache);
      }
      if (from < 5) {
        for (final c in [
          flights.taxiFuelL,
          flights.contingencyPercent,
          flights.finalReserveMinutes,
          flights.extraFuelL,
          flights.fuelOnBoardL,
          flights.night,
          flights.loads,
        ]) {
          await m.addColumn(flights, c);
        }
        for (final c in [
          aircraftProfiles.taxiFuelL,
          aircraftProfiles.armUnit,
          aircraftProfiles.emptyArm,
          aircraftProfiles.stations,
          aircraftProfiles.envelope,
        ]) {
          await m.addColumn(aircraftProfiles, c);
        }
        for (final e in aircraftWbDefaults.entries) {
          await AircraftRepository.applyWbDefaults(this, e.key, e.value);
        }
        for (final e in defaultTaxiFuelL.entries) {
          await (update(aircraftProfiles)
                ..where((a) => a.icaoType.equals(e.key)))
              .write(AircraftProfilesCompanion(taxiFuelL: Value(e.value)));
        }
      }
      if (from < 6) {
        await m.createTable(charts);
        await m.createTable(chartAnnotations);
      }
      if (from < 7) {
        await m.addColumn(flights, flights.touchdownFpm);
        await m.addColumn(flights, flights.touchdownG);
        await m.addColumn(flights, flights.track);
        await m.createTable(logbookEntries);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
