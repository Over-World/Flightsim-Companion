import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/morse.dart';
import '../../core/navlog.dart';
import '../../core/settings.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/ticking.dart';
import '../kneeboard/kneeboard_controller.dart';
import '../plan/navlog_table.dart';
import '../plan/runway_selector.dart';
import '../weather/weather_card.dart';

class FlyScreen extends StatelessWidget {
  const FlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kb = context.watch<KneeboardController>();
    final flight = kb.flight;
    if (!kb.isOpen || flight == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navFly)),
        body: EmptyState(
          icon: Icons.flight_takeoff_outlined,
          title: l10n.flyNoActiveFlightTitle,
          message: l10n.flyNoActiveFlightMessage,
          action: OutlinedButton(
            onPressed: () => context.go('/plan'),
            child: Text(l10n.navPlan),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(flight.title),
        actions: [
          IconButton(
            tooltip: l10n.kneeboardEditPlan,
            icon: const Icon(Icons.edit_note),
            onPressed: () => context.go('/plan/flights/${flight.id}'),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => switch (v) {
              'reset' => _confirmReset(context, kb),
              _ => kb.close(),
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'reset', child: Text(l10n.kneeboardReset)),
              PopupMenuItem(value: 'close', child: Text(l10n.kneeboardClose)),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final landscape =
              constraints.maxWidth >= 960 &&
              constraints.maxWidth > constraints.maxHeight;
          const leg = _CurrentLegCard();
          const times = _TimesCard();
          const navlog = _NavlogCard();
          const frequencies = _FrequenciesCard();
          final runways = RunwaysCard(
            kb.data!,
            margin: const EdgeInsets.only(bottom: 12),
          );
          // Departure weather until airborne, destination always.
          final weather = [
            if (flight.takeoffAt == null)
              WeatherCard(
                airportIdent: flight.departureIdent,
                title: '${l10n.flightDeparture} · ${flight.departureIdent}',
                margin: const EdgeInsets.only(bottom: 12),
              ),
            WeatherCard(
              airportIdent: flight.destinationIdent,
              title: '${l10n.flightDestination} · ${flight.destinationIdent}',
              margin: const EdgeInsets.only(bottom: 12),
            ),
          ];
          if (landscape) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                    children: [navlog, runways, ...weather, frequencies],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
                    children: const [leg, times],
                  ),
                ),
              ],
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
            children: [leg, navlog, runways, ...weather, frequencies, times],
          );
        },
      ),
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    KneeboardController kb,
  ) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.kneeboardReset),
        content: Text(l10n.kneeboardResetMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.kneeboardReset),
          ),
        ],
      ),
    );
    if (ok == true) await kb.resetTimes();
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value(this.label, this.value, {this.large = false, this.color});

  final String label;
  final String value;
  final bool large;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        Text(
          value,
          style: monoStyle(
            context,
            base: large
                ? theme.textTheme.displaySmall
                : theme.textTheme.headlineSmall,
          ).copyWith(color: color),
        ),
      ],
    );
  }
}

class _CurrentLegCard extends StatelessWidget {
  const _CurrentLegCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kb = context.watch<KneeboardController>();
    final theme = Theme.of(context);
    final phase = kb.phase;
    final legIndex = kb.currentLeg;
    final leg = kb.currentNavlogLeg;
    final hm = DateFormat.Hm();

    final (String label, Future<void> Function()? action) = switch (phase) {
      FlightPhase.preflight => (l10n.actionBlockOff, kb.blockOff),
      FlightPhase.taxiOut => (l10n.actionTakeoff, kb.takeoff),
      FlightPhase.enroute => (
        l10n.actionPassed(kb.waypoints[legIndex! + 1].ident),
        kb.passWaypoint,
      ),
      FlightPhase.arrived => (l10n.actionLanding, kb.landing),
      FlightPhase.landed => (l10n.actionBlockOn, kb.blockOn),
      FlightPhase.parked => (l10n.actionCompleted, null),
    };

    final Widget body;
    if (leg != null && legIndex != null) {
      final to = kb.waypoints[legIndex + 1];
      final etas = kb.etas;
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.legProgress(legIndex + 1, kb.navlog!.legs.length),
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '→ ${to.ident}',
                  style: monoStyle(
                    context,
                    base: theme.textTheme.headlineMedium,
                  ),
                ),
                if (to.name.isNotEmpty && to.name != to.ident)
                  TextSpan(
                    text: '  ${to.name}',
                    style: theme.textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 32,
            runSpacing: 12,
            children: [
              _Value(
                'MH',
                leg.magneticHeading == null
                    ? '!'
                    : '${formatCourse(leg.magneticHeading!)}°',
                large: true,
              ),
              _Value('ALT', to.altitudeFt?.toString() ?? '–', large: true),
              _Value('NM', leg.distanceNm.toStringAsFixed(1)),
              _Value('GS', leg.groundSpeed?.round().toString() ?? '!'),
              _Value(
                'ETA',
                etas[legIndex] == null ? '–' : hm.format(etas[legIndex]!),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Ticking(
            builder: (context, now) {
              final started = kb.legStartedAt;
              final elapsed = started == null
                  ? Duration.zero
                  : now.difference(started);
              final remaining = leg.ete == null ? null : leg.ete! - elapsed;
              final overdue = remaining != null && remaining.isNegative;
              return Wrap(
                spacing: 32,
                runSpacing: 12,
                children: [
                  _Value(l10n.legElapsed, formatClock(elapsed)),
                  if (remaining != null)
                    _Value(
                      overdue ? l10n.legOverdue : l10n.legRemaining,
                      formatClock(overdue ? -remaining : remaining),
                      color: overdue ? theme.colorScheme.error : null,
                    ),
                ],
              );
            },
          ),
          if (to.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(to.notes, style: theme.textTheme.bodyMedium),
          ],
        ],
      );
    } else {
      body = Text(switch (phase) {
        FlightPhase.preflight => l10n.phasePreflight,
        FlightPhase.taxiOut => l10n.phaseTaxiOut,
        FlightPhase.arrived => l10n.phaseArrived,
        FlightPhase.landed => l10n.phaseLanded,
        _ => l10n.phaseParked,
      }, style: theme.textTheme.bodyLarge);
    }

    return _Section(
      title: l10n.kneeboardCurrentLeg,
      trailing: phase == FlightPhase.preflight
          ? null
          : IconButton(
              tooltip: l10n.actionUndo,
              icon: const Icon(Icons.undo),
              onPressed: kb.undo,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          body,
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: action,
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: action == null ? null : theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavlogCard extends StatelessWidget {
  const _NavlogCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kb = context.watch<KneeboardController>();
    final navlog = kb.navlog;
    return _Section(
      title: l10n.flightTabNavlog,
      child: navlog == null
          ? Text(l10n.navlogNeedsAircraft)
          : NavlogTable(
              navlog: navlog,
              fuelUnit: context.watch<SettingsController>().fuelUnit,
              columns: flyingColumns,
              currentLeg: kb.currentLeg,
              etas: kb.etas,
            ),
    );
  }
}

class _FrequenciesCard extends StatelessWidget {
  const _FrequenciesCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final groups = context.watch<KneeboardController>().frequencies;
    final theme = Theme.of(context);
    String role(String r) => switch (r) {
      'dep' => l10n.flightDeparture,
      'dest' => l10n.flightDestination,
      'altn' => l10n.flightAlternate,
      _ => 'NAV',
    };
    return _Section(
      title: l10n.frequencies,
      child: groups.isEmpty
          ? Text(l10n.noFrequencies)
          : Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                for (final g in groups)
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${g.ident} · ${role(g.role)}',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        for (final e in g.entries)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 64,
                                  child: Text(
                                    e.label,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                                Text(e.frequency, style: monoStyle(context)),
                                if (e.morse != null) ...[
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      toMorse(e.morse!),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _TimesCard extends StatelessWidget {
  const _TimesCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final kb = context.watch<KneeboardController>();
    final f = kb.flight!;
    final hm = DateFormat.Hm();
    String t(DateTime? d) => d == null ? '--:--' : hm.format(d);

    return _Section(
      title: l10n.kneeboardTimes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _Value(l10n.timeBlockOff, t(f.blockOffAt)),
              _Value(l10n.timeTakeoff, t(f.takeoffAt)),
              _Value(l10n.timeLanding, t(f.landingAt)),
              _Value(l10n.timeBlockOn, t(f.blockOnAt)),
            ],
          ),
          const SizedBox(height: 12),
          Ticking(
            builder: (context, now) {
              Duration? span(DateTime? a, DateTime? b) =>
                  a == null ? null : (b ?? now).difference(a);
              final air = span(f.takeoffAt, f.landingAt);
              final block = span(f.blockOffAt, f.blockOnAt);
              return Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  _Value(l10n.timeFlight, air == null ? '–' : formatClock(air)),
                  _Value(
                    l10n.timeBlock,
                    block == null ? '–' : formatClock(block),
                  ),
                ],
              );
            },
          ),
          const Divider(height: 32),
          Row(
            children: [
              Expanded(
                child: Ticking(
                  interval: const Duration(milliseconds: 200),
                  builder: (context, now) => _Value(
                    l10n.stopwatch,
                    formatClock(kb.stopwatchElapsed(now)),
                    large: true,
                  ),
                ),
              ),
              IconButton.filledTonal(
                tooltip: l10n.stopwatchReset,
                onPressed: kb.resetStopwatch,
                icon: const Icon(Icons.replay),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                iconSize: 32,
                tooltip: kb.stopwatchRunning
                    ? l10n.stopwatchStop
                    : l10n.stopwatchStart,
                onPressed: kb.toggleStopwatch,
                icon: Icon(
                  kb.stopwatchRunning ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
