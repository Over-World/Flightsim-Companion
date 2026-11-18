import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../core/units.dart';
import '../../data/repositories/aircraft_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';

class AircraftListScreen extends StatelessWidget {
  const AircraftListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fuelUnit = context.watch<SettingsController>().fuelUnit;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navAircraft)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/plan/aircraft/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.aircraftAdd),
      ),
      body: StreamBuilder(
        stream: context.read<AircraftRepository>().watchAll(),
        builder: (context, snapshot) {
          final aircraft = snapshot.data;
          if (aircraft == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (aircraft.isEmpty) {
            return EmptyState(
              icon: Icons.airplanemode_inactive,
              title: l10n.aircraftEmpty,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: aircraft.length,
            itemBuilder: (context, i) {
              final a = aircraft[i];
              final burn = fuelUnit.fromLiters(a.fuelBurnLph);
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    a.icaoType.length > 4
                        ? a.icaoType.substring(0, 4)
                        : a.icaoType,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                title: Text(
                  a.registration.isEmpty
                      ? a.name
                      : '${a.name} · ${a.registration}',
                ),
                subtitle: Text(
                  l10n.aircraftSummary(
                    a.cruiseTas,
                    burn.toStringAsFixed(1),
                    fuelUnit.symbol,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/plan/aircraft/${a.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
