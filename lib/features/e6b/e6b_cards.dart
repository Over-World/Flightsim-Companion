import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../core/e6b.dart';
import '../../core/nav_math.dart';
import '../../core/navlog.dart';
import '../../core/quantities.dart';
import '../../l10n/app_localizations.dart';
import 'e6b_widgets.dart';

/// Common constructor parameters of all calculators.
abstract class E6bCalculator extends StatefulWidget {
  const E6bCalculator({
    super.key,
    this.prefill = const {},
    this.collapsible = false,
    this.initiallyExpanded = false,
  });

  final Map<String, String> prefill;
  final bool collapsible;
  final bool initiallyExpanded;
}

abstract class _CardState<T extends E6bCalculator> extends CalcState<T> {
  @override
  Map<String, String> get prefill => widget.prefill;

  AppLocalizations get l10n => AppLocalizations.of(context);

  Widget card(String title, IconData icon, List<Widget> children) => CalcCard(
    title: title,
    icon: icon,
    collapsible: widget.collapsible,
    initiallyExpanded: widget.initiallyExpanded,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

String _deg(double v) => '${formatCourse(v)}°';
String _round(double v) => v.round().toString();
String _one(double v) => v.toStringAsFixed(1);
String _signed(double v) => v.round() > 0 ? '+${v.round()}' : '${v.round()}';

String _hm(double hours) {
  if (!hours.isFinite || hours < 0) return '–';
  return formatDuration(Duration(seconds: (hours * 3600).round()));
}

/// Runway designators (up to 36) become headings.
double _heading(double v) => v <= 36 && v == v.roundToDouble() ? v * 10 : v;

// ---------------------------------------------------------------------------

class WindTriangleCard extends E6bCalculator {
  const WindTriangleCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<WindTriangleCard> createState() => _WindTriangleState();
}

class _WindTriangleState extends _CardState<WindTriangleCard> {
  bool _findWind = false;

  @override
  Widget build(BuildContext context) {
    final tc = v('tc'), tas = v('tas');
    final List<Result> results;
    final List<Widget> fields;
    if (!_findWind) {
      final wd = v('windDir'), ws = v('windSpeed'), variation = v('variation');
      final s = tc == null || tas == null
          ? null
          : solveWind(
              trueCourse: tc,
              trueAirspeed: tas,
              windFrom: wd ?? 0,
              windSpeed: ws ?? 0,
            );
      fields = [
        field('tc', 'TC', suffix: '°T'),
        field('tas', 'TAS', quantity: Quantity.speed),
        field('windDir', l10n.windDirection, suffix: '°T'),
        field('windSpeed', l10n.windSpeed, quantity: Quantity.speed),
        field('variation', l10n.e6bVariation, suffix: '°E', signed: true),
      ];
      results = [
        Result('WCA', s == null ? null : '${_signed(s.windCorrectionAngle)}°'),
        Result('TH', s == null ? null : _deg(s.trueHeading)),
        Result(
          'MH',
          s == null
              ? null
              : _deg(trueToMagnetic(s.trueHeading, variation ?? 0)),
          highlight: true,
        ),
        Result('GS', s == null ? null : '${_round(s.groundSpeed)} kt'),
      ];
      if (tc != null && tas != null && s == null) {
        results.add(Result(l10n.e6bWindTooStrong, '!'));
      }
    } else {
      final th = v('th'), gs = v('gs');
      final w = tc == null || tas == null || th == null || gs == null
          ? null
          : findWind(
              trueHeading: th,
              trueAirspeed: tas,
              trueCourse: tc,
              groundSpeed: gs,
            );
      fields = [
        field('tc', 'TC', suffix: '°T'),
        field('gs', 'GS', quantity: Quantity.speed),
        field('th', 'TH', suffix: '°T'),
        field('tas', 'TAS', quantity: Quantity.speed),
      ];
      results = [
        Result(
          l10n.e6bWind,
          w == null ? null : '${_deg(w.direction)} / ${_round(w.speed)} kt',
          highlight: true,
        ),
      ];
    }
    return card(l10n.e6bWindTriangle, Icons.navigation_outlined, [
      SegmentedButton<bool>(
        segments: [
          ButtonSegment(value: false, label: Text(l10n.e6bFindHeading)),
          ButtonSegment(value: true, label: Text(l10n.e6bFindWind)),
        ],
        selected: {_findWind},
        onSelectionChanged: (s) => setState(() => _findWind = s.single),
      ),
      const SizedBox(height: 16),
      FieldGrid(children: fields),
      ResultList(results),
    ]);
  }
}

// ---------------------------------------------------------------------------

class WindComponentsCard extends E6bCalculator {
  const WindComponentsCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<WindComponentsCard> createState() => _WindComponentsState();
}

class _WindComponentsState extends _CardState<WindComponentsCard> {
  @override
  Widget build(BuildContext context) {
    final rwy = v('runway'), wd = v('windDir'), ws = v('windSpeed');
    final gust = v('gust');
    final c = rwy == null || wd == null || ws == null
        ? null
        : windComponents(
            runwayHeading: _heading(rwy),
            windFrom: wd,
            windSpeed: gust ?? ws,
          );
    String? head() {
      if (c == null) return null;
      final h = c.headwind.round();
      return h >= 0
          ? '${l10n.e6bHeadwind} $h kt'
          : '${l10n.e6bTailwind} ${-h} kt';
    }

    String? cross() {
      if (c == null) return null;
      final x = c.crosswind.round();
      if (x == 0) return '0 kt';
      return '${x.abs()} kt ${x > 0 ? l10n.e6bFromRight : l10n.e6bFromLeft}';
    }

    return card(l10n.e6bWindComponents, Icons.compare_arrows, [
      FieldGrid(
        children: [
          field('runway', l10n.e6bRunwayOrHeading, suffix: '°'),
          field('windDir', l10n.windDirection, suffix: '°'),
          field('windSpeed', l10n.windSpeed, quantity: Quantity.speed),
          field('gust', l10n.e6bGust, quantity: Quantity.speed),
        ],
      ),
      ResultList([
        Result(l10n.e6bLongitudinal, head(), highlight: true),
        Result(l10n.e6bCrosswind, cross(), highlight: true),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------------------

enum _Solve { first, second, third }

class SpeedTimeDistanceCard extends E6bCalculator {
  const SpeedTimeDistanceCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<SpeedTimeDistanceCard> createState() => _SpeedTimeDistanceState();
}

class _SpeedTimeDistanceState extends _CardState<SpeedTimeDistanceCard> {
  _Solve _solve = _Solve.first; // time

  @override
  Widget build(BuildContext context) {
    final gs = v('gs'), dist = v('dist'), minutes = v('minutes');
    final Result result;
    final List<Widget> fields;
    switch (_solve) {
      case _Solve.first:
        fields = [
          field('dist', l10n.e6bDistance, quantity: Quantity.distance),
          field('gs', 'GS', quantity: Quantity.speed),
        ];
        result = Result(
          l10n.e6bTime,
          gs == null || dist == null || gs <= 0 ? null : _hm(dist / gs),
          highlight: true,
        );
      case _Solve.second:
        fields = [
          field('gs', 'GS', quantity: Quantity.speed),
          field('minutes', l10n.e6bTime, suffix: 'min'),
        ];
        result = Result(
          l10n.e6bDistance,
          gs == null || minutes == null
              ? null
              : '${_one(gs * minutes / 60)} NM',
          highlight: true,
        );
      case _Solve.third:
        fields = [
          field('dist', l10n.e6bDistance, quantity: Quantity.distance),
          field('minutes', l10n.e6bTime, suffix: 'min'),
        ];
        result = Result(
          'GS',
          dist == null || minutes == null || minutes <= 0
              ? null
              : '${_round(dist / minutes * 60)} kt',
          highlight: true,
        );
    }
    return card(l10n.e6bSpeedTimeDistance, Icons.timer_outlined, [
      SegmentedButton<_Solve>(
        segments: [
          ButtonSegment(value: _Solve.first, label: Text(l10n.e6bTime)),
          ButtonSegment(value: _Solve.second, label: Text(l10n.e6bDistance)),
          const ButtonSegment(value: _Solve.third, label: Text('GS')),
        ],
        selected: {_solve},
        onSelectionChanged: (s) => setState(() => _solve = s.single),
      ),
      const SizedBox(height: 16),
      FieldGrid(children: fields),
      ResultList([result]),
    ]);
  }
}

// ---------------------------------------------------------------------------

class FuelCard extends E6bCalculator {
  const FuelCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<FuelCard> createState() => _FuelState();
}

class _FuelState extends _CardState<FuelCard> {
  _Solve _solve = _Solve.first; // amount
  FuelKind _kind = FuelKind.avgas;

  @override
  Widget build(BuildContext context) {
    final burn = v('burn'), amount = v('amount'), minutes = v('minutes');
    final burnUnit = input('burn', quantity: Quantity.volume).unit;
    final List<Widget> fields;
    double? liters;
    final List<Result> results;
    switch (_solve) {
      case _Solve.first:
        fields = [
          field('burn', l10n.e6bBurnPerHour, quantity: Quantity.volume),
          field('minutes', l10n.e6bTime, suffix: 'min'),
        ];
        liters = burn == null || minutes == null ? null : burn * minutes / 60;
        results = [
          Result(
            l10n.e6bFuelAmount,
            liters == null
                ? null
                : '${_one(Quantity.volume.unit(burnUnit).fromBase(liters))} $burnUnit',
            highlight: true,
          ),
        ];
      case _Solve.second:
        fields = [
          field('amount', l10n.e6bFuelAmount, quantity: Quantity.volume),
          field('burn', l10n.e6bBurnPerHour, quantity: Quantity.volume),
        ];
        liters = amount;
        results = [
          Result(
            l10n.e6bEndurance,
            amount == null || burn == null || burn <= 0
                ? null
                : _hm(amount / burn),
            highlight: true,
          ),
        ];
      case _Solve.third:
        fields = [
          field('amount', l10n.e6bFuelAmount, quantity: Quantity.volume),
          field('minutes', l10n.e6bTime, suffix: 'min'),
        ];
        liters = amount;
        final unit = input('amount', quantity: Quantity.volume).unit;
        results = [
          Result(
            l10n.e6bBurnPerHour,
            amount == null || minutes == null || minutes <= 0
                ? null
                : '${_one(Quantity.volume.unit(unit).fromBase(amount / minutes * 60))} $unit/h',
            highlight: true,
          ),
        ];
    }
    final kg = liters == null ? null : liters * _kind.density;
    results.add(
      Result(
        l10n.e6bFuelMass,
        kg == null ? null : '${_round(kg)} kg · ${_round(kg / 0.45359237)} lb',
      ),
    );
    return card(l10n.e6bFuel, Icons.local_gas_station_outlined, [
      SegmentedButton<_Solve>(
        segments: [
          ButtonSegment(value: _Solve.first, label: Text(l10n.e6bFuelAmount)),
          ButtonSegment(value: _Solve.second, label: Text(l10n.e6bEndurance)),
          ButtonSegment(value: _Solve.third, label: Text(l10n.e6bBurn)),
        ],
        selected: {_solve},
        onSelectionChanged: (s) => setState(() => _solve = s.single),
      ),
      const SizedBox(height: 16),
      FieldGrid(children: fields),
      const SizedBox(height: 12),
      DropdownButtonFormField<FuelKind>(
        initialValue: _kind,
        decoration: InputDecoration(
          labelText: l10n.aircraftFuelType,
          isDense: true,
        ),
        items: const [
          DropdownMenuItem(
            value: FuelKind.avgas,
            child: Text('AVGAS · 0.72 kg/L'),
          ),
          DropdownMenuItem(
            value: FuelKind.mogas,
            child: Text('MOGAS · 0.74 kg/L'),
          ),
          DropdownMenuItem(
            value: FuelKind.jetA1,
            child: Text('Jet A-1 · 0.80 kg/L'),
          ),
        ],
        onChanged: (k) => setState(() => _kind = k!),
      ),
      ResultList(results),
    ]);
  }
}

// ---------------------------------------------------------------------------

class AltitudeCard extends E6bCalculator {
  const AltitudeCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<AltitudeCard> createState() => _AltitudeState();
}

class _AltitudeState extends _CardState<AltitudeCard> {
  @override
  Widget build(BuildContext context) {
    final alt = v('alt'), qnh = v('qnh'), oat = v('oat');
    final pa = alt == null ? null : pressureAltitude(alt, qnh ?? 1013.25);
    final isa = pa == null ? null : isaTemperature(pa);
    final da = pa == null || oat == null ? null : densityAltitude(pa, oat);
    return card(l10n.e6bAltitude, Icons.terrain_outlined, [
      FieldGrid(
        children: [
          field('alt', l10n.e6bIndicatedAltitude, quantity: Quantity.altitude),
          field('qnh', 'QNH', quantity: Quantity.pressure),
          field('oat', 'OAT', quantity: Quantity.temperature, signed: true),
        ],
      ),
      ResultList([
        Result(
          l10n.e6bPressureAltitude,
          pa == null ? null : '${_round(pa)} ft',
        ),
        Result(l10n.e6bIsaTemp, isa == null ? null : '${_one(isa)} °C'),
        Result(
          l10n.e6bIsaDeviation,
          isa == null || oat == null ? null : '${_signed(oat - isa)} °C',
        ),
        Result(
          l10n.e6bDensityAltitude,
          da == null ? null : '${_round(da)} ft',
          highlight: true,
        ),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------------------

class AirspeedCard extends E6bCalculator {
  const AirspeedCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<AirspeedCard> createState() => _AirspeedState();
}

class _AirspeedState extends _CardState<AirspeedCard> {
  @override
  Widget build(BuildContext context) {
    final cas = v('cas'), pa = v('pa'), oat = v('oatSpeed');
    final temp = oat ?? (pa == null ? null : isaTemperature(pa));
    final tas = cas == null || pa == null || temp == null
        ? null
        : trueAirspeed(
            calibratedAirspeed: cas,
            pressureAltitudeFt: pa,
            oatC: temp,
          );
    final mach = cas == null || pa == null ? null : machFromCas(cas, pa);
    return card(l10n.e6bAirspeed, Icons.speed, [
      FieldGrid(
        children: [
          field('cas', 'CAS', quantity: Quantity.speed),
          field('pa', l10n.e6bPressureAltitude, quantity: Quantity.altitude),
          field(
            'oatSpeed',
            l10n.e6bOatOptional,
            quantity: Quantity.temperature,
            signed: true,
          ),
        ],
      ),
      ResultList([
        Result(
          'TAS',
          tas == null ? null : '${_round(tas)} kt',
          highlight: true,
        ),
        Result('Mach', mach?.toStringAsFixed(3)),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------------------

class DescentCard extends E6bCalculator {
  const DescentCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<DescentCard> createState() => _DescentState();
}

class _DescentState extends _CardState<DescentCard> {
  @override
  Widget build(BuildContext context) {
    final from = v('alt'), to = v('targetAlt'), gs = v('gs');
    final angle = v('angle') ?? 3;
    final avail = v('distance');
    final lose = from == null || to == null ? null : from - to;
    final tod = lose == null || lose <= 0 || angle <= 0
        ? null
        : descentDistance(lose, pathDegrees: angle);
    final vs = gs == null || angle <= 0
        ? null
        : verticalSpeedForPath(gs, pathDegrees: angle);
    final needed = lose == null || avail == null || gs == null || avail <= 0
        ? null
        : verticalSpeedForDistance(
            altitudeFt: lose,
            distanceNm: avail,
            groundSpeed: gs,
          );
    return card(l10n.e6bDescent, Icons.flight_land, [
      FieldGrid(
        children: [
          field('alt', l10n.e6bCurrentAltitude, quantity: Quantity.altitude),
          field(
            'targetAlt',
            l10n.e6bTargetAltitude,
            quantity: Quantity.altitude,
          ),
          field('gs', 'GS', quantity: Quantity.speed),
          field('angle', l10n.e6bPathAngle, suffix: '°'),
          field(
            'distance',
            l10n.e6bDistanceAvailable,
            quantity: Quantity.distance,
          ),
        ],
      ),
      ResultList([
        Result(
          l10n.e6bTodDistance,
          tod == null ? null : '${_one(tod)} NM',
          highlight: true,
        ),
        Result(
          l10n.e6bVerticalSpeed,
          vs == null ? null : '${_round(vs)} ft/min',
        ),
        if (avail != null)
          Result(
            l10n.e6bRequiredVs,
            needed == null ? null : '${_round(needed)} ft/min',
          ),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------------------

class ClimbCard extends E6bCalculator {
  const ClimbCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<ClimbCard> createState() => _ClimbState();
}

class _ClimbState extends _CardState<ClimbCard> {
  @override
  Widget build(BuildContext context) {
    final vs = v('vs'), gs = v('gs');
    final grad = vs == null || gs == null || gs <= 0
        ? null
        : gradientFtPerNm(vs, gs);
    return card(l10n.e6bClimbGradient, Icons.trending_up, [
      FieldGrid(
        children: [
          field('vs', l10n.e6bVerticalSpeed, suffix: 'ft/min'),
          field('gs', 'GS', quantity: Quantity.speed),
        ],
      ),
      ResultList([
        Result(
          l10n.e6bGradient,
          grad == null ? null : '${_round(grad)} ft/NM',
          highlight: true,
        ),
        Result('%', grad == null ? null : _one(gradientPercent(grad))),
        Result(
          '°',
          grad == null
              ? null
              : _one(math.atan(grad / feetPerNm) * 180 / math.pi),
        ),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------------------

class TurnCard extends E6bCalculator {
  const TurnCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<TurnCard> createState() => _TurnState();
}

class _TurnState extends _CardState<TurnCard> {
  @override
  Widget build(BuildContext context) {
    final tas = v('tas'), bankInput = v('bank');
    final stdBank = tas == null || tas <= 0 ? null : bankForTurnRate(tas);
    final bank = bankInput ?? stdBank;
    final valid =
        tas != null && tas > 0 && bank != null && bank > 0 && bank < 90;
    return card(l10n.e6bTurn, Icons.rotate_right, [
      FieldGrid(
        children: [
          field('tas', 'TAS', quantity: Quantity.speed),
          field('bank', l10n.e6bBankOptional, suffix: '°'),
        ],
      ),
      ResultList([
        Result(
          l10n.e6bStandardRateBank,
          stdBank == null ? null : '${_round(stdBank)}°',
          highlight: true,
        ),
        Result(
          l10n.e6bTurnRadius,
          valid ? '${(turnRadiusNm(tas, bank)).toStringAsFixed(2)} NM' : null,
        ),
        Result(
          l10n.e6bTurnTime,
          valid ? formatDuration(fullTurnTime(tas, bank)) : null,
        ),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------------------

class ColdTemperatureCard extends E6bCalculator {
  const ColdTemperatureCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<ColdTemperatureCard> createState() => _ColdTemperatureState();
}

class _ColdTemperatureState extends _CardState<ColdTemperatureCard> {
  @override
  Widget build(BuildContext context) {
    final alt = v('published'),
        elev = v('elevation'),
        temp = v('aerodromeTemp');
    final c = alt == null || elev == null || temp == null || alt <= elev
        ? null
        : coldTemperatureCorrection(
            heightAboveAerodromeFt: alt - elev,
            aerodromeElevationFt: elev,
            aerodromeTempC: temp,
          );
    return card(l10n.e6bColdTemperature, Icons.ac_unit, [
      FieldGrid(
        children: [
          field(
            'published',
            l10n.e6bPublishedAltitude,
            quantity: Quantity.altitude,
          ),
          field(
            'elevation',
            l10n.e6bAerodromeElevation,
            quantity: Quantity.altitude,
          ),
          field(
            'aerodromeTemp',
            l10n.e6bAerodromeTemp,
            quantity: Quantity.temperature,
            signed: true,
          ),
        ],
      ),
      ResultList([
        Result(l10n.e6bCorrection, c == null ? null : '+${_round(c)} ft'),
        Result(
          l10n.e6bCorrectedAltitude,
          c == null ? null : '${_round(alt! + c)} ft',
          highlight: true,
        ),
      ]),
    ]);
  }
}

// ---------------------------------------------------------------------------

class ConverterCard extends E6bCalculator {
  const ConverterCard({
    super.key,
    super.prefill,
    super.collapsible,
    super.initiallyExpanded,
  });

  @override
  State<ConverterCard> createState() => _ConverterState();
}

class _ConverterState extends _CardState<ConverterCard> {
  Quantity _quantity = Quantity.speed;
  String _unit = Quantity.speed.base;
  final _value = UnitInput();

  @override
  void dispose() {
    _value.dispose();
    super.dispose();
  }

  String _label(Quantity q) => switch (q) {
    Quantity.speed => l10n.quantitySpeed,
    Quantity.distance => l10n.quantityDistance,
    Quantity.altitude => l10n.quantityAltitude,
    Quantity.temperature => l10n.quantityTemperature,
    Quantity.pressure => l10n.quantityPressure,
    Quantity.volume => l10n.quantityVolume,
    Quantity.mass => l10n.quantityMass,
  };

  @override
  Widget build(BuildContext context) {
    final value = _value.value;
    return card(l10n.e6bConverter, Icons.swap_horiz, [
      FieldGrid(
        children: [
          DropdownButtonFormField<Quantity>(
            initialValue: _quantity,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.e6bQuantity,
              isDense: true,
            ),
            items: [
              for (final q in Quantity.values)
                DropdownMenuItem(value: q, child: Text(_label(q))),
            ],
            onChanged: (q) => setState(() {
              _quantity = q!;
              _unit = q.base;
            }),
          ),
          Row(
            children: [
              Expanded(
                child: NumberField(
                  input: _value,
                  label: l10n.e6bValue,
                  signed: _quantity == Quantity.temperature,
                  onChanged: changed,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _unit,
                items: [
                  for (final u in _quantity.units)
                    DropdownMenuItem(value: u.symbol, child: Text(u.symbol)),
                ],
                onChanged: (u) => setState(() => _unit = u!),
              ),
            ],
          ),
        ],
      ),
      ResultList([
        for (final u in _quantity.units)
          if (u.symbol != _unit)
            Result(
              u.symbol,
              value == null
                  ? null
                  : _format(convert(value, _quantity, _unit, u.symbol)),
            ),
      ]),
    ]);
  }

  static String _format(double v) {
    final a = v.abs();
    if (a >= 1000) return v.toStringAsFixed(0);
    if (a >= 100) return v.toStringAsFixed(1);
    if (a >= 1) return v.toStringAsFixed(2);
    return v.toStringAsPrecision(3);
  }
}
