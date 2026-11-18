import 'package:drift/drift.dart' show Value;
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/navlog.dart';
import '../../core/settings.dart';
import '../../core/theme.dart';
import '../../core/units.dart';
import '../../data/db/database.dart';
import '../../data/repositories/flight_repository.dart';
import '../../l10n/app_localizations.dart';
import '../kneeboard/kneeboard_controller.dart';
import 'add_waypoint_dialog.dart';
import 'edit_dialogs.dart';
import '../weather/weather_card.dart';
import 'navlog_table.dart';
import 'runway_selector.dart';

class FlightEditorScreen extends StatefulWidget {
  const FlightEditorScreen({super.key, required this.flightId});

  final int flightId;

  @override
  State<FlightEditorScreen> createState() => _FlightEditorScreenState();
}

class _FlightEditorScreenState extends State<FlightEditorScreen> {
  late final Stream<FlightWithRoute?> _flight = context
      .read<FlightRepository>()
      .watchFlight(widget.flightId);

  Future<void> _delete(Flight flight) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.flightDeleteTitle),
        content: Text(l10n.flightDeleteMessage(flight.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final kneeboard = context.read<KneeboardController>();
    if (kneeboard.flightId == flight.id) await kneeboard.close();
    if (!mounted) return;
    await context.read<FlightRepository>().deleteFlight(flight.id);
    if (mounted) context.go('/plan');
  }

  Future<void> _start(Flight flight) async {
    await context.read<KneeboardController>().open(flight.id);
    if (mounted) context.go('/fly');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return StreamBuilder<FlightWithRoute?>(
      stream: _flight,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(),
          );
        }
        final flight = data.flight;
        return Scaffold(
          appBar: AppBar(
            title: Text(flight.title),
            actions: [
              IconButton(
                tooltip: l10n.flightEdit,
                icon: const Icon(Icons.tune),
                onPressed: () => showEditFlightDialog(context, flight),
              ),
              IconButton(
                tooltip: l10n.delete,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _delete(flight),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: data.waypoints.length < 2
                    ? null
                    : () => _start(flight),
                icon: const Icon(Icons.flight_takeoff),
                label: Text(l10n.flightFly),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final route = _RoutePanel(data);
              final navlog = _NavlogPanel(data);
              final weather = _WeatherPanel(data);
              if (constraints.maxWidth >= 1000) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 380, child: route),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: _Tabs(
                        labels: [l10n.flightTabNavlog, l10n.flightTabWeather],
                        children: [navlog, weather],
                      ),
                    ),
                  ],
                );
              }
              return _Tabs(
                labels: [
                  l10n.flightTabRoute,
                  l10n.flightTabNavlog,
                  l10n.flightTabWeather,
                ],
                children: [route, navlog, weather],
              );
            },
          ),
        );
      },
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.labels, required this.children});

  final List<String> labels;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: children.length,
    child: Column(
      children: [
        TabBar(tabs: [for (final l in labels) Tab(text: l)]),
        Expanded(child: TabBarView(children: children)),
      ],
    ),
  );
}

/// Departure, destination and alternate weather; departure METAR wind can
/// become the flight's planning wind.
class _WeatherPanel extends StatelessWidget {
  const _WeatherPanel(this.data);

  final FlightWithRoute data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = data.flight;
    final repo = context.read<FlightRepository>();
    void useWind(int dir, int speed) => repo.updateFlight(
      f.id,
      FlightsCompanion(windDirection: Value(dir), windSpeedKt: Value(speed)),
    );
    final airports = [
      (f.departureIdent, l10n.flightDeparture),
      if (f.destinationIdent != f.departureIdent)
        (f.destinationIdent, l10n.flightDestination),
      if (f.alternateIdent case final altn?) (altn, l10n.flightAlternate),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final (ident, role) in airports)
          WeatherCard(
            airportIdent: ident,
            title: '$role · $ident',
            onUseWind: useWind,
            margin: const EdgeInsets.only(bottom: 12),
          ),
        Text(
          l10n.weatherUseWindHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _RoutePanel extends StatelessWidget {
  const _RoutePanel(this.data);

  final FlightWithRoute data;

  Future<void> _add(BuildContext context) async {
    final repo = context.read<FlightRepository>();
    final waypoint = await showAddWaypointDialog(context);
    if (waypoint != null) {
      await repo.insertWaypoint(data.flight.id, waypoint);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = context.read<FlightRepository>();
    final waypoints = data.waypoints;
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            padding: const EdgeInsets.symmetric(vertical: 8),
            header: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FlightSummary(data),
                RunwaysCard(
                  data,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                ),
              ],
            ),
            itemCount: waypoints.length,
            onReorderItem: (from, to) =>
                repo.moveWaypoint(data.flight.id, from, to),
            itemBuilder: (context, i) {
              final w = waypoints[i];
              return ListTile(
                key: ValueKey(w.id),
                leading: ReorderableDragStartListener(
                  index: i,
                  child: Icon(_kindIcon(w.kind)),
                ),
                title: Text(w.ident, style: monoStyle(context)),
                subtitle: w.name.isEmpty
                    ? null
                    : Text(
                        w.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (i > 0 && w.altitudeFt != null)
                      Text('${w.altitudeFt} ft', style: monoStyle(context)),
                    PopupMenuButton<String>(
                      onSelected: (action) => switch (action) {
                        'edit' => showEditWaypointDialog(context, w),
                        _ => repo.deleteWaypoint(data.flight.id, w.id),
                      },
                      itemBuilder: (context) => [
                        if (i > 0)
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(l10n.legEdit),
                          ),
                        if (waypoints.length > 2)
                          PopupMenuItem(
                            value: 'delete',
                            child: Text(l10n.delete),
                          ),
                      ],
                    ),
                  ],
                ),
                onTap: i > 0 ? () => showEditWaypointDialog(context, w) : null,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _add(context),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: Text(l10n.waypointAdd),
            ),
          ),
        ),
      ],
    );
  }

  static IconData _kindIcon(WaypointKind kind) => switch (kind) {
    WaypointKind.airport => Icons.local_airport,
    WaypointKind.navaid => Icons.settings_input_antenna,
    WaypointKind.reportingPoint => Icons.flag_outlined,
    WaypointKind.user => Icons.place_outlined,
  };
}

class _FlightSummary extends StatelessWidget {
  const _FlightSummary(this.data);

  final FlightWithRoute data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final f = data.flight;
    final theme = Theme.of(context);
    final wind = f.windSpeedKt == null || f.windSpeedKt == 0
        ? l10n.navlogCalm
        : '${formatCourse(f.windDirection!.toDouble())}° / ${f.windSpeedKt} kt';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => showEditFlightDialog(context, f),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.aircraft?.name ?? l10n.flightNoAircraft,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: data.aircraft == null
                        ? theme.colorScheme.error
                        : null,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    if (f.cruiseAltitudeFt != null)
                      _Info(Icons.height, '${f.cruiseAltitudeFt} ft'),
                    _Info(Icons.air, wind),
                    if (f.alternateIdent != null)
                      _Info(Icons.alt_route, f.alternateIdent!),
                    if (f.plannedDeparture != null)
                      _Info(
                        Icons.schedule,
                        MaterialLocalizations.of(context).formatTimeOfDay(
                          TimeOfDay.fromDateTime(f.plannedDeparture!),
                          alwaysUse24HourFormat: true,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: Theme.of(context).colorScheme.outline),
      const SizedBox(width: 4),
      Text(text),
    ],
  );
}

class _NavlogPanel extends StatelessWidget {
  const _NavlogPanel(this.data);

  final FlightWithRoute data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fuelUnit = context.watch<SettingsController>().fuelUnit;
    final navlog = data.navlog;
    final theme = Theme.of(context);
    if (navlog == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.navlogNeedsAircraft, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => showEditFlightDialog(context, data.flight),
                child: Text(l10n.flightChooseAircraft),
              ),
            ],
          ),
        ),
      );
    }
    final unsolvable = navlog.legs.any((l) => !l.solvable);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Stat(
              l10n.navlogDistance,
              '${navlog.totalDistanceNm.toStringAsFixed(1)} NM',
            ),
            _Stat(
              l10n.navlogTime,
              navlog.totalTime == null
                  ? '–'
                  : formatDuration(navlog.totalTime!),
            ),
            _Stat(
              l10n.navlogFuel,
              navlog.totalFuelL == null
                  ? '–'
                  : '${fuelUnit.fromLiters(navlog.totalFuelL!).toStringAsFixed(1)} ${fuelUnit.symbol}',
            ),
            _Stat('TAS', '${data.aircraft!.cruiseTas} kt'),
          ],
        ),
        if (unsolvable)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              l10n.navlogUnsolvable,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: NavlogTable(
              navlog: navlog,
              fuelUnit: fuelUnit,
              onTapLeg: (i) =>
                  showEditWaypointDialog(context, data.waypoints[i + 1]),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.navlogFootnote,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: monoStyle(context, base: theme.textTheme.titleLarge),
          ),
        ],
      ),
    );
  }
}
