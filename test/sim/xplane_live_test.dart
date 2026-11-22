import 'package:flightsim_companion/data/sim/sim_snapshot.dart';
import 'package:flightsim_companion/data/sim/xplane_client.dart';
import 'package:flightsim_companion/data/sim/xplane_live.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_xplane.dart';

void main() {
  late FakeXPlane xp;

  tearDown(() => xp.stop());

  Future<XPlaneLiveSession> connect() =>
      XPlaneLiveSession.connect(host: '127.0.0.1', port: xp.port);

  test('streams decoded snapshots', () async {
    xp = await FakeXPlane.start(parkedAtEgelsbach());
    final session = await connect();
    final s = await session.snapshots.first;
    expect(session.version, '12.1.4');
    expect(s.latitude, closeTo(49.9608, 1e-6));
    expect(s.altitudeFt, closeTo(384, 1));
    expect(s.onGround, isTrue);
    expect(s.engineRunning, isTrue);
    expect(s.parkingBrake, isTrue);
    expect(s.aircraftIcao, 'C172');
    expect(s.fuelKg, 120);
    expect(s.radios[SimRadio.com1]!.active, 119150);
    expect(s.radios[SimRadio.nav1]!.active, 114200);
    expect(s.radios[SimRadio.adf1]!.standby, 400);

    xp.values['sim/flightmodel/position/groundspeed'] = 30.0;
    xp.values['sim/flightmodel/failures/onground_any'] = 0;
    xp.push();
    final moving = await session.snapshots.first;
    expect(moving.groundSpeedKt, closeTo(58.3, 0.1));
    expect(moving.onGround, isFalse);
    await session.close();
  });

  test('tunes and swaps radios', () async {
    xp = await FakeXPlane.start(parkedAtEgelsbach());
    final session = await connect();
    await session.snapshots.first;
    expect(session.tune(SimRadio.nav1, 115900, standby: true), isTrue);
    await session.snapshots.first;
    expect(xp.writes.last, (
      'sim/cockpit2/radios/actuators/nav1_standby_frequency_hz',
      11590,
    ));
    session.swap(SimRadio.com1);
    await session.snapshots.firstWhere(
      (s) => s.radios[SimRadio.com1]!.standby == 119150,
    );
    expect(session.latest!.radios[SimRadio.com1]!.active, 121730);
    await session.close();
  });

  test('skips datarefs the sim does not have', () async {
    xp = await FakeXPlane.start(
      parkedAtEgelsbach()..remove('sim/aircraft/view/acf_ICAO'),
    );
    final session = await connect();
    final s = await session.snapshots.first;
    expect(s.aircraftIcao, isNull);
    expect(s.latitude, isNotNull);
    await session.close();
  });

  test('reports a missing flight and a dropped connection', () async {
    xp = await FakeXPlane.start({});
    await expectLater(
      connect(),
      throwsA(
        isA<XPlaneException>().having((e) => e.message, 'message', 'noFlight'),
      ),
    );
    await xp.stop();

    xp = await FakeXPlane.start(parkedAtEgelsbach());
    final session = await connect();
    await session.snapshots.first;
    await xp.dropClients();
    await session.done;
  });
}
