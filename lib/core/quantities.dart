/// Physical quantities with their units for the E6B converter and unit
/// switchable fields. Every unit converts to and from a base unit.
enum Quantity {
  speed('kt'),
  distance('NM'),
  altitude('ft'),
  temperature('°C'),
  pressure('hPa'),
  volume('L'),
  mass('kg');

  const Quantity(this.base);

  final String base;

  List<UnitDef> get units => _units[this]!;

  UnitDef unit(String symbol) => units.firstWhere((u) => u.symbol == symbol);
}

class UnitDef {
  const UnitDef(this.symbol, this.factor, [this.offset = 0]);

  final String symbol;

  /// base = value × factor + offset
  final double factor;
  final double offset;

  double toBase(double v) => v * factor + offset;
  double fromBase(double v) => (v - offset) / factor;
}

const _units = <Quantity, List<UnitDef>>{
  Quantity.speed: [
    UnitDef('kt', 1),
    UnitDef('km/h', 1 / 1.852),
    UnitDef('mph', 0.868976),
    UnitDef('m/s', 1.943844),
    UnitDef('ft/min', 0.00987473),
  ],
  Quantity.distance: [
    UnitDef('NM', 1),
    UnitDef('km', 1 / 1.852),
    UnitDef('SM', 0.868976),
    UnitDef('m', 1 / 1852),
    UnitDef('ft', 1 / 6076.12),
  ],
  Quantity.altitude: [
    UnitDef('ft', 1),
    UnitDef('m', 3.28084),
    UnitDef('FL', 100),
  ],
  Quantity.temperature: [
    UnitDef('°C', 1),
    UnitDef('°F', 5 / 9, -160 / 9),
    UnitDef('K', 1, -273.15),
  ],
  Quantity.pressure: [
    UnitDef('hPa', 1),
    UnitDef('inHg', 33.8639),
    UnitDef('mmHg', 1.333224),
    UnitDef('psi', 68.9476),
  ],
  Quantity.volume: [
    UnitDef('L', 1),
    UnitDef('USG', 3.785411784),
    UnitDef('Imp gal', 4.54609),
  ],
  Quantity.mass: [UnitDef('kg', 1), UnitDef('lb', 0.45359237)],
};

double convert(double value, Quantity q, String from, String to) =>
    q.unit(to).fromBase(q.unit(from).toBase(value));
