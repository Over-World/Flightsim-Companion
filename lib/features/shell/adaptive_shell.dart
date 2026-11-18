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
      (Icons.calculate_outlined, Icons.calculate, l10n.navE6b),
      (Icons.menu_book_outlined, Icons.menu_book, l10n.navLogbook),
      (Icons.settings_outlined, Icons.settings, l10n.navSettings),
    ];

    final useRail = MediaQuery.sizeOf(context).width >= railBreakpoint;
    void openNotes() => context.push('/notes');
    if (!useRail) {
      return Scaffold(
        body: Stack(
          children: [
            navigationShell,
            // Bottom-left, clear of the screens' own FABs on the right.
            Positioned(
              left: 16,
              bottom: 16,
              child: FloatingActionButton.small(
                heroTag: 'notes',
                tooltip: l10n.notesOpen,
                onPressed: openNotes,
                child: const Icon(Icons.draw_outlined),
              ),
            ),
          ],
        ),
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
              trailingAtBottom: true,
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: FloatingActionButton(
                  heroTag: 'notes',
                  elevation: 0,
                  tooltip: l10n.notesOpen,
                  onPressed: openNotes,
                  child: const Icon(Icons.draw_outlined),
                ),
              ),
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
