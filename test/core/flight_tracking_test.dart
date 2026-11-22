import 'package:flightsim_companion/core/flight_tracking.dart';
import 'package:flightsim_companion/data/sim/sim_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('waypoint passage', () {
    // Leg from Egelsbach (49.96, 8.64) north to a point 10 NM north.
    const from = (49.96, 8.64);
    const to = (50.1267, 8.64);

    test('capture radius and abeam', () {
      // 2 NM short of the waypoint: not passed.
      expect(
        hasPassedWaypoint(from: from, to: to, lat: 50.0933, lon: 8.64),
        isFalse,
      );
      // Within 0.5 NM.
      expect(
        hasPassedWaypoint(from: from, to: to, lat: 50.1217, lon: 8.64),
        isTrue,
      );
      // 1 NM beyond, 2 NM to the east: abeam and passed.
      expect(
        hasPassedWaypoint(from: from, to: to, lat: 50.1433, lon: 8.692),
        isTrue,
      );
      // Beyond, but 8 NM away: not counted.
      expect(
        hasPassedWaypoint(from: from, to: to, lat: 50.1433, lon: 8.85),
        isFalse,
      );
    });

    test('leg progress: distance to go and cross-track', () {
      // 5 NM along, 1 NM east (right of a northbound leg).
      final p = legProgress(from: from, to: to, lat: 50.0433, lon: 8.666);
      expect(p.distanceToGoNm, closeTo(5.1, 0.1));
      expect(p.crossTrackNm, closeTo(1.0, 0.05));
      expect(p.timeToGo(100)!.inSeconds, closeTo(184, 5));
      expect(p.timeToGo(5), isNull);
      final left = legProgress(from: from, to: to, lat: 50.0433, lon: 8.614);
      expect(left.crossTrackNm, closeTo(-1.0, 0.05));
    });
  });

  group('flight events', () {
    final t0 = DateTime(2026, 11, 22, 10);
    late FlightEventDetector d;
    late TrackedPhase phase;
    var t = t0;
    final events = <FlightEvent>[];

    setUp(() {
      d = FlightEventDetector();
      phase = TrackedPhase.preflight;
      t = t0;
      events.clear();
    });

    /// Feeds [seconds] of 10 Hz snapshots and applies events to the phase.
    void run(double seconds, SimSnapshot s) {
      for (var i = 0; i < seconds * 10; i++) {
        t = t.add(const Duration(milliseconds: 100));
        final e = d.update(s, phase, t);
        if (e == null) continue;
        events.add(e);
        phase = switch (e) {
          FlightEvent.blockOff => TrackedPhase.taxiOut,
          FlightEvent.takeoff => TrackedPhase.airborne,
          FlightEvent.landing => TrackedPhase.landed,
          FlightEvent.blockOn => TrackedPhase.parked,
        };
      }
    }

    const parked = SimSnapshot(
      groundSpeedKt: 0,
      parkingBrake: true,
      engineRunning: true,
    );
    const taxi = SimSnapshot(groundSpeedKt: 12, engineRunning: true);
    const climb = SimSnapshot(
      onGround: false,
      groundSpeedKt: 80,
      verticalSpeedFpm: 700,
      engineRunning: true,
    );
    const flare = SimSnapshot(
      onGround: false,
      groundSpeedKt: 60,
      verticalSpeedFpm: -180,
      engineRunning: true,
    );
    const touch = SimSnapshot(
      groundSpeedKt: 58,
      verticalSpeedFpm: -20,
      gLoad: 1.35,
      engineRunning: true,
    );
    const rollout = SimSnapshot(groundSpeedKt: 30, engineRunning: true);
    const stopped = SimSnapshot(groundSpeedKt: 0, engineRunning: false);

    test('a whole flight', () {
      run(10, parked);
      expect(events, isEmpty);
      run(2, taxi);
      expect(events, isEmpty, reason: 'needs 3 s of rolling');
      run(2, taxi);
      expect(events, [FlightEvent.blockOff]);
      run(2, climb);
      run(2, climb);
      expect(events.last, FlightEvent.takeoff);
      run(60, climb);
      run(3, flare);
      run(0.2, touch);
      run(6, rollout);
      expect(events.last, FlightEvent.landing);
      expect(d.touchdown!.verticalSpeedFpm, -180);
      expect(d.touchdown!.gLoad, 1.35);
      run(10, stopped);
      expect(events, [
        FlightEvent.blockOff,
        FlightEvent.takeoff,
        FlightEvent.landing,
        FlightEvent.blockOn,
      ]);
    });

    test('a bounce is one landing, the first contact counts', () {
      phase = TrackedPhase.airborne;
      run(5, climb);
      run(1, flare);
      run(0.3, touch);
      run(1, const SimSnapshot(onGround: false, verticalSpeedFpm: -400));
      run(0.3, const SimSnapshot(groundSpeedKt: 50, gLoad: 1.8));
      run(6, rollout);
      expect(events, [FlightEvent.landing]);
      expect(d.touchdown!.verticalSpeedFpm, -180);
    });

    test('pause holds everything', () {
      run(2, taxi);
      run(30, const SimSnapshot(groundSpeedKt: 12, paused: true));
      run(2, taxi);
      expect(events, isEmpty);
    });
  });
}
