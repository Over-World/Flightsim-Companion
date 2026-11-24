import 'nav_math.dart';
import 'wmm/wmm.dart';

/// Input point of a navlog; the leg *to* this point uses its altitude and,
/// if set, its wind.
class NavlogPoint {
  const NavlogPoint({
    required this.ident,
    required this.latitude,
    required this.longitude,
    this.name = '',
    this.altitudeFt,
    this.windDirection,
    this.windSpeedKt,
    this.actualTimeOver,
    this.via,
    this.tasKt,
    this.fuelFlowLph,
  });

  final String ident;
  final String name;
  final double latitude;
  final double longitude;
  final int? altitudeFt;
  final int? windDirection;
  final int? windSpeedKt;
  final DateTime? actualTimeOver;

  /// Airway or procedure on the leg to this point.
  final String? via;

  /// Leg TAS and fuel flow; `null` = the navlog's cruise values.
  final int? tasKt;
  final double? fuelFlowLph;

  bool get hasOwnWind => windDirection != null && windSpeedKt != null;
}

class NavlogLeg {
  const NavlogLeg({
    required this.from,
    required this.to,
    required this.distanceNm,
    required this.trueCourse,
    required this.variation,
    required this.windDirection,
    required this.windSpeedKt,
    required this.windCorrectionAngle,
    required this.trueHeading,
    required this.groundSpeed,
    required this.ete,
    required this.fuelL,
    required this.cumulativeDistanceNm,
    required this.cumulativeTime,
    required this.cumulativeFuelL,
  });

  final NavlogPoint from;
  final NavlogPoint to;
  final double distanceNm;
  final double trueCourse;

  /// Magnetic variation (east positive) at the leg midpoint.
  final double variation;
  final int windDirection;
  final int windSpeedKt;

  /// `null` when the wind is too strong to fly the leg.
  final double? windCorrectionAngle;
  final double? trueHeading;
  final double? groundSpeed;
  final Duration? ete;
  final double? fuelL;
  final double cumulativeDistanceNm;
  final Duration? cumulativeTime;
  final double? cumulativeFuelL;

  double get magneticCourse => trueToMagnetic(trueCourse, variation);
  double? get magneticHeading =>
      trueHeading == null ? null : trueToMagnetic(trueHeading!, variation);
  bool get solvable => groundSpeed != null;
}

class Navlog {
  const Navlog(this.legs);

  final List<NavlogLeg> legs;

  double get totalDistanceNm =>
      legs.isEmpty ? 0 : legs.last.cumulativeDistanceNm;
  Duration? get totalTime =>
      legs.isEmpty ? Duration.zero : legs.last.cumulativeTime;
  double? get totalFuelL => legs.isEmpty ? 0 : legs.last.cumulativeFuelL;

  /// Computes the navlog with [trueAirspeed] and [fuelBurnLph] for every leg
  /// whose end point has no own TAS / fuel flow (e.g. from an OFP).
  static Navlog compute({
    required List<NavlogPoint> points,
    required double trueAirspeed,
    required double fuelBurnLph,
    int? defaultWindDirection,
    int? defaultWindSpeedKt,
    Wmm? model,
    double? decimalYear,
  }) {
    final wmm = model ?? Wmm.instance;
    final legs = <NavlogLeg>[];
    var cumDist = 0.0;
    Duration? cumTime = Duration.zero;
    double? cumFuel = 0;
    for (var i = 1; i < points.length; i++) {
      final from = points[i - 1];
      final to = points[i];
      final dist = distanceNm(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude,
      );
      final tc = initialCourse(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude,
      );
      final mid = midpoint(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude,
      );
      final variation = wmm.declination(
        mid.latitude,
        mid.longitude,
        decimalYear: decimalYear,
      );
      final windDir = to.hasOwnWind
          ? to.windDirection!
          : (defaultWindDirection ?? 0);
      final windSpeed = to.hasOwnWind
          ? to.windSpeedKt!
          : (defaultWindSpeedKt ?? 0);
      final tas = to.tasKt?.toDouble() ?? trueAirspeed;
      final burn = to.fuelFlowLph ?? fuelBurnLph;
      final solution = solveWind(
        trueCourse: tc,
        trueAirspeed: tas,
        windFrom: windDir.toDouble(),
        windSpeed: windSpeed.toDouble(),
      );
      final ete = solution == null
          ? null
          : Duration(seconds: (dist / solution.groundSpeed * 3600).round());
      final fuel = ete == null ? null : ete.inSeconds / 3600 * burn;
      cumDist += dist;
      cumTime = (cumTime == null || ete == null) ? null : cumTime + ete;
      cumFuel = (cumFuel == null || fuel == null) ? null : cumFuel + fuel;
      legs.add(
        NavlogLeg(
          from: from,
          to: to,
          distanceNm: dist,
          trueCourse: tc,
          variation: variation,
          windDirection: windDir,
          windSpeedKt: windSpeed,
          windCorrectionAngle: solution?.windCorrectionAngle,
          trueHeading: solution?.trueHeading,
          groundSpeed: solution?.groundSpeed,
          ete: ete,
          fuelL: fuel,
          cumulativeDistanceNm: cumDist,
          cumulativeTime: cumTime,
          cumulativeFuelL: cumFuel,
        ),
      );
    }
    return Navlog(legs);
  }
}

/// Course/heading as pilots write it: three digits, 360 instead of 000.
String formatCourse(double degrees) {
  final r = degrees.round() % 360;
  return (r == 0 ? 360 : r).toString().padLeft(3, '0');
}

/// `1:05` for durations, `0:42` below an hour.
String formatDuration(Duration d) {
  final minutes = (d.inSeconds / 60).round();
  return '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}';
}
