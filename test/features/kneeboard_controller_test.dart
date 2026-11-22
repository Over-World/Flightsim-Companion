import 'package:drift/native.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/aircraft_repository.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:flightsim_companion/data/repositories/logbook_repository.dart';
import 'package:flightsim_companion/data/repositories/navdata_repository.dart';
import 'package:flightsim_companion/features/kneeboard/kneeboard_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fixtures.dart';

void main() {
  late AppDatabase db;
  late FlightRepository flights;
  late SharedPreferences prefs;
  late KneeboardController kb;
  late int flightId;

  /// Lets the drift stream deliver the latest state to the controller.
  Future<void> settle() => pumpEventQueue(times: 50);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    flights = FlightRepository(db);
    await AircraftRepository(db).seedDefaults();
    await insertNavdataFixtures(db);
    flightId = await createFixtureFlight(flights);
    kb = KneeboardController(
      prefs: prefs,
      flights: flights,
      navdata: NavdataRepository(db),
      logbook: LogbookRepository(db),
    );
  });

  tearDown(() async {
    kb.dispose();
    await db.close();
  });

  test('walks through a whole flight and undoes steps', () async {
    await kb.open(flightId);
    await settle();
    expect(kb.isOpen, isTrue);
    expect(kb.flight!.status, FlightStatus.active);
    expect(kb.phase, FlightPhase.preflight);
    expect(kb.navlog!.legs, hasLength(2));
    expect(prefs.getInt('activeFlightId'), flightId);

    await kb.blockOff();
    await settle();
    expect(kb.phase, FlightPhase.taxiOut);

    await kb.takeoff();
    await settle();
    expect(kb.phase, FlightPhase.enroute);
    expect(kb.currentLeg, 0);
    expect(kb.legStartedAt, isNotNull);
    expect(kb.etas.every((e) => e != null), isTrue);

    await kb.passWaypoint();
    await settle();
    expect(kb.currentLeg, 1);

    await kb.undo();
    await settle();
    expect(kb.currentLeg, 0);

    await kb.passWaypoint();
    await settle();
    await kb.passWaypoint();
    await settle();
    expect(kb.phase, FlightPhase.arrived);

    await kb.landing();
    await settle();
    await kb.blockOn();
    await settle();
    expect(kb.phase, FlightPhase.parked);
    expect(kb.flight!.status, FlightStatus.completed);

    await kb.resetTimes();
    await settle();
    expect(kb.waypoints.every((w) => w.actualTimeOver == null), isTrue);
  });

  test('frequencies of departure, navaids and destination', () async {
    await kb.open(flightId);
    await settle();
    expect(kb.frequencies.map((g) => '${g.role}:${g.ident}'), [
      'dep:EDFE',
      'navaid:FFM',
      'dest:EDFZ',
    ]);
    expect(kb.frequencies[1].entries.single.frequency, '114.20');
  });

  test('restores the active flight after a restart', () async {
    await kb.open(flightId);
    await settle();
    final restored = KneeboardController(
      prefs: prefs,
      flights: flights,
      navdata: NavdataRepository(db),
      logbook: LogbookRepository(db),
    );
    await settle();
    expect(restored.flight?.id, flightId);
    restored.dispose();
  });

  test('stopwatch accumulates across pauses', () {
    expect(kb.stopwatchRunning, isFalse);
    kb.toggleStopwatch();
    expect(kb.stopwatchRunning, isTrue);
    kb.toggleStopwatch();
    final paused = kb.stopwatchElapsed();
    expect(kb.stopwatchElapsed(), paused);
    kb.resetStopwatch();
    expect(kb.stopwatchElapsed(), Duration.zero);
  });
}
