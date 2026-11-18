import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import 'navdata_controller.dart';

/// Prompts for the navdata import while the database is empty.
class NavdataMissingCard extends StatelessWidget {
  const NavdataMissingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final navdata = context.watch<NavdataController>();
    if (navdata.counts == null || navdata.hasData) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.navdataMissingTitle,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(l10n.navdataMissingMessage),
              ],
            );
            final button = FilledButton.tonal(
              onPressed: () => context.go('/settings'),
              child: Text(l10n.navdataMissingAction),
            );
            final icon = Icon(
              Icons.cloud_download_outlined,
              color: theme.colorScheme.onSecondaryContainer,
            );
            if (constraints.maxWidth < 480) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      icon,
                      const SizedBox(width: 16),
                      Expanded(child: text),
                    ],
                  ),
                  const SizedBox(height: 12),
                  button,
                ],
              );
            }
            return Row(
              children: [
                icon,
                const SizedBox(width: 16),
                Expanded(child: text),
                const SizedBox(width: 16),
                button,
              ],
            );
          },
        ),
      ),
    );
  }
}
