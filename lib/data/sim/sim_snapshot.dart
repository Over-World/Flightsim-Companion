enum RadioKind { com, nav, adf }

/// A radio of the simulated aircraft, e.g. COM1 or NAV2.
class SimRadio {
  const SimRadio(this.kind, this.number);

  final RadioKind kind;
  final int number;

  static const com1 = SimRadio(RadioKind.com, 1);
  static const com2 = SimRadio(RadioKind.com, 2);
  static const nav1 = SimRadio(RadioKind.nav, 1);
  static const nav2 = SimRadio(RadioKind.nav, 2);
  static const adf1 = SimRadio(RadioKind.adf, 1);
  static const all = [com1, com2, nav1, nav2, adf1];

  String get label => '${kind.name.toUpperCase()}$number';

  /// Radios that can tune a frequency of [khz]: COM 118–137 MHz, NAV
  /// 108–118 MHz, ADF 190–1750 kHz.
  static List<SimRadio> forFrequency(int khz) => switch (khz) {
    >= 118000 && < 137000 => const [com1, com2],
    >= 108000 && < 118000 => const [nav1, nav2],
    >= 190 && <= 1750 => const [adf1],
    _ => const [],
  };

  @override
  bool operator ==(Object other) =>
      other is SimRadio && other.kind == kind && other.number == number;

  @override
  int get hashCode => Object.hash(kind, number);

  @override
  String toString() => label;
}

/// Active and standby frequency of a radio, both in kHz.
class RadioTuning {
  const RadioTuning({this.active, this.standby});

  final int? active;
  final int? standby;
}

/// The simulator's state at one moment. Units as everywhere in the app:
/// knots, feet, kilograms, true directions.
class SimSnapshot {
  const SimSnapshot({
    this.latitude,
    this.longitude,
    this.altitudeFt,
    this.aglFt,
    this.groundSpeedKt,
    this.trackTrue,
    this.headingTrue,
    this.headingMagnetic,
    this.iasKt,
    this.verticalSpeedFpm,
    this.gLoad,
    this.onGround = true,
    this.paused = false,
    this.fuelKg,
    this.engineRunning = false,
    this.parkingBrake = false,
    this.aircraftIcao,
    this.radios = const {},
  });

  final double? latitude;
  final double? longitude;
  final double? altitudeFt;
  final double? aglFt;
  final double? groundSpeedKt;
  final double? trackTrue;
  final double? headingTrue;
  final double? headingMagnetic;
  final double? iasKt;
  final double? verticalSpeedFpm;
  final double? gLoad;
  final bool onGround;
  final bool paused;
  final double? fuelKg;
  final bool engineRunning;
  final bool parkingBrake;
  final String? aircraftIcao;
  final Map<SimRadio, RadioTuning> radios;

  bool get hasPosition => latitude != null && longitude != null;
}
