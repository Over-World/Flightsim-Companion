import 'package:flightsim_companion/core/nav_math.dart';
import 'package:flightsim_companion/core/navlog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // EDFE (Egelsbach) -> FFM VOR -> EDFZ (Mainz-Finthen).
  const points = [
    NavlogPoint(ident: 'EDFE', latitude: 49.96, longitude: 8.6458),
    NavlogPoint(
      ident: 'FFM',
      latitude: 50.0536,
      longitude: 8.6372,
      altitudeFt: 2500,
    ),
    NavlogPoint(
      ident: 'EDFZ',
      latitude: 49.9675,
      longitude: 8.1475,
      altitudeFt: 3500,
      windDirection: 270,
      windSpeedKt: 20,
    ),
  ];

  test('legs, magnetic courses and cumulative values', () {
    final log = Navlog.compute(
      points: points,
      trueAirspeed: 100,
      fuelBurnLph: 30,
      defaultWindDirection: 0,
      defaultWindSpeedKt: 0,
      decimalYear: 2026.9,
    );
    expect(log.legs, hasLength(2));
    final first = log.legs.first;
    expect(first.distanceNm, closeTo(5.6, 0.2));
    expect(first.trueCourse, closeTo(357, 2));
    // About 4° east variation around Frankfurt.
    expect(first.variation, closeTo(4, 0.6));
    expect(first.magneticCourse, closeTo(353, 2));
    // No wind: GS = TAS.
    expect(first.groundSpeed, closeTo(100, 1e-9));

    final second = log.legs.last;
    // Westbound into a 20 kt headwind from the waypoint's own wind.
    expect(second.windDirection, 270);
    expect(second.groundSpeed!, lessThan(85));
    expect(
      log.totalDistanceNm,
      closeTo(first.distanceNm + second.distanceNm, 1e-9),
    );
    expect(log.totalTime, first.ete! + second.ete!);
    expect(log.totalFuelL, closeTo(log.totalTime!.inSeconds / 3600 * 30, 1e-6));
  });

  test('unsolvable wind propagates to the totals', () {
    final log = Navlog.compute(
      points: points,
      trueAirspeed: 15,
      fuelBurnLph: 30,
      defaultWindDirection: 90,
      defaultWindSpeedKt: 40,
    );
    expect(log.legs.first.solvable, isFalse);
    expect(log.totalTime, isNull);
    expect(log.totalFuelL, isNull);
  });

  test('destination point round trip', () {
    final p = destinationPoint(50, 8, 120, 30);
    expect(distanceNm(50, 8, p.latitude, p.longitude), closeTo(30, 1e-6));
    expect(initialCourse(50, 8, p.latitude, p.longitude), closeTo(120, 1e-6));
  });

  test('formatting', () {
    expect(formatCourse(0.2), '360');
    expect(formatCourse(7.6), '008');
    expect(formatDuration(const Duration(minutes: 65, seconds: 20)), '1:05');
    expect(formatDuration(const Duration(seconds: 2550)), '0:43');
  });
}
