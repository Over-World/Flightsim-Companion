import 'dart:math' as math;

const double earthRadiusNm = 3440.065;

double _rad(double deg) => deg * math.pi / 180;
double _deg(double rad) => rad * 180 / math.pi;

/// Normalises an angle to [0, 360).
double normalizeDegrees(double deg) {
  final r = deg % 360;
  return r < 0 ? r + 360 : r;
}

/// Great-circle distance in nautical miles.
double distanceNm(double lat1, double lon1, double lat2, double lon2) {
  final dLat = _rad(lat2 - lat1);
  final dLon = _rad(lon2 - lon1);
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(_rad(lat1)) *
          math.cos(_rad(lat2)) *
          math.pow(math.sin(dLon / 2), 2);
  return 2 * earthRadiusNm * math.asin(math.min(1, math.sqrt(a)));
}

/// Initial true course from point 1 to point 2, in degrees.
double initialCourse(double lat1, double lon1, double lat2, double lon2) {
  final phi1 = _rad(lat1);
  final phi2 = _rad(lat2);
  final dLon = _rad(lon2 - lon1);
  final y = math.sin(dLon) * math.cos(phi2);
  final x =
      math.cos(phi1) * math.sin(phi2) -
      math.sin(phi1) * math.cos(phi2) * math.cos(dLon);
  return normalizeDegrees(_deg(math.atan2(y, x)));
}

/// Result of the wind triangle (E6B).
class WindSolution {
  const WindSolution({
    required this.windCorrectionAngle,
    required this.trueHeading,
    required this.groundSpeed,
  });

  /// Positive = correct to the right.
  final double windCorrectionAngle;
  final double trueHeading;
  final double groundSpeed;
}

/// Solves the wind triangle for a desired [trueCourse].
///
/// [windFrom] is the direction the wind blows from (true), as in METAR.
/// Returns `null` when the wind is too strong to hold the course.
WindSolution? solveWind({
  required double trueCourse,
  required double trueAirspeed,
  required double windFrom,
  required double windSpeed,
}) {
  if (trueAirspeed <= 0) return null;
  final angle = _rad(windFrom - trueCourse);
  final crossRatio = windSpeed * math.sin(angle) / trueAirspeed;
  if (crossRatio.abs() > 1) return null;
  final wca = math.asin(crossRatio);
  final gs = trueAirspeed * math.cos(wca) - windSpeed * math.cos(angle);
  if (gs <= 0) return null;
  return WindSolution(
    windCorrectionAngle: _deg(wca),
    trueHeading: normalizeDegrees(trueCourse + _deg(wca)),
    groundSpeed: gs,
  );
}

/// Converts a true direction to magnetic. East variation is positive
/// ("east is least").
double trueToMagnetic(double trueDeg, double variationEast) =>
    normalizeDegrees(trueDeg - variationEast);

/// Headwind (positive) / tailwind (negative) and crosswind (positive = from
/// the right) components for a runway heading.
({double headwind, double crosswind}) windComponents({
  required double runwayHeading,
  required double windFrom,
  required double windSpeed,
}) {
  final angle = _rad(windFrom - runwayHeading);
  return (
    headwind: windSpeed * math.cos(angle),
    crosswind: windSpeed * math.sin(angle),
  );
}
