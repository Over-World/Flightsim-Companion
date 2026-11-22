import 'package:drift/native.dart';
import 'package:flightsim_companion/core/settings.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/aircraft_repository.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:flightsim_companion/data/repositories/logbook_repository.dart';
import 'package:flightsim_companion/data/repositories/navdata_repository.dart';
import 'package:flightsim_companion/data/sim/sim_snapshot.dart';
import 'package:flightsim_companion/features/kneeboard/kneeboard_controller.dart';
import 'package:flightsim_companion/features/sim/sim_controller.dart';
import 'package:flightsim_companion/features/sim/sim_flight_tracker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fixtures.dart';
import '../sim/fake_xplane.dart';

void main() {
  late AppDatabase db;
  late KneeboardController kb;
  late SettingsController settings;
  late int flightId;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'simHost': '127.0.0.1'});
    final prefs = await SharedPreferences.getInstance();
    settings = SettingsController(prefs);
    db = AppDatabase(NativeDatabase.memory());
    await AircraftRepository(db).seedDefaults();
    await insertNavdataFixtures(db);
    flightId = await createFixtureFlight(FlightRepository(db));
    kb = KneeboardController(
      prefs: prefs,
      flights: FlightRepository(db),
      navdata: NavdataRepository(db),
      logbook: LogbookRepository(db),
    );
  });

  tearDown(() async {
    kb.dispose();
    await db.close();
  });

  test('X-Plane flies the whole kneeboard and writes the logbook', () async {
    final session = FakeSimSession();
    final sim = SimController(
      settings: settings,
      connector: (_, _) async => session,
    );
    var now = DateTime(2026, 11, 22, 10);
    final tracker = SimFlightTracker(
      sim: sim,
      kneeboard: kb,
      settings: settings,
      clock: () => now,
    );
    await kb.open(flightId);
    await pumpEventQueue(times: 50);
    expect(sim.status, SimStatus.connected);

    Future<void> fly(double seconds, SimSnapshot s) async {
      for (var i = 0; i < seconds * 10; i++) {
        now = now.add(const Duration(milliseconds: 100));
        session.send(s);
        await pumpEventQueue(times: 5);
      }
      await pumpEventQueue(times: 50);
    }

    await fly(5, simAt(49.96, 8.6458, parkingBrake: true));
    expect(kb.phase, FlightPhase.preflight);
    await fly(5, simAt(49.9605, 8.6450, gs: 12));
    expect(kb.phase, FlightPhase.taxiOut);
    await fly(5, simAt(49.965, 8.645, onGround: false, gs: 75, vs: 600));
    expect(kb.phase, FlightPhase.enroute);
    expect(kb.currentLeg, 0);

    // Halfway to FFM nothing happens; abeam FFM the leg advances.
    await fly(2, simAt(50.00, 8.642, onGround: false, gs: 100));
    expect(kb.currentLeg, 0);
    await fly(2, simAt(50.058, 8.62, onGround: false, gs: 100));
    expect(kb.currentLeg, 1);

    // The destination is not passed in the air, it's reached by landing.
    await fly(2, simAt(49.968, 8.16, onGround: false, gs: 70, vs: -150));
    expect(kb.currentLeg, 1);
    await fly(0.2, simAt(49.9675, 8.15, onGround: false, gs: 60, vs: -160));
    await fly(6, simAt(49.9675, 8.149, gs: 40, g: 1.3));
    expect(kb.phase, FlightPhase.landed);
    expect(kb.flight!.touchdownFpm, -160);
    expect(kb.flight!.touchdownG, 1.3);

    await fly(6, simAt(49.9675, 8.1475, parkingBrake: true));
    expect(kb.phase, FlightPhase.parked);
    final entries = await LogbookRepository(db).watchAll().first;
    expect(entries, hasLength(1));
    expect(entries.single.destinationIdent, 'EDFZ');
    expect(entries.single.touchdownFpm, -160);
    expect(entries.single.aircraftType, 'C172');
    expect(entries.single.distanceNm, greaterThan(15));

    // Undoing block on takes the logbook line back.
    await kb.undo();
    await pumpEventQueue(times: 50);
    expect(await LogbookRepository(db).watchAll().first, isEmpty);
    tracker.dispose();
    sim.dispose();
  });

  test('switched off, the sim only watches', () async {
    await settings.setSimAutomation(false);
    final session = FakeSimSession();
    final sim = SimController(
      settings: settings,
      connector: (_, _) async => session,
    );
    final tracker = SimFlightTracker(
      sim: sim,
      kneeboard: kb,
      settings: settings,
    );
    await kb.open(flightId);
    await pumpEventQueue(times: 50);
    for (var i = 0; i < 60; i++) {
      session.send(simAt(49.9605, 8.645, gs: 15));
      await pumpEventQueue(times: 5);
    }
    expect(kb.phase, FlightPhase.preflight);
    tracker.dispose();
    sim.dispose();
  });

  test('SimController waits for a flight and reconnects', () async {
    final xp = await FakeXPlane.start({});
    await settings.setSimConnection('127.0.0.1', xp.port);
    final sim = SimController(
      settings: settings,
      retryDelay: const Duration(milliseconds: 50),
    );
    final history = <SimStatus>[];
    sim.addListener(() {
      if (history.lastOrNull != sim.status) history.add(sim.status);
    });
    Future<void> until(SimStatus s) async {
      for (var i = 0; i < 500 && sim.status != s; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect(sim.status, s);
    }

    await until(SimStatus.waitingForFlight);
    xp.values.addAll(parkedAtEgelsbach());
    // The fake learns dataref ids at start, so restart it on the same port
    // like X-Plane loading a flight.
    final port = xp.port;
    await xp.stop();
    final loaded = await FakeXPlane.startOn(port, parkedAtEgelsbach());
    await until(SimStatus.connected);
    for (var i = 0; i < 250 && sim.snapshot == null; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(sim.snapshot!.radios[SimRadio.com1]!.active, 119150);

    history.clear();
    await loaded.dropClients();
    for (var i = 0; i < 500 && history.length < 2; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(history, [SimStatus.connecting, SimStatus.connected]);

    await settings.setSimLive(false);
    await until(SimStatus.off);
    sim.dispose();
    await loaded.stop();
  });
}
