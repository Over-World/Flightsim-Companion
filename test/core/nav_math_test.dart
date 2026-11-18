import 'package:flightsim_companion/core/morse.dart';
import 'package:flightsim_companion/core/nav_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('distance and course', () {
    test('EDDF to EDDM is about 162 NM, course about 127°', () {
      // Frankfurt ARP -> Munich ARP.
      final d = distanceNm(50.0333, 8.5706, 48.3538, 11.7861);
      final c = initialCourse(50.0333, 8.5706, 48.3538, 11.7861);
      expect(d, closeTo(162, 2));
      expect(c, closeTo(127, 2));
    });

    test('due north and due east', () {
      expect(initialCourse(0, 0, 1, 0), closeTo(0, 1e-9));
      expect(initialCourse(0, 0, 0, 1), closeTo(90, 1e-9));
      expect(distanceNm(0, 0, 1, 0), closeTo(60, 0.1));
    });
  });

  group('wind triangle', () {
    test('no wind leaves heading and speed unchanged', () {
      final s = solveWind(
        trueCourse: 90,
        trueAirspeed: 100,
        windFrom: 0,
        windSpeed: 0,
      )!;
      expect(s.windCorrectionAngle, closeTo(0, 1e-9));
      expect(s.trueHeading, closeTo(90, 1e-9));
      expect(s.groundSpeed, closeTo(100, 1e-9));
    });

    test('pure headwind reduces ground speed', () {
      final s = solveWind(
        trueCourse: 270,
        trueAirspeed: 100,
        windFrom: 270,
        windSpeed: 20,
      )!;
      expect(s.groundSpeed, closeTo(80, 1e-9));
      expect(s.windCorrectionAngle, closeTo(0, 1e-9));
    });

    test('crosswind from the right corrects to the right', () {
      // Course 360, wind 090/20, TAS 100: WCA = asin(0.2) ≈ 11.5°.
      final s = solveWind(
        trueCourse: 360,
        trueAirspeed: 100,
        windFrom: 90,
        windSpeed: 20,
      )!;
      expect(s.windCorrectionAngle, closeTo(11.54, 0.01));
      expect(s.trueHeading, closeTo(11.54, 0.01));
      expect(s.groundSpeed, closeTo(97.98, 0.01));
    });

    test('wind stronger than TAS across track is unsolvable', () {
      expect(
        solveWind(trueCourse: 0, trueAirspeed: 50, windFrom: 90, windSpeed: 60),
        isNull,
      );
    });
  });

  test('magnetic variation: east is least', () {
    expect(trueToMagnetic(100, 3), 97);
    expect(trueToMagnetic(2, 3), 359);
    expect(trueToMagnetic(100, -5), 105);
  });

  test('wind components for runway 27', () {
    final c = windComponents(runwayHeading: 270, windFrom: 300, windSpeed: 20);
    expect(c.headwind, closeTo(17.32, 0.01));
    expect(c.crosswind, closeTo(10, 0.01));
  });

  test('morse ident', () {
    expect(toMorse('FFM'), '··−·  ··−·  −−');
  });
}
