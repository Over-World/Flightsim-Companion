import 'package:drift/drift.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';

/// Egelsbach, Mainz-Finthen and the Frankfurt VOR with a few frequencies.
Future<void> insertNavdataFixtures(AppDatabase db) async {
  await db.batch((b) {
    b.insertAll(db.airports, [
      AirportsCompanion.insert(
        id: const Value(2283),
        ident: 'EDFE',
        type: 'small_airport',
        name: 'Frankfurt-Egelsbach Airport',
        latitude: 49.96,
        longitude: 8.6458,
        isoCountry: 'DE',
        isoRegion: 'DE-HE',
      ),
      AirportsCompanion.insert(
        id: const Value(2290),
        ident: 'EDFZ',
        type: 'small_airport',
        name: 'Mainz-Finthen Airport',
        latitude: 49.9675,
        longitude: 8.1475,
        isoCountry: 'DE',
        isoRegion: 'DE-RP',
      ),
    ]);
    b.insertAll(db.airportFrequencies, [
      AirportFrequenciesCompanion.insert(
        id: const Value(1),
        airportId: 2283,
        type: 'INFO',
        frequencyMhz: 118.405,
      ),
      AirportFrequenciesCompanion.insert(
        id: const Value(2),
        airportId: 2290,
        type: 'INFO',
        frequencyMhz: 122.880,
      ),
    ]);
    b.insert(
      db.navaids,
      NavaidsCompanion.insert(
        id: const Value(85093),
        ident: 'FFM',
        name: 'Frankfurt',
        type: 'VOR-DME',
        frequencyKhz: const Value(114200),
        latitude: 50.0536,
        longitude: 8.6372,
        isoCountry: 'DE',
      ),
    );
  });
}

/// EDFE → FFM → EDFZ with the default C172 (id 1).
Future<int> createFixtureFlight(FlightRepository flights) async {
  const airport = Airport.new;
  final id = await flights.createFlight(
    rules: FlightRules.vfr,
    departure: airport(
      id: 2283,
      ident: 'EDFE',
      type: 'small_airport',
      name: 'Frankfurt-Egelsbach Airport',
      latitude: 49.96,
      longitude: 8.6458,
      isoCountry: 'DE',
      isoRegion: 'DE-HE',
    ),
    destination: airport(
      id: 2290,
      ident: 'EDFZ',
      type: 'small_airport',
      name: 'Mainz-Finthen Airport',
      latitude: 49.9675,
      longitude: 8.1475,
      isoCountry: 'DE',
      isoRegion: 'DE-RP',
    ),
    aircraftId: 1,
    cruiseAltitudeFt: 3500,
  );
  await flights.insertWaypoint(
    id,
    FlightWaypointsCompanion.insert(
      flightId: id,
      sequence: 0,
      kind: WaypointKind.navaid,
      refId: const Value(85093),
      ident: 'FFM',
      name: const Value('Frankfurt VOR-DME'),
      latitude: 50.0536,
      longitude: 8.6372,
    ),
  );
  return id;
}
