import 'dart:math' as math;

import 'nav_math.dart';

/// Classic E6B flight computer functions. Units: knots, feet, nautical
/// miles, °C, hPa unless stated otherwise.

const double feetPerNm = 6076.12;
const double _g = 9.80665;
const double _msPerKt = 0.514444;
const double _seaLevelSpeedOfSoundKt = 661.4786;
const double _seaLevelPressureHpa = 1013.25;

double _rad(double d) => d * math.pi / 180;
double _deg(double r) => r * 180 / math.pi;

// ---------------------------------------------------------------------------
// Wind
// ---------------------------------------------------------------------------

/// Wind (from direction, speed) that turns the air vector (true heading,
/// TAS) into the ground vector (true course, ground speed).
({double direction, double speed}) findWind({
  required double trueHeading,
  required double trueAirspeed,
  required double trueCourse,
  required double groundSpeed,
}) {
  // Vectors in (north, east); wind blows *to* ground − air.
  final airN = trueAirspeed * math.cos(_rad(trueHeading));
  final airE = trueAirspeed * math.sin(_rad(trueHeading));
  final gndN = groundSpeed * math.cos(_rad(trueCourse));
  final gndE = groundSpeed * math.sin(_rad(trueCourse));
  final toN = gndN - airN;
  final toE = gndE - airE;
  final speed = math.sqrt(toN * toN + toE * toE);
  if (speed < 1e-9) return (direction: 0, speed: 0);
  return (
    direction: normalizeDegrees(_deg(math.atan2(toE, toN)) + 180),
    speed: speed,
  );
}

// ---------------------------------------------------------------------------
// Altitude and atmosphere (ISA)
// ---------------------------------------------------------------------------

/// Pressure altitude from an altitude read with [qnh] set.
double pressureAltitude(double altitudeFt, double qnh) =>
    altitudeFt +
    145366.45 * (1 - math.pow(qnh / _seaLevelPressureHpa, 0.190284));

/// ISA temperature at a pressure altitude (troposphere).
double isaTemperature(double pressureAltitudeFt) =>
    15 - 0.0019812 * pressureAltitudeFt;

/// Static pressure in hPa at a pressure altitude (troposphere).
double pressureAt(double pressureAltitudeFt) =>
    _seaLevelPressureHpa *
    math.pow(1 - 6.8755856e-6 * pressureAltitudeFt, 5.2558797);

/// Density altitude from pressure altitude and outside air temperature.
double densityAltitude(double pressureAltitudeFt, double oatC) {
  final pressureRatio = pressureAt(pressureAltitudeFt) / _seaLevelPressureHpa;
  final tempRatio = (oatC + 273.15) / 288.15;
  final sigma = pressureRatio / tempRatio;
  return 145442.16 * (1 - math.pow(sigma, 0.234969));
}

/// Speed of sound in knots at an outside air temperature.
double speedOfSound(double oatC) =>
    _seaLevelSpeedOfSoundKt * math.sqrt((oatC + 273.15) / 288.15);

/// True airspeed from calibrated airspeed (compressible flow).
double trueAirspeed({
  required double calibratedAirspeed,
  required double pressureAltitudeFt,
  required double oatC,
}) {
  final mach = machFromCas(calibratedAirspeed, pressureAltitudeFt);
  return mach * speedOfSound(oatC);
}

/// Mach number from calibrated airspeed and pressure altitude.
double machFromCas(double cas, double pressureAltitudeFt) {
  final ratio = cas / _seaLevelSpeedOfSoundKt;
  final impact =
      _seaLevelPressureHpa * (math.pow(1 + 0.2 * ratio * ratio, 3.5) - 1);
  final p = pressureAt(pressureAltitudeFt);
  return math.sqrt(5 * (math.pow(impact / p + 1, 2 / 7) - 1));
}

/// Cold temperature correction to add to an altitude (ICAO PANS-OPS).
/// [heightAboveAerodromeFt] is the published altitude minus elevation.
double coldTemperatureCorrection({
  required double heightAboveAerodromeFt,
  required double aerodromeElevationFt,
  required double aerodromeTempC,
}) {
  const lapse = 0.0019812; // °C per ft
  final t0 = aerodromeTempC + lapse * aerodromeElevationFt;
  final correction =
      heightAboveAerodromeFt *
      (15 - t0) /
      (273.15 +
          t0 -
          0.5 * lapse * (heightAboveAerodromeFt + aerodromeElevationFt));
  return math.max(0, correction);
}

// ---------------------------------------------------------------------------
// Climb and descent
// ---------------------------------------------------------------------------

/// Distance in NM needed to lose [altitudeToLoseFt] on a [pathDegrees] path.
double descentDistance(double altitudeToLoseFt, {double pathDegrees = 3}) =>
    altitudeToLoseFt / (math.tan(_rad(pathDegrees)) * feetPerNm);

/// Vertical speed (ft/min) for a [pathDegrees] path at [groundSpeed].
double verticalSpeedForPath(double groundSpeed, {double pathDegrees = 3}) =>
    groundSpeed * feetPerNm / 60 * math.tan(_rad(pathDegrees));

/// Vertical speed (ft/min) to change [altitudeFt] over [distanceNm].
double verticalSpeedForDistance({
  required double altitudeFt,
  required double distanceNm,
  required double groundSpeed,
}) => altitudeFt / (distanceNm / groundSpeed * 60);

/// Climb/descent gradient in ft/NM from vertical speed and ground speed.
double gradientFtPerNm(double verticalSpeed, double groundSpeed) =>
    verticalSpeed * 60 / groundSpeed;

double gradientPercent(double ftPerNm) => ftPerNm / feetPerNm * 100;

// ---------------------------------------------------------------------------
// Turns
// ---------------------------------------------------------------------------

/// Bank angle for a turn of [ratePerSecond] °/s (standard rate: 3).
double bankForTurnRate(double tas, {double ratePerSecond = 3}) =>
    _deg(math.atan(tas * _msPerKt * _rad(ratePerSecond) / _g));

/// Turn radius in NM at [bankDegrees].
double turnRadiusNm(double tas, double bankDegrees) {
  final v = tas * _msPerKt;
  return v * v / (_g * math.tan(_rad(bankDegrees))) / 1852;
}

/// Time for a full 360° turn at [bankDegrees].
Duration fullTurnTime(double tas, double bankDegrees) {
  final v = tas * _msPerKt;
  final omega = _g * math.tan(_rad(bankDegrees)) / v; // rad/s
  return Duration(milliseconds: (2 * math.pi / omega * 1000).round());
}

// ---------------------------------------------------------------------------
// Fuel
// ---------------------------------------------------------------------------

/// Fuel density in kg/L.
enum FuelKind {
  avgas(0.72),
  mogas(0.74),
  jetA1(0.80);

  const FuelKind(this.density);
  final double density;
}
