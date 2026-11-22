import 'dart:convert';

import 'sim_snapshot.dart';

const _ftPerM = 3.28084;
const _ktPerMs = 1.943844;

/// The X-Plane 12 datarefs the app reads, and how they become a
/// [SimSnapshot].
abstract final class XPlaneDatarefs {
  static const latitude = 'sim/flightmodel/position/latitude';
  static const longitude = 'sim/flightmodel/position/longitude';
  static const elevation = 'sim/flightmodel/position/elevation';
  static const agl = 'sim/flightmodel/position/y_agl';
  static const groundSpeed = 'sim/flightmodel/position/groundspeed';
  static const track = 'sim/flightmodel/position/hpath';
  static const headingTrue = 'sim/flightmodel/position/true_psi';
  static const headingMag = 'sim/flightmodel/position/mag_psi';
  static const ias = 'sim/flightmodel/position/indicated_airspeed';
  static const verticalSpeed = 'sim/flightmodel/position/vh_ind_fpm';
  static const gLoad = 'sim/flightmodel/forces/g_nrml';
  static const onGround = 'sim/flightmodel/failures/onground_any';
  static const paused = 'sim/time/paused';
  static const fuel = 'sim/flightmodel/weight/m_fuel_total';
  static const engines = 'sim/flightmodel/engine/ENGN_running';
  static const parkingBrake = 'sim/cockpit2/controls/parking_brake_ratio';
  static const aircraftIcao = 'sim/aircraft/view/acf_ICAO';

  static const _radios = 'sim/cockpit2/radios/actuators';

  /// Dataref of a radio's active or standby frequency.
  static String radio(SimRadio r, {required bool standby}) {
    final n = '${r.kind.name}${r.number}';
    final s = standby ? '_standby' : '';
    return r.kind == RadioKind.com
        ? '$_radios/$n${s}_frequency_hz_833'
        : '$_radios/$n${s}_frequency_hz';
  }

  /// kHz ↔ the dataref's raw unit (NAV datarefs count in 10 kHz).
  static int toRaw(SimRadio r, int khz) =>
      r.kind == RadioKind.nav ? (khz / 10).round() : khz;

  static int fromRaw(SimRadio r, num raw) =>
      r.kind == RadioKind.nav ? (raw * 10).round() : raw.round();

  static final all = [
    latitude,
    longitude,
    elevation,
    agl,
    groundSpeed,
    track,
    headingTrue,
    headingMag,
    ias,
    verticalSpeed,
    gLoad,
    onGround,
    paused,
    fuel,
    engines,
    parkingBrake,
    aircraftIcao,
    for (final r in SimRadio.all) ...[
      radio(r, standby: false),
      radio(r, standby: true),
    ],
  ];

  /// Builds a snapshot from the latest value of each dataref (by name).
  static SimSnapshot snapshot(Map<String, Object?> v) {
    double? number(String name, [double factor = 1]) => switch (v[name]) {
      final num n => n * factor,
      [final num n, ...] => n * factor,
      _ => null,
    };
    bool flag(String name) => (number(name) ?? 0) > 0.5;
    int? raw(String name) => number(name)?.round();
    return SimSnapshot(
      latitude: number(latitude),
      longitude: number(longitude),
      altitudeFt: number(elevation, _ftPerM),
      aglFt: number(agl, _ftPerM),
      groundSpeedKt: number(groundSpeed, _ktPerMs),
      trackTrue: number(track),
      headingTrue: number(headingTrue),
      headingMagnetic: number(headingMag),
      iasKt: number(ias),
      verticalSpeedFpm: number(verticalSpeed),
      gLoad: number(gLoad),
      onGround: v[onGround] == null || flag(onGround),
      paused: flag(paused),
      fuelKg: number(fuel),
      engineRunning: switch (v[engines]) {
        final List list => list.any((e) => e is num && e > 0),
        final num n => n > 0,
        _ => false,
      },
      parkingBrake: flag(parkingBrake),
      aircraftIcao: _text(v[aircraftIcao]),
      radios: {
        for (final r in SimRadio.all)
          r: RadioTuning(
            active: switch (raw(radio(r, standby: false))) {
              final n? => fromRaw(r, n),
              null => null,
            },
            standby: switch (raw(radio(r, standby: true))) {
              final n? => fromRaw(r, n),
              null => null,
            },
          ),
      },
    );
  }

  /// `data` datarefs arrive base64-encoded, zero-padded.
  static String? _text(Object? value) {
    if (value is! String || value.isEmpty) return null;
    try {
      final bytes = base64.decode(value).takeWhile((b) => b != 0).toList();
      final s = ascii.decode(bytes, allowInvalid: true).trim();
      return s.isEmpty ? null : s;
    } on FormatException {
      return null;
    }
  }
}
