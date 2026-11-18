import 'dart:convert';
import 'dart:math' as math;

/// Weight & balance. Weights in kg; arms in the aircraft's POH unit
/// (inches, metres or millimetres) – only ratios matter for the CG.

enum StationKind { seat, baggage, fuel, other }

class WbStation {
  const WbStation({
    required this.name,
    required this.arm,
    this.kind = StationKind.other,
    this.maxKg,
  });

  final String name;
  final double arm;
  final StationKind kind;
  final double? maxKg;

  Map<String, Object?> toJson() => {
    'name': name,
    'arm': arm,
    'kind': kind.name,
    if (maxKg != null) 'max': maxKg,
  };

  factory WbStation.fromJson(Map<String, dynamic> json) => WbStation(
    name: json['name'] as String? ?? '',
    arm: (json['arm'] as num).toDouble(),
    kind: StationKind.values.asNameMap()[json['kind']] ?? StationKind.other,
    maxKg: (json['max'] as num?)?.toDouble(),
  );

  static List<WbStation> decodeAll(String source) {
    final list = jsonDecode(source);
    return list is List
        ? [for (final s in list) WbStation.fromJson(s as Map<String, dynamic>)]
        : [];
  }

  static String encodeAll(List<WbStation> stations) =>
      jsonEncode([for (final s in stations) s.toJson()]);
}

/// Corner of the CG envelope (arm, weight).
class EnvelopePoint {
  const EnvelopePoint(this.arm, this.weightKg);

  final double arm;
  final double weightKg;

  List<double> toJson() => [arm, weightKg];

  static List<EnvelopePoint> decodeAll(String source) {
    final list = jsonDecode(source);
    return list is List
        ? [
            for (final p in list)
              EnvelopePoint((p[0] as num).toDouble(), (p[1] as num).toDouble()),
          ]
        : [];
  }

  static String encodeAll(List<EnvelopePoint> points) =>
      jsonEncode([for (final p in points) p.toJson()]);
}

class WbPoint {
  const WbPoint(this.weightKg, this.moment);

  final double weightKg;
  final double moment;

  double get cg => weightKg == 0 ? 0 : moment / weightKg;

  WbPoint operator +(WbPoint o) =>
      WbPoint(weightKg + o.weightKg, moment + o.moment);
}

class WbResult {
  const WbResult({
    required this.zeroFuel,
    required this.takeoff,
    required this.landing,
    required this.takeoffInEnvelope,
    required this.landingInEnvelope,
    required this.overMaxTakeoff,
    required this.overloadedStations,
  });

  final WbPoint zeroFuel;
  final WbPoint takeoff;
  final WbPoint landing;

  /// `null` when no envelope is defined.
  final bool? takeoffInEnvelope;
  final bool? landingInEnvelope;
  final bool overMaxTakeoff;

  /// Indices of stations loaded above their maximum.
  final List<int> overloadedStations;

  bool get ok =>
      takeoffInEnvelope != false &&
      landingInEnvelope != false &&
      !overMaxTakeoff &&
      overloadedStations.isEmpty;

  /// Computes zero-fuel, takeoff and landing condition. Fuel goes to the
  /// first fuel station.
  static WbResult compute({
    required double emptyKg,
    required double emptyArm,
    required List<WbStation> stations,
    required List<EnvelopePoint> envelope,
    required Map<int, double> loadsKg,
    required double takeoffFuelKg,
    required double landingFuelKg,
    double? maxTakeoffKg,
  }) {
    var zeroFuel = WbPoint(emptyKg, emptyKg * emptyArm);
    final overloaded = <int>[];
    for (var i = 0; i < stations.length; i++) {
      final s = stations[i];
      if (s.kind == StationKind.fuel) continue;
      final kg = loadsKg[i] ?? 0;
      zeroFuel += WbPoint(kg, kg * s.arm);
      if (s.maxKg != null && kg > s.maxKg! + 0.05) overloaded.add(i);
    }
    final fuelIndex = stations.indexWhere((s) => s.kind == StationKind.fuel);
    WbPoint withFuel(double kg) => fuelIndex < 0
        ? zeroFuel
        : zeroFuel + WbPoint(kg, kg * stations[fuelIndex].arm);
    final takeoff = withFuel(math.max(0, takeoffFuelKg));
    final landing = withFuel(math.max(0, landingFuelKg));
    if (fuelIndex >= 0) {
      final max = stations[fuelIndex].maxKg;
      if (max != null && takeoffFuelKg > max + 0.05) overloaded.add(fuelIndex);
    }
    bool? inside(WbPoint p) => envelope.length < 3
        ? null
        : pointInEnvelope(envelope, p.cg, p.weightKg);
    return WbResult(
      zeroFuel: zeroFuel,
      takeoff: takeoff,
      landing: landing,
      takeoffInEnvelope: inside(takeoff),
      landingInEnvelope: inside(landing),
      overMaxTakeoff:
          maxTakeoffKg != null && takeoff.weightKg > maxTakeoffKg + 0.05,
      overloadedStations: overloaded,
    );
  }
}

/// Ray casting; points on the edge count as inside.
bool pointInEnvelope(List<EnvelopePoint> polygon, double arm, double kg) {
  var inside = false;
  for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final a = polygon[i];
    final b = polygon[j];
    if (_onSegment(a, b, arm, kg)) return true;
    final crosses =
        (a.weightKg > kg) != (b.weightKg > kg) &&
        arm <
            (b.arm - a.arm) * (kg - a.weightKg) / (b.weightKg - a.weightKg) +
                a.arm;
    if (crosses) inside = !inside;
  }
  return inside;
}

bool _onSegment(EnvelopePoint a, EnvelopePoint b, double x, double y) {
  final cross =
      (b.arm - a.arm) * (y - a.weightKg) -
      (b.weightKg - a.weightKg) * (x - a.arm);
  if (cross.abs() >
      1e-6 * (1 + (b.arm - a.arm).abs() + (b.weightKg - a.weightKg).abs())) {
    return false;
  }
  return x >= math.min(a.arm, b.arm) - 1e-9 &&
      x <= math.max(a.arm, b.arm) + 1e-9 &&
      y >= math.min(a.weightKg, b.weightKg) - 1e-9 &&
      y <= math.max(a.weightKg, b.weightKg) + 1e-9;
}
