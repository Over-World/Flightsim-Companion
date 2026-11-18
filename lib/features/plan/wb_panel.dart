import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../core/theme.dart';
import '../../core/units.dart';
import '../../core/weight_balance.dart';
import '../../data/db/database.dart';
import '../../data/repositories/flight_repository.dart';
import '../../l10n/app_localizations.dart';

/// Loads per station, takeoff/landing weight and CG, envelope chart.
class WbPanel extends StatelessWidget {
  const WbPanel(this.data, {super.key});

  final FlightWithRoute data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final a = data.aircraft;
    final result = data.weightBalance;
    if (a == null || result == null || data.stations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.wbMissingData, textAlign: TextAlign.center),
              if (a != null) ...[
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () => context.go('/plan/aircraft/${a.id}'),
                  child: Text(l10n.aircraftEdit),
                ),
              ],
            ],
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final loads = _Loads(data, key: ValueKey(data.aircraft?.id));
        final results = _Results(data, result);
        final chart = _EnvelopeCard(data, result);
        if (constraints.maxWidth >= 760) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(children: [loads, results])),
                const SizedBox(width: 12),
                Expanded(child: chart),
              ],
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [loads, results, chart],
        );
      },
    );
  }
}

class _Loads extends StatefulWidget {
  const _Loads(this.data, {super.key});

  final FlightWithRoute data;

  @override
  State<_Loads> createState() => _LoadsState();
}

class _LoadsState extends State<_Loads> {
  late final WeightUnit _unit = context.read<SettingsController>().weightUnit;
  late final Map<int, TextEditingController> _controllers = {
    for (var i = 0; i < widget.data.stations.length; i++)
      if (widget.data.stations[i].kind != StationKind.fuel)
        i: TextEditingController(
          text: switch (widget.data.loadsKg[i]) {
            final kg? when kg > 0 => _unit.fromKg(kg).round().toString(),
            _ => '',
          },
        ),
  };

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() {
    final loads = <String, double>{
      for (final MapEntry(key: i, value: c) in _controllers.entries)
        if (double.tryParse(c.text.replaceAll(',', '.')) case final v?
            when v > 0)
          '$i': _unit.toKg(v),
    };
    return context.read<FlightRepository>().updateFlight(
      widget.data.flight.id,
      FlightsCompanion(loads: Value(jsonEncode(loads))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final stations = widget.data.stations;
    final plan = widget.data.fuelPlan;
    final fuelKg = plan == null
        ? 0.0
        : plan.atTakeoff * widget.data.fuelKind.density;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.wbLoading,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < stations.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: stations[i].kind == StationKind.fuel
                    ? InputDecorator(
                        decoration: InputDecoration(
                          labelText: stations[i].name,
                          helperText: l10n.wbFuelFromPlan,
                          isDense: true,
                          suffixText: _unit.symbol,
                        ),
                        child: Text(
                          _unit.fromKg(fuelKg).round().toString(),
                          style: monoStyle(context),
                        ),
                      )
                    : Focus(
                        onFocusChange: (f) => f ? null : _save(),
                        child: TextField(
                          controller: _controllers[i],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          style: monoStyle(context),
                          decoration: InputDecoration(
                            labelText: stations[i].name,
                            isDense: true,
                            suffixText: _unit.symbol,
                            helperText: stations[i].maxKg == null
                                ? null
                                : l10n.wbMax(
                                    _unit.fromKg(stations[i].maxKg!).round(),
                                    _unit.symbol,
                                  ),
                          ),
                          onSubmitted: (_) => _save(),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results(this.data, this.result);

  final FlightWithRoute data;
  final WbResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unit = context.watch<SettingsController>().weightUnit;
    final a = data.aircraft!;
    final arm = a.armUnit;
    String w(double kg) => '${unit.fromKg(kg).round()} ${unit.symbol}';
    String cg(WbPoint p) => '${p.cg.toStringAsFixed(arm == 'mm' ? 0 : 2)} $arm';

    Widget line(String label, WbPoint p, bool? inside) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(w(p.weightKg), style: monoStyle(context)),
          const SizedBox(width: 16),
          SizedBox(
            width: 104,
            child: Text(
              cg(p),
              textAlign: TextAlign.end,
              style: monoStyle(context).copyWith(
                color: inside == false ? theme.colorScheme.error : null,
              ),
            ),
          ),
        ],
      ),
    );

    final warnings = [
      if (result.overMaxTakeoff) l10n.wbOverMtow(w(a.maxTakeoffWeightKg!)),
      if (result.takeoffInEnvelope == false) l10n.wbTakeoffOutside,
      if (result.landingInEnvelope == false) l10n.wbLandingOutside,
      for (final i in result.overloadedStations)
        l10n.wbStationOverloaded(data.stations[i].name),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.wbResult,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Icon(
                  result.ok ? Icons.check_circle : Icons.error,
                  color: result.ok
                      ? const Color(0xFF2E7D32)
                      : theme.colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 8),
            line(l10n.wbZeroFuel, result.zeroFuel, null),
            line(l10n.wbTakeoff, result.takeoff, result.takeoffInEnvelope),
            line(l10n.wbLanding, result.landing, result.landingInEnvelope),
            if (a.maxTakeoffWeightKg != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.wbMtow(w(a.maxTakeoffWeightKg!)),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            for (final warning in warnings)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warning,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EnvelopeCard extends StatelessWidget {
  const _EnvelopeCard(this.data, this.result);

  final FlightWithRoute data;
  final WbResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final envelope = EnvelopePoint.decodeAll(data.aircraft!.envelope);
    final unit = context.watch<SettingsController>().weightUnit;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.wbEnvelope,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            if (envelope.length < 3)
              Text(l10n.wbNoEnvelope)
            else
              AspectRatio(
                aspectRatio: 1.1,
                child: CustomPaint(
                  painter: EnvelopePainter(
                    envelope: envelope,
                    takeoff: result.takeoff,
                    landing: result.landing,
                    weightUnit: unit,
                    armUnit: data.aircraft!.armUnit,
                    colors: theme.colorScheme,
                    labelStyle: theme.textTheme.labelSmall!,
                    takeoffLabel: l10n.wbTakeoff,
                    landingLabel: l10n.wbLanding,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// CG envelope with takeoff and landing points.
class EnvelopePainter extends CustomPainter {
  EnvelopePainter({
    required this.envelope,
    required this.takeoff,
    required this.landing,
    required this.weightUnit,
    required this.armUnit,
    required this.colors,
    required this.labelStyle,
    required this.takeoffLabel,
    required this.landingLabel,
  });

  final List<EnvelopePoint> envelope;
  final WbPoint takeoff;
  final WbPoint landing;
  final WeightUnit weightUnit;
  final String armUnit;
  final ColorScheme colors;
  final TextStyle labelStyle;
  final String takeoffLabel;
  final String landingLabel;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 48.0, bottom = 28.0, top = 8.0, right = 8.0;
    final arms = [...envelope.map((p) => p.arm), takeoff.cg, landing.cg];
    final weights = [
      ...envelope.map((p) => p.weightKg),
      takeoff.weightKg,
      landing.weightKg,
    ];
    var minArm = arms.reduce(math.min), maxArm = arms.reduce(math.max);
    var minW = weights.reduce(math.min), maxW = weights.reduce(math.max);
    final padArm = (maxArm - minArm) * 0.08 + 0.01;
    final padW = (maxW - minW) * 0.08 + 1;
    minArm -= padArm;
    maxArm += padArm;
    minW -= padW;
    maxW += padW;

    final plot = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    Offset at(double arm, double kg) => Offset(
      plot.left + (arm - minArm) / (maxArm - minArm) * plot.width,
      plot.bottom - (kg - minW) / (maxW - minW) * plot.height,
    );

    // Axes and labels.
    final axis = Paint()
      ..color = colors.outlineVariant
      ..strokeWidth = 1;
    canvas.drawLine(plot.bottomLeft, plot.bottomRight, axis);
    canvas.drawLine(plot.bottomLeft, plot.topLeft, axis);
    final style = labelStyle.copyWith(color: colors.onSurfaceVariant);
    for (var i = 0; i <= 4; i++) {
      final arm = minArm + (maxArm - minArm) * i / 4;
      final kg = minW + (maxW - minW) * i / 4;
      _text(
        canvas,
        arm.toStringAsFixed(armUnit == 'mm' ? 0 : 1),
        at(arm, minW) + const Offset(0, 6),
        style,
        center: true,
      );
      _text(
        canvas,
        weightUnit.fromKg(kg).round().toString(),
        Offset(0, at(minArm, kg).dy - 7),
        style,
      );
    }
    _text(
      canvas,
      '${weightUnit.symbol} / $armUnit',
      Offset(plot.left + 4, plot.top),
      style,
    );

    // Envelope.
    final first = at(envelope.first.arm, envelope.first.weightKg);
    final path = Path()..moveTo(first.dx, first.dy);
    for (final p in envelope.skip(1)) {
      final o = at(p.arm, p.weightKg);
      path.lineTo(o.dx, o.dy);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()..color = colors.primary.withValues(alpha: 0.12),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = colors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Takeoff → landing.
    final t = at(takeoff.cg, takeoff.weightKg);
    final l = at(landing.cg, landing.weightKg);
    canvas.drawLine(
      t,
      l,
      Paint()
        ..color = colors.onSurface
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(t, 6, Paint()..color = colors.tertiary);
    canvas.drawCircle(l, 5, Paint()..color = colors.secondary);
    _text(canvas, takeoffLabel, t + const Offset(8, -16), style);
    _text(canvas, landingLabel, l + const Offset(8, 2), style);
  }

  void _text(
    Canvas canvas,
    String text,
    Offset at,
    TextStyle style, {
    bool center = false,
  }) {
    final p = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    p.paint(canvas, center ? at - Offset(p.width / 2, 0) : at);
  }

  @override
  bool shouldRepaint(EnvelopePainter old) =>
      old.takeoff.moment != takeoff.moment ||
      old.takeoff.weightKg != takeoff.weightKg ||
      old.landing.weightKg != landing.weightKg ||
      old.envelope != envelope ||
      old.colors != colors ||
      old.weightUnit != weightUnit;
}
