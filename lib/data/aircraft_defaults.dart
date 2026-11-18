import '../core/weight_balance.dart';

/// Weight & balance data of the seeded default aircraft: typical POH values
/// (inches aft of datum, converted to kg) for the X-Plane models. Not for
/// real-world use.
class AircraftWbDefaults {
  const AircraftWbDefaults({
    required this.emptyArm,
    required this.taxiFuelL,
    required this.stations,
    required this.envelope,
  });

  final double emptyArm;
  final double taxiFuelL;
  final List<WbStation> stations;
  final List<EnvelopePoint> envelope;
}

const _lb = 0.45359237;

final aircraftWbDefaults = <String, AircraftWbDefaults>{
  // Cessna 172S POH: datum firewall front face, normal category.
  'C172': AircraftWbDefaults(
    emptyArm: 39.6,
    taxiFuelL: 4,
    stations: const [
      WbStation(
        name: 'Pilot & front passenger',
        arm: 37,
        kind: StationKind.seat,
      ),
      WbStation(name: 'Rear passengers', arm: 73, kind: StationKind.seat),
      WbStation(
        name: 'Baggage area 1',
        arm: 95,
        kind: StationKind.baggage,
        maxKg: 120 * _lb,
      ),
      WbStation(
        name: 'Baggage area 2',
        arm: 123,
        kind: StationKind.baggage,
        maxKg: 50 * _lb,
      ),
      WbStation(
        name: 'Fuel',
        arm: 48,
        kind: StationKind.fuel,
        maxKg: 53 * 3.785411784 * 0.72,
      ),
    ],
    envelope: const [
      EnvelopePoint(35, 1500 * _lb),
      EnvelopePoint(35, 1950 * _lb),
      EnvelopePoint(38.5, 2550 * _lb),
      EnvelopePoint(47.3, 2550 * _lb),
      EnvelopePoint(47.3, 1500 * _lb),
    ],
  ),
  // Cirrus SR22 POH: fuselage stations (inches).
  'SR22': AircraftWbDefaults(
    emptyArm: 139.8,
    taxiFuelL: 6,
    stations: const [
      WbStation(
        name: 'Pilot & front passenger',
        arm: 143.5,
        kind: StationKind.seat,
      ),
      WbStation(name: 'Rear passengers', arm: 180, kind: StationKind.seat),
      WbStation(
        name: 'Baggage',
        arm: 208,
        kind: StationKind.baggage,
        maxKg: 130 * _lb,
      ),
      WbStation(
        name: 'Fuel',
        arm: 153.75,
        kind: StationKind.fuel,
        maxKg: 92 * 3.785411784 * 0.72,
      ),
    ],
    envelope: const [
      EnvelopePoint(137.8, 2110 * _lb),
      EnvelopePoint(138.7, 2700 * _lb),
      EnvelopePoint(141, 3400 * _lb),
      EnvelopePoint(148.1, 3400 * _lb),
      EnvelopePoint(148.1, 2110 * _lb),
    ],
  ),
};

/// Taxi fuel for defaults without W&B data.
const defaultTaxiFuelL = {'PA18': 3.0, 'BE58': 10.0};
