import 'nav_math.dart';
import 'wmm/wmm.dart';

/// One usable direction of a runway (e.g. `26` of `08/26`).
class RunwayEnd {
  const RunwayEnd({
    required this.ident,
    required this.trueHeading,
    required this.magneticHeading,
    this.elevationFt,
    this.lengthFt,
    this.widthFt,
    this.surface,
    this.lighted = false,
  });

  final String ident;
  final double trueHeading;
  final double magneticHeading;
  final int? elevationFt;
  final int? lengthFt;
  final int? widthFt;
  final String? surface;
  final bool lighted;

  /// VFR traffic pattern altitude: threshold elevation + 1000 ft.
  int? get patternAltitudeFt =>
      elevationFt == null ? null : elevationFt! + 1000;
}

/// Wind relative to a runway end. Wind direction is true (METAR style).
class RunwayWind {
  const RunwayWind(this.end, this.headwind, this.crosswind);

  final RunwayEnd end;

  /// Negative = tailwind.
  final double headwind;

  /// Positive = from the right.
  final double crosswind;
}

/// Raw runway as stored (both ends). Kept free of drift types for tests.
class RunwayData {
  const RunwayData({
    this.leIdent,
    this.leHeadingTrue,
    this.leElevationFt,
    this.heIdent,
    this.heHeadingTrue,
    this.heElevationFt,
    this.lengthFt,
    this.widthFt,
    this.surface,
    this.lighted = false,
  });

  final String? leIdent;
  final double? leHeadingTrue;
  final int? leElevationFt;
  final String? heIdent;
  final double? heHeadingTrue;
  final int? heElevationFt;
  final int? lengthFt;
  final int? widthFt;
  final String? surface;
  final bool lighted;
}

final _designator = RegExp(r'^(\d{1,2})([LCR]?)$');

/// Splits runways into usable ends. Missing true headings are derived from
/// the designator (magnetic × 10) and the local variation; helipads and
/// water lanes without a numeric designator are skipped.
List<RunwayEnd> runwayEnds(
  List<RunwayData> runways, {
  required double latitude,
  required double longitude,
  int? airportElevationFt,
  double? variation,
}) {
  final v = variation ?? magneticVariation(latitude, longitude);
  RunwayEnd? end(String? ident, double? trueHdg, int? elev, RunwayData r) {
    if (ident == null) return null;
    final m = _designator.firstMatch(ident.trim());
    if (m == null) return null;
    final number = int.parse(m.group(1)!);
    if (number < 1 || number > 36) return null;
    final t = trueHdg ?? normalizeDegrees(number * 10 + v);
    return RunwayEnd(
      ident: ident.trim(),
      trueHeading: t,
      magneticHeading: trueToMagnetic(t, v),
      elevationFt: elev ?? airportElevationFt,
      lengthFt: r.lengthFt,
      widthFt: r.widthFt,
      surface: r.surface,
      lighted: r.lighted,
    );
  }

  final ends = [
    for (final r in runways) ...[
      end(r.leIdent, r.leHeadingTrue, r.leElevationFt, r),
      end(r.heIdent, r.heHeadingTrue, r.heElevationFt, r),
    ],
  ].nonNulls.toList();
  ends.sort((a, b) => a.ident.compareTo(b.ident));
  return ends;
}

List<RunwayWind> runwayWinds(
  List<RunwayEnd> ends, {
  required double windFrom,
  required double windSpeed,
}) => [
  for (final e in ends)
    () {
      final c = windComponents(
        runwayHeading: e.trueHeading,
        windFrom: windFrom,
        windSpeed: windSpeed,
      );
      return RunwayWind(e, c.headwind, c.crosswind);
    }(),
];

/// The runway end with the most headwind; `null` when calm (below 3 kt),
/// where any runway works and the pilot or ATIS decides.
RunwayEnd? suggestRunway(
  List<RunwayEnd> ends, {
  required double windFrom,
  required double windSpeed,
}) {
  if (ends.isEmpty || windSpeed < 3) return null;
  final winds = runwayWinds(ends, windFrom: windFrom, windSpeed: windSpeed);
  winds.sort((a, b) {
    final byHead = b.headwind.compareTo(a.headwind);
    if (byHead.abs() > 0 && (a.headwind - b.headwind).abs() >= 1) {
      return byHead;
    }
    // Same headwind (parallel runways): prefer the longer one.
    return (b.end.lengthFt ?? 0).compareTo(a.end.lengthFt ?? 0);
  });
  return winds.first.end;
}
