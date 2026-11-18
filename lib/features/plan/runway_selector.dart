import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/navlog.dart';
import '../../core/runways.dart';
import '../../core/theme.dart';
import '../../core/units.dart';
import '../../data/db/database.dart';
import '../../data/repositories/flight_repository.dart';
import '../../data/repositories/navdata_repository.dart';
import '../../l10n/app_localizations.dart';

/// Expected departure and arrival runway of a flight, with wind components
/// from the flight's wind.
class RunwaysCard extends StatelessWidget {
  const RunwaysCard(this.data, {super.key, this.margin = EdgeInsets.zero});

  final FlightWithRoute data;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = data.flight;
    final repo = context.read<FlightRepository>();
    final theme = Theme.of(context);
    return Card(
      margin: margin,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.runwaysTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            RunwaySelector(
              label: l10n.flightDeparture,
              airportIdent: f.departureIdent,
              selected: f.departureRunway,
              windDirection: f.windDirection,
              windSpeedKt: f.windSpeedKt,
              maxCrosswindKt: data.aircraft?.maxCrosswindKt,
              onSelected: (r) => repo.updateFlight(
                f.id,
                FlightsCompanion(departureRunway: Value(r)),
              ),
            ),
            const Divider(height: 24),
            RunwaySelector(
              label: l10n.flightDestination,
              airportIdent: f.destinationIdent,
              selected: f.arrivalRunway,
              windDirection: f.windDirection,
              windSpeedKt: f.windSpeedKt,
              maxCrosswindKt: data.aircraft?.maxCrosswindKt,
              onSelected: (r) => repo.updateFlight(
                f.id,
                FlightsCompanion(arrivalRunway: Value(r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RunwaySelector extends StatefulWidget {
  const RunwaySelector({
    super.key,
    required this.label,
    required this.airportIdent,
    required this.selected,
    required this.onSelected,
    this.windDirection,
    this.windSpeedKt,
    this.maxCrosswindKt,
  });

  final String label;
  final String airportIdent;
  final String? selected;
  final ValueChanged<String?> onSelected;

  /// True direction the wind blows from.
  final int? windDirection;
  final int? windSpeedKt;
  final int? maxCrosswindKt;

  @override
  State<RunwaySelector> createState() => _RunwaySelectorState();
}

class _RunwaySelectorState extends State<RunwaySelector> {
  late Future<List<RunwayEnd>> _ends = _load();

  Future<List<RunwayEnd>> _load() =>
      context.read<NavdataRepository>().runwayEndsFor(widget.airportIdent);

  @override
  void didUpdateWidget(RunwaySelector old) {
    super.didUpdateWidget(old);
    if (old.airportIdent != widget.airportIdent) _ends = _load();
  }

  bool get _hasWind =>
      widget.windDirection != null && (widget.windSpeedKt ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return FutureBuilder<List<RunwayEnd>>(
      future: _ends,
      builder: (context, snapshot) {
        final ends = snapshot.data ?? const <RunwayEnd>[];
        final suggested = _hasWind
            ? suggestRunway(
                ends,
                windFrom: widget.windDirection!.toDouble(),
                windSpeed: widget.windSpeedKt!.toDouble(),
              )
            : null;
        final selected = ends
            .where((e) => e.ident == widget.selected)
            .firstOrNull;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.label} · ${widget.airportIdent}',
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            if (snapshot.connectionState == ConnectionState.done &&
                ends.isEmpty)
              Text(l10n.runwaysNone, style: theme.textTheme.bodySmall)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final e in ends)
                    ChoiceChip(
                      label: Text(e.ident, style: monoStyle(context)),
                      avatar: e == suggested && e.ident != widget.selected
                          ? const Icon(Icons.star_outline, size: 18)
                          : null,
                      tooltip: e == suggested ? l10n.runwaySuggested : null,
                      selected: e.ident == widget.selected,
                      onSelected: (on) =>
                          widget.onSelected(on ? e.ident : null),
                    ),
                ],
              ),
            if (selected != null) ...[
              const SizedBox(height: 8),
              _RunwayDetails(
                end: selected,
                windDirection: _hasWind ? widget.windDirection : null,
                windSpeedKt: widget.windSpeedKt,
                maxCrosswindKt: widget.maxCrosswindKt,
              ),
            ] else if (suggested != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.runwaySuggestion(suggested.ident),
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RunwayDetails extends StatelessWidget {
  const _RunwayDetails({
    required this.end,
    this.windDirection,
    this.windSpeedKt,
    this.maxCrosswindKt,
  });

  final RunwayEnd end;
  final int? windDirection;
  final int? windSpeedKt;
  final int? maxCrosswindKt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final facts = [
      'MH ${formatCourse(end.magneticHeading)}°',
      if (end.lengthFt != null)
        '${end.lengthFt} ft (${(end.lengthFt! / feetPerMeter).round()} m)',
      ?end.surface,
      if (end.lighted) l10n.runwayLighted,
    ].join(' · ');
    final heights = [
      if (end.elevationFt != null) l10n.runwayThreshold(end.elevationFt!),
      if (end.patternAltitudeFt != null)
        l10n.runwayPattern(end.patternAltitudeFt!),
    ].join(' · ');

    Widget? wind;
    if (windDirection != null && windSpeedKt != null) {
      final w = runwayWinds(
        [end],
        windFrom: windDirection!.toDouble(),
        windSpeed: windSpeedKt!.toDouble(),
      ).single;
      final head = w.headwind.round();
      final cross = w.crosswind.round();
      final tooMuchCross =
          maxCrosswindKt != null && cross.abs() > maxCrosswindKt!;
      final tailwind = head < 0;
      final warning = [
        if (tailwind) l10n.runwayTailwindWarning,
        if (tooMuchCross) l10n.runwayCrosswindWarning(maxCrosswindKt!),
      ];
      wind = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [
              head >= 0
                  ? '${l10n.e6bHeadwind} $head kt'
                  : '${l10n.e6bTailwind} ${-head} kt',
              cross == 0
                  ? '${l10n.e6bCrosswind} 0 kt'
                  : '${l10n.e6bCrosswind} ${cross.abs()} kt '
                        '${cross > 0 ? l10n.e6bFromRight : l10n.e6bFromLeft}',
            ].join(' · '),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: warning.isEmpty ? null : theme.colorScheme.error,
            ),
          ),
          for (final w in warning)
            Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    w,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(facts, style: theme.textTheme.bodyMedium),
        if (heights.isNotEmpty)
          Text(heights, style: theme.textTheme.bodyMedium),
        ?wind,
      ],
    );
  }
}
