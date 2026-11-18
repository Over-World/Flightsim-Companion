import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';
import '../navdata/navdata_missing_card.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

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
      body: Column(
        children: [
          const NavdataMissingCard(),
          Expanded(
            child: EmptyState(
              icon: Icons.route_outlined,
              title: l10n.flightsEmptyTitle,
              message: l10n.flightsEmptyMessage,
              action: OutlinedButton.icon(
                onPressed: () => context.go('/plan/airports'),
                icon: const Icon(Icons.search),
                label: Text(l10n.airportSearchTitle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
