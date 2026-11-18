import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

/// Width from which a NavigationRail replaces the bottom NavigationBar.
const double railBreakpoint = 600;

class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinations = [
      (Icons.map_outlined, Icons.map, l10n.navPlan),
      (Icons.flight_takeoff_outlined, Icons.flight_takeoff, l10n.navFly),
      (
        Icons.airplanemode_active_outlined,
        Icons.airplanemode_active,
        l10n.navAircraft,
      ),
      (Icons.menu_book_outlined, Icons.menu_book, l10n.navLogbook),
      (Icons.settings_outlined, Icons.settings, l10n.navSettings),
    ];

    final useRail = MediaQuery.sizeOf(context).width >= railBreakpoint;
    if (!useRail) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _select,
          destinations: [
            for (final (icon, selected, label) in destinations)
              NavigationDestination(
                icon: Icon(icon),
                selectedIcon: Icon(selected),
                label: label,
              ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _select,
              labelType: NavigationRailLabelType.all,
              groupAlignment: -0.85,
              destinations: [
                for (final (icon, selected, label) in destinations)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(selected),
                    label: Text(label),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
