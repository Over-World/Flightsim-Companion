import 'dart:math' as math;

import '../data/sim/sim_snapshot.dart';
import 'nav_math.dart';

double _angleBetween(double a, double b) {
  final d = (a - b).abs() % 360;
  return d > 180 ? 360 - d : d;
}

/// Whether the aircraft at ([lat], [lon]) has passed the waypoint [to] of
/// the leg [from] → [to]: within [captureNm] of it, or beyond the
/// perpendicular through it (abeam) while closer than [abeamNm].
bool hasPassedWaypoint({
  required (double, double) from,
  required (double, double) to,
  required double lat,
  required double lon,
  double captureNm = 0.5,
  double abeamNm = 5,
}) {
  final d = distanceNm(lat, lon, to.$1, to.$2);
  if (d <= captureNm) return true;
  if (d > abeamNm || distanceNm(from.$1, from.$2, to.$1, to.$2) < 0.1) {
    return false;
  }
  final legCourse = initialCourse(from.$1, from.$2, to.$1, to.$2);
  final toWaypoint = initialCourse(lat, lon, to.$1, to.$2);
  // Waypoint behind the aircraft relative to the leg direction.
  return _angleBetween(legCourse, toWaypoint) > 90;
}

/// Live progress on the leg [from] → [to].
class LegProgress {
  const LegProgress({
    required this.distanceToGoNm,
    required this.crossTrackNm,
    required this.courseToWaypoint,
  });

  final double distanceToGoNm;

  /// Distance off the leg's great circle; positive = right of course.
  final double crossTrackNm;

  /// True course direct to the waypoint.
  final double courseToWaypoint;

  /// Time to the waypoint at [groundSpeedKt]; `null` when barely moving.
  Duration? timeToGo(double? groundSpeedKt) =>
      groundSpeedKt == null || groundSpeedKt < 20
      ? null
      : Duration(seconds: (distanceToGoNm / groundSpeedKt * 3600).round());
}

LegProgress legProgress({
  required (double, double) from,
  required (double, double) to,
  required double lat,
  required double lon,
}) {
  const r = earthRadiusNm;
  final d13 = distanceNm(from.$1, from.$2, lat, lon) / r;
  final t13 = initialCourse(from.$1, from.$2, lat, lon) * math.pi / 180;
  final t12 = initialCourse(from.$1, from.$2, to.$1, to.$2) * math.pi / 180;
  final xt = math.asin(math.sin(d13) * math.sin(t13 - t12)) * r;
  return LegProgress(
    distanceToGoNm: distanceNm(lat, lon, to.$1, to.$2),
    crossTrackNm: xt.isFinite ? xt : 0,
    courseToWaypoint: initialCourse(lat, lon, to.$1, to.$2),
  );
}

enum TrackedPhase { preflight, taxiOut, airborne, landed, parked }

enum FlightEvent { blockOff, takeoff, landing, blockOn }

/// Vertical speed and load factor when the wheels touched.
class Touchdown {
  const Touchdown({
    required this.verticalSpeedFpm,
    required this.gLoad,
    required this.at,
  });

  /// Negative = descending.
  final double verticalSpeedFpm;
  final double gLoad;
  final DateTime at;
}

/// Turns simulator snapshots into flight events, with debouncing so a
/// bounce or a gust doesn't count:
///
/// * block off: rolling faster than 3 kt for 3 s,
/// * takeoff: airborne for 3 s,
/// * landing: on the ground for 5 s after being airborne (the touchdown is
///   the first ground contact of that sequence),
/// * block on: stopped for 5 s with parking brake set or engines off.
///
/// Paused snapshots are ignored.
class FlightEventDetector {
  static const _rolling = Duration(seconds: 3);
  static const _airborne = Duration(seconds: 3);
  static const _settled = Duration(seconds: 5);
  static const _parked = Duration(seconds: 5);

  final _held = <String, DateTime>{};
  final _descent = <(DateTime, double)>[];
  bool? _wasOnGround;
  Touchdown? _contact;
  double _contactG = 1;

  /// The touchdown of the last landing event.
  Touchdown? touchdown;

  bool _for(String key, bool condition, Duration d, DateTime now) {
    if (!condition) {
      _held.remove(key);
      return false;
    }
    final since = _held.putIfAbsent(key, () => now);
    return now.difference(since) >= d;
  }

  FlightEvent? update(SimSnapshot s, TrackedPhase phase, DateTime now) {
    if (s.paused) {
      _held.clear();
      return null;
    }
    final gs = s.groundSpeedKt ?? 0;
    final vs = s.verticalSpeedFpm ?? 0;
    final g = s.gLoad ?? 1;

    // Touchdown: steepest descent in the last second before the first
    // ground contact, highest G in the following two seconds.
    if (!s.onGround) {
      _descent
        ..add((now, vs))
        ..removeWhere((e) => now.difference(e.$1).inMilliseconds > 1000);
      if (_contact != null && _for('reairborne', true, _settled, now)) {
        _contact = null;
      }
    } else {
      _held.remove('reairborne');
      if (_wasOnGround == false && _contact == null) {
        final rate = _descent.isEmpty
            ? vs
            : _descent.map((e) => e.$2).reduce(math.min);
        _contact = Touchdown(verticalSpeedFpm: rate, gLoad: g, at: now);
        _contactG = g;
      }
      final c = _contact;
      if (c != null && now.difference(c.at).inMilliseconds <= 2000) {
        _contactG = math.max(_contactG, g);
      }
    }
    _wasOnGround = s.onGround;

    switch (phase) {
      case TrackedPhase.preflight:
        if (_for('airborne', !s.onGround, _airborne, now)) {
          return FlightEvent.takeoff;
        }
        if (_for('rolling', s.onGround && gs > 3, _rolling, now)) {
          return FlightEvent.blockOff;
        }
      case TrackedPhase.taxiOut:
        if (_for('airborne', !s.onGround, _airborne, now)) {
          _contact = null;
          return FlightEvent.takeoff;
        }
      case TrackedPhase.airborne:
        final c = _contact;
        if (c != null && _for('settled', s.onGround, _settled, now)) {
          touchdown = Touchdown(
            verticalSpeedFpm: c.verticalSpeedFpm,
            gLoad: _contactG,
            at: c.at,
          );
          _contact = null;
          return FlightEvent.landing;
        }
      case TrackedPhase.landed:
        final stopped =
            s.onGround && gs < 1 && (s.parkingBrake || !s.engineRunning);
        if (_for('parked', stopped, _parked, now)) {
          return FlightEvent.blockOn;
        }
      case TrackedPhase.parked:
        break;
    }
    return null;
  }

  /// Forget timers, e.g. after the phase was changed by hand.
  void reset() {
    _held.clear();
    _contact = null;
  }
}
