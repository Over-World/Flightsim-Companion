import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';

class LogbookScreen extends StatelessWidget {
  const LogbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navLogbook)),
      body: EmptyState(
        icon: Icons.menu_book_outlined,
        title: l10n.logbookEmptyTitle,
        message: l10n.logbookEmptyMessage,
      ),
    );
  }
}
