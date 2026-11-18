import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/fuel_plan.dart';
import '../../core/navlog.dart';
import '../../core/settings.dart';
import '../../core/theme.dart';
import '../../core/units.dart';
import '../../data/db/database.dart';
import '../../data/repositories/flight_repository.dart';
import '../../l10n/app_localizations.dart';

/// Fuel plan of a flight: inputs, breakdown, capacity bar and checks.
class FuelPanel extends StatelessWidget {
  const FuelPanel(this.data, {super.key});

  final FlightWithRoute data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final plan = data.fuelPlan;
    if (plan == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(l10n.navlogNeedsAircraft, textAlign: TextAlign.center),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _FuelInputs(data),
        const SizedBox(height: 12),
        _FuelBreakdown(data, plan),
      ],
    );
  }
}

class _FuelInputs extends StatefulWidget {
  const _FuelInputs(this.data);

  final FlightWithRoute data;

  @override
  State<_FuelInputs> createState() => _FuelInputsState();
}

class _FuelInputsState extends State<_FuelInputs> {
  late final FuelUnit _unit = context.read<SettingsController>().fuelUnit;
  late final _onBoard = _volume(widget.data.flight.fuelOnBoardL);
  late final _taxi = _volume(widget.data.flight.taxiFuelL);
  late final _extra = _volume(widget.data.flight.extraFuelL);
  late final _contingency = TextEditingController(
    text: _plain(widget.data.flight.contingencyPercent),
  );
  late final _reserve = TextEditingController(
    text: widget.data.flight.finalReserveMinutes?.toString() ?? '',
  );

  TextEditingController _volume(double? liters) => TextEditingController(
    text: liters == null ? '' : _plain(_unit.fromLiters(liters)),
  );

  static String _plain(double? v) => v == null
      ? ''
      : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1));

  @override
  void dispose() {
    for (final c in [_onBoard, _taxi, _extra, _contingency, _reserve]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _num(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  Future<void> _save() {
    double? liters(TextEditingController c) {
      final v = _num(c);
      return v == null ? null : _unit.toLiters(v);
    }

    return context.read<FlightRepository>().updateFlight(
      widget.data.flight.id,
      FlightsCompanion(
        fuelOnBoardL: Value(liters(_onBoard)),
        taxiFuelL: Value(liters(_taxi)),
        extraFuelL: Value(liters(_extra)),
        contingencyPercent: Value(_num(_contingency)),
        finalReserveMinutes: Value(_num(_reserve)?.round()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = widget.data.flight;
    final a = widget.data.aircraft!;
    final ifr = f.rules == FlightRules.ifr;
    final plan = widget.data.fuelPlan!;
    final unit = _unit.symbol;

    Widget field(
      TextEditingController c,
      String label,
      String suffix, {
      String? hint,
    }) => Focus(
      onFocusChange: (focused) => focused ? null : _save(),
      child: TextField(
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ],
        style: monoStyle(context),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffix,
          isDense: true,
        ),
        onSubmitted: (_) => _save(),
      ),
    );

    final fields = [
      field(
        _onBoard,
        l10n.fuelOnBoard,
        unit,
        hint: plan.valid ? _plain(_unit.fromLiters(plan.required)) : null,
      ),
      field(
        _taxi,
        l10n.fuelTaxi,
        unit,
        hint: _plain(_unit.fromLiters(a.taxiFuelL ?? 0)),
      ),
      field(
        _contingency,
        l10n.fuelContingency,
        '%',
        hint: _plain(FuelPlan.defaultContingencyPercent(ifr: ifr)),
      ),
      field(
        _reserve,
        l10n.fuelFinalReserve,
        'min',
        hint:
            '${FuelPlan.defaultFinalReserveMinutes(ifr: ifr, night: f.night)}',
      ),
      field(_extra, l10n.fuelExtra, unit, hint: '0'),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 560
                    ? 3
                    : (constraints.maxWidth >= 300 ? 2 : 1);
                final width =
                    (constraints.maxWidth - 12 * (columns - 1)) / columns;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final f in fields) SizedBox(width: width, child: f),
                  ],
                );
              },
            ),
            if (!ifr)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.fuelNightVfr),
                subtitle: Text(l10n.fuelNightVfrHint),
                value: f.night,
                onChanged: (v) => context.read<FlightRepository>().updateFlight(
                  f.id,
                  FlightsCompanion(night: Value(v)),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              l10n.fuelDefaultsHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _FuelBreakdown extends StatelessWidget {
  const _FuelBreakdown(this.data, this.plan);

  final FlightWithRoute data;
  final FuelPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final unit = context.watch<SettingsController>().fuelUnit;
    final f = data.flight;
    final ifr = f.rules == FlightRules.ifr;
    String v(double liters) => liters.isFinite
        ? '${unit.fromLiters(liters).toStringAsFixed(1)} ${unit.symbol}'
        : '!';
    final percent =
        f.contingencyPercent ?? FuelPlan.defaultContingencyPercent(ifr: ifr);
    final reserve =
        f.finalReserveMinutes ??
        FuelPlan.defaultFinalReserveMinutes(ifr: ifr, night: f.night);

    final rows = <(String, String, bool)>[
      (l10n.fuelTaxi, v(plan.taxi), false),
      (l10n.fuelTrip, v(plan.trip), false),
      (l10n.fuelContingencyRow(_n(percent)), v(plan.contingency), false),
      if (ifr)
        (
          f.alternateIdent == null
              ? l10n.fuelAlternateNone
              : l10n.fuelAlternateRow(f.alternateIdent!),
          v(plan.alternate),
          false,
        ),
      (l10n.fuelFinalReserveRow(reserve), v(plan.finalReserve), false),
      if (plan.extra > 0) (l10n.fuelExtra, v(plan.extra), false),
      (l10n.fuelRequired, v(plan.required), true),
    ];

    final warnings = [
      if (!plan.valid) l10n.navlogUnsolvable,
      if (plan.belowRequired) l10n.fuelBelowRequired,
      if (plan.requiredExceedsUsable) l10n.fuelRequiredExceedsUsable,
      if (plan.exceedsUsable && !plan.requiredExceedsUsable)
        l10n.fuelOnBoardExceedsUsable,
    ];

    Widget row(String label, String value, {bool bold = false, Color? color}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: bold
                      ? theme.textTheme.titleSmall
                      : theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                value,
                style: monoStyle(
                  context,
                  base: bold
                      ? theme.textTheme.titleMedium
                      : theme.textTheme.bodyLarge,
                ).copyWith(color: color),
              ),
            ],
          ),
        );

    final marginColor = plan.margin < -0.05 ? theme.colorScheme.error : null;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.fuelPlanTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            for (final (label, value, bold) in rows)
              row(label, value, bold: bold),
            const Divider(),
            row(l10n.fuelOnBoard, v(plan.plannedOnBoard), bold: true),
            row(
              l10n.fuelMargin,
              plan.valid
                  ? '${plan.margin >= 0 ? '+' : ''}${v(plan.margin)}'
                  : '!',
              color: marginColor,
            ),
            row(l10n.fuelAtLanding, v(plan.atLanding)),
            row(l10n.fuelEndurance, formatDuration(plan.endurance)),
            row(l10n.aircraftUsableFuel, v(plan.usable)),
            const SizedBox(height: 12),
            _CapacityBar(plan),
            for (final w in warnings)
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
                        w,
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

  static String _n(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
}

/// Stacked bar of the plan's components against the usable capacity.
class _CapacityBar extends StatelessWidget {
  const _CapacityBar(this.plan);

  final FuelPlan plan;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (!plan.valid || plan.usable <= 0) return const SizedBox.shrink();
    final segments = [
      (plan.taxi, scheme.outline),
      (plan.trip, scheme.primary),
      (plan.contingency + plan.alternate, scheme.tertiary),
      (plan.finalReserve, scheme.error),
      (plan.extra + plan.margin.clamp(0, double.infinity), scheme.secondary),
    ];
    final total = [
      plan.usable,
      plan.plannedOnBoard,
      plan.required,
    ].reduce((a, b) => a > b ? a : b);
    int flex(double v) => (v / total * 1000).round().clamp(0, 1000);
    final used = segments.fold<int>(0, (s, e) => s + flex(e.$1));
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 14,
        child: Row(
          children: [
            for (final (v, color) in segments)
              if (flex(v) > 0)
                Expanded(
                  flex: flex(v),
                  child: ColoredBox(color: color),
                ),
            if (1000 - used > 0)
              Expanded(
                flex: 1000 - used,
                child: ColoredBox(color: scheme.surfaceContainerHighest),
              ),
          ],
        ),
      ),
    );
  }
}
