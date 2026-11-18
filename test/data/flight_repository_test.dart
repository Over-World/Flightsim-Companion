import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/aircraft_repository.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:flutter_test/flutter_test.dart';

Airport _airport(int id, String ident, double lat, double lon) => Airport(
  id: id,
  ident: ident,
  type: 'small_airport',
  name: ident,
  latitude: lat,
  longitude: lon,
  isoCountry: 'DE',
  isoRegion: 'DE-HE',
);

void main() {
  late AppDatabase db;
  late FlightRepository repo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = FlightRepository(db);
    await AircraftRepository(db).seedDefaults();
  });

  tearDown(() => db.close());

  test('create, insert, move and delete waypoints', () async {
    final id = await repo.createFlight(
      rules: FlightRules.vfr,
      departure: _airport(1, 'EDFE', 49.96, 8.6458),
      destination: _airport(2, 'EDFZ', 49.9675, 8.1475),
      aircraftId: 1,
      cruiseAltitudeFt: 3500,
    );
    var f = (await repo.loadFlight(id))!;
    expect(f.flight.title, 'EDFE – EDFZ');
    expect(f.waypoints.map((w) => w.ident), ['EDFE', 'EDFZ']);
    expect(f.aircraft?.icaoType, 'C172');

    await repo.insertWaypoint(
      id,
      FlightWaypointsCompanion.insert(
        flightId: id,
        sequence: 0,
        kind: WaypointKind.navaid,
        ident: 'FFM',
        latitude: 50.0536,
        longitude: 8.6372,
      ),
    );
    f = (await repo.loadFlight(id))!;
    expect(f.waypoints.map((w) => w.ident), ['EDFE', 'FFM', 'EDFZ']);
    expect(f.waypoints.map((w) => w.sequence), [0, 1, 2]);
    // Inherits the altitude of the split leg.
    expect(f.waypoints[1].altitudeFt, 3500);
    expect(f.navlog!.legs, hasLength(2));

    await repo.moveWaypoint(id, 1, 0);
    f = (await repo.loadFlight(id))!;
    expect(f.waypoints.map((w) => w.ident), ['FFM', 'EDFE', 'EDFZ']);

    await repo.deleteWaypoint(id, f.waypoints.first.id);
    f = (await repo.loadFlight(id))!;
    expect(f.waypoints.map((w) => w.sequence), [0, 1]);
  });

  test('watchFlight emits on waypoint changes', () async {
    final id = await repo.createFlight(
      rules: FlightRules.vfr,
      departure: _airport(1, 'EDFE', 49.96, 8.6458),
      destination: _airport(2, 'EDFZ', 49.9675, 8.1475),
    );
    final emissions = <int>[];
    final sub = repo
        .watchFlight(id)
        .listen((f) => emissions.add(f!.waypoints.length));
    await pumpEventQueue();
    final wp = (await repo.loadFlight(id))!.waypoints.last;
    await repo.updateWaypoint(
      id,
      wp.id,
      const FlightWaypointsCompanion(altitudeFt: Value(4500)),
    );
    await pumpEventQueue();
    await sub.cancel();
    expect(emissions.length, greaterThanOrEqualTo(2));
    final updated = (await repo.loadFlight(id))!.waypoints.last;
    expect(updated.altitudeFt, 4500);
  });

  test('deleting a flight cascades to its waypoints', () async {
    final id = await repo.createFlight(
      rules: FlightRules.ifr,
      departure: _airport(1, 'EDFE', 49.96, 8.6458),
      destination: _airport(2, 'EDFZ', 49.9675, 8.1475),
    );
    await repo.deleteFlight(id);
    expect(await db.select(db.flightWaypoints).get(), isEmpty);
  });
}
