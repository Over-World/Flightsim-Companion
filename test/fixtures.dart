import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

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
    b.insertAll(db.runways, [
      RunwaysCompanion.insert(
        id: const Value(1),
        airportId: 2283,
        lengthFt: const Value(4600),
        surface: const Value('ASP'),
        lighted: true,
        closed: false,
        leIdent: const Value('08'),
        leHeadingTrue: const Value(84),
        leElevationFt: const Value(384),
        heIdent: const Value('26'),
        heHeadingTrue: const Value(264),
        heElevationFt: const Value(380),
      ),
      RunwaysCompanion.insert(
        id: const Value(2),
        airportId: 2290,
        lengthFt: const Value(3500),
        surface: const Value('ASP'),
        lighted: false,
        closed: false,
        leIdent: const Value('08'),
        heIdent: const Value('26'),
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

/// Fake aviationweather.gov: a METAR for EDDF (also found by area search,
/// so EDFE gets it as nearest station), nothing else.
http.Client fakeWeatherClient() => MockClient((request) async {
  final q = request.url.queryParameters;
  final kind = request.url.pathSegments.last;
  if (kind == 'metar' && (q['ids'] == 'EDDF' || q['bbox'] != null)) {
    return http.Response(
      jsonEncode([
        {
          'icaoId': 'EDDF',
          'obsTime': DateTime.now().millisecondsSinceEpoch ~/ 1000 - 600,
          'temp': 10,
          'dewp': 8,
          'wdir': 220,
          'wspd': 17,
          'visib': '6+',
          'altim': 989,
          'rawOb': 'METAR EDDF 180820Z 22017KT 9999 FEW021 10/08 Q0989',
          'lat': 50.045,
          'lon': 8.598,
          'clouds': [
            {'cover': 'FEW', 'base': 2100},
          ],
          'fltCat': 'VFR',
        },
      ]),
      200,
    );
  }
  return http.Response('', 204);
});
