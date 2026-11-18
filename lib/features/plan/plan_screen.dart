import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/db/database.dart';
import '../../data/repositories/flight_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';
import '../navdata/navdata_missing_card.dart';
import 'new_flight_dialog.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  Future<void> _newFlight(BuildContext context) async {
    final id = await showNewFlightDialog(context);
    if (id != null && context.mounted) context.go('/plan/flights/$id');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navPlan),
        actions: [
          IconButton(
            tooltip: l10n.airportSearchTitle,
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/plan/airports'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newFlight(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.flightNew),
      ),
      body: Column(
        children: [
          const NavdataMissingCard(),
          Expanded(
            child: StreamBuilder<List<Flight>>(
              stream: context.read<FlightRepository>().watchFlights(),
              builder: (context, snapshot) {
                final flights = snapshot.data;
                if (flights == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (flights.isEmpty) {
                  return EmptyState(
                    icon: Icons.route_outlined,
                    title: l10n.flightsEmptyTitle,
                    message: l10n.flightsEmptyMessage,
                  );
                }
                return _FlightGrid(flights);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FlightGrid extends StatelessWidget {
  const _FlightGrid(this.flights);

  final List<Flight> flights;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / 420).floor().clamp(1, 3);
        final width =
            (constraints.maxWidth - 32 - 12 * (columns - 1)) / columns;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final f in flights)
                SizedBox(width: width, child: _FlightCard(f)),
            ],
          ),
        );
      },
    );
  }
}

class _FlightCard extends StatelessWidget {
  const _FlightCard(this.flight);

  final Flight flight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final status = switch (flight.status) {
      FlightStatus.planned => l10n.flightStatusPlanned,
      FlightStatus.active => l10n.flightStatusActive,
      FlightStatus.completed => l10n.flightStatusCompleted,
    };
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/plan/flights/${flight.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _RulesBadge(flight.rules),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      status,
                      style: theme.textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd(locale).format(flight.updatedAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${flight.departureIdent} → ${flight.destinationIdent}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
              if (flight.title !=
                  '${flight.departureIdent} – ${flight.destinationIdent}')
                Text(flight.title, style: theme.textTheme.bodyMedium),
              if (flight.alternateIdent != null)
                Text(
                  l10n.flightAlternateShort(flight.alternateIdent!),
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RulesBadge extends StatelessWidget {
  const _RulesBadge(this.rules);

  final FlightRules rules;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ifr = rules == FlightRules.ifr;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: ifr ? scheme.tertiaryContainer : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        ifr ? 'IFR' : 'VFR',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: ifr ? scheme.onTertiaryContainer : scheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
