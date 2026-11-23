import 'package:drift/native.dart';
import 'package:flightsim_companion/core/settings.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/aircraft_repository.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:flightsim_companion/data/repositories/logbook_repository.dart';
import 'package:flightsim_companion/data/repositories/navdata_repository.dart';
import 'package:flightsim_companion/features/kneeboard/kneeboard_controller.dart';
import 'package:flightsim_companion/features/kneeboard/screen_awake_keeper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fixtures.dart';

void main() {
  test('keeps the screen on during a flight, never or always', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settings = SettingsController(prefs);
    final db = AppDatabase(NativeDatabase.memory());
    await AircraftRepository(db).seedDefaults();
    await insertNavdataFixtures(db);
    final flightId = await createFixtureFlight(FlightRepository(db));
    final kb = KneeboardController(
      prefs: prefs,
      flights: FlightRepository(db),
      navdata: NavdataRepository(db),
      logbook: LogbookRepository(db),
    );
    final calls = <bool>[];
    final keeper = ScreenAwakeKeeper(
      settings: settings,
      kneeboard: kb,
      setAwake: (on) async => calls.add(on),
    );
    Future<void> settle() => pumpEventQueue(times: 50);

    expect(settings.screenAwake, ScreenAwake.flight);
    expect(calls, [false]);

    await kb.open(flightId);
    await settle();
    expect(calls.last, isTrue);

    // Parked: the flight is over, the screen may sleep again.
    await kb.blockOff();
    await settle();
    await kb.takeoff();
    await settle();
    await kb.landing();
    await settle();
    await kb.blockOn();
    await settle();
    expect(calls.last, isFalse);

    await settings.setScreenAwake(ScreenAwake.always);
    expect(calls.last, isTrue);
    await settings.setScreenAwake(ScreenAwake.never);
    expect(calls.last, isFalse);
    // Only changes reach the platform.
    expect(calls, [false, true, false, true, false]);

    keeper.dispose();
    kb.dispose();
    await db.close();
  });
}
