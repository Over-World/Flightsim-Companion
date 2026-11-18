import 'package:flightsim_companion/core/e6b.dart';
import 'package:flightsim_companion/core/nav_math.dart';
import 'package:flightsim_companion/core/quantities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('wind', () {
    test('findWind is the inverse of the wind triangle', () {
      final s = solveWind(
        trueCourse: 75,
        trueAirspeed: 110,
        windFrom: 310,
        windSpeed: 22,
      )!;
      final w = findWind(
        trueHeading: s.trueHeading,
        trueAirspeed: 110,
        trueCourse: 75,
        groundSpeed: s.groundSpeed,
      );
      expect(w.direction, closeTo(310, 1e-6));
      expect(w.speed, closeTo(22, 1e-6));
    });

    test('no drift and GS = TAS means calm', () {
      final w = findWind(
        trueHeading: 90,
        trueAirspeed: 100,
        trueCourse: 90,
        groundSpeed: 100,
      );
      expect(w.speed, closeTo(0, 1e-9));
    });
  });

  group('atmosphere', () {
    test('pressure altitude ~27-30 ft per hPa near sea level', () {
      expect(pressureAltitude(0, 1013.25), closeTo(0, 1e-6));
      expect(pressureAltitude(1000, 1003.25), closeTo(1000 + 277, 3));
    });

    test('density altitude equals pressure altitude at ISA', () {
      expect(densityAltitude(5000, isaTemperature(5000)), closeTo(5000, 5));
      // Hot day: 5000 ft PA at 30 °C is roughly 8000 ft DA.
      expect(densityAltitude(5000, 30), closeTo(8000, 250));
    });

    test('TAS equals CAS at sea level ISA', () {
      expect(
        trueAirspeed(calibratedAirspeed: 120, pressureAltitudeFt: 0, oatC: 15),
        closeTo(120, 0.05),
      );
    });

    test('TAS grows about 2 % per 1000 ft', () {
      // 120 KCAS at FL100, ISA (-4.8 °C): ~139-140 KTAS.
      final tas = trueAirspeed(
        calibratedAirspeed: 120,
        pressureAltitudeFt: 10000,
        oatC: isaTemperature(10000),
      );
      expect(tas, closeTo(139.5, 1));
    });

    test('Mach at FL350, 250 KCAS is about 0.74', () {
      expect(machFromCas(250, 35000), closeTo(0.741, 0.005));
    });

    test(
      'cold temperature correction (ICAO table: 1000 ft, -20 °C ≈ 130 ft)',
      () {
        final c = coldTemperatureCorrection(
          heightAboveAerodromeFt: 1000,
          aerodromeElevationFt: 0,
          aerodromeTempC: -20,
        );
        expect(c, closeTo(130, 15));
        expect(
          coldTemperatureCorrection(
            heightAboveAerodromeFt: 1000,
            aerodromeElevationFt: 0,
            aerodromeTempC: 20,
          ),
          0,
        );
      },
    );
  });

  group('climb, descent and turns', () {
    test('3° rule: ~318 ft per NM, VS ≈ GS × 5.3', () {
      expect(descentDistance(9000), closeTo(28.3, 0.2));
      expect(verticalSpeedForPath(120), closeTo(637, 2));
      expect(
        verticalSpeedForDistance(
          altitudeFt: 3000,
          distanceNm: 10,
          groundSpeed: 120,
        ),
        closeTo(600, 1e-9),
      );
    });

    test('gradients', () {
      expect(gradientFtPerNm(500, 100), 300);
      expect(gradientPercent(300), closeTo(4.94, 0.01));
    });

    test('standard rate turn', () {
      // Rule of thumb TAS/10 + 7 → 18° at 110 kt.
      expect(bankForTurnRate(110), closeTo(16.8, 0.5));
      // A standard rate turn takes two minutes.
      final bank = bankForTurnRate(110);
      expect(fullTurnTime(110, bank).inSeconds, closeTo(120, 1));
      expect(turnRadiusNm(110, bank), closeTo(0.58, 0.02));
    });
  });

  group('conversions', () {
    test('round trips and known values', () {
      expect(convert(100, Quantity.speed, 'kt', 'km/h'), closeTo(185.2, 0.01));
      expect(convert(0, Quantity.temperature, '°C', '°F'), closeTo(32, 1e-9));
      expect(
        convert(-40, Quantity.temperature, '°F', '°C'),
        closeTo(-40, 1e-9),
      );
      expect(
        convert(29.92, Quantity.pressure, 'inHg', 'hPa'),
        closeTo(1013.2, 0.1),
      );
      expect(convert(10, Quantity.volume, 'USG', 'L'), closeTo(37.85, 0.01));
      expect(convert(1000, Quantity.altitude, 'm', 'ft'), closeTo(3280.8, 0.1));
      expect(convert(65, Quantity.altitude, 'FL', 'ft'), 6500);
      for (final q in Quantity.values) {
        for (final u in q.units) {
          expect(
            convert(convert(12.5, q, q.base, u.symbol), q, u.symbol, q.base),
            closeTo(12.5, 1e-9),
          );
        }
      }
    });
  });
}
