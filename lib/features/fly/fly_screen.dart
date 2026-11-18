import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';

class FlyScreen extends StatelessWidget {
  const FlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navFly)),
      body: EmptyState(
        icon: Icons.flight_takeoff_outlined,
        title: l10n.flyNoActiveFlightTitle,
        message: l10n.flyNoActiveFlightMessage,
      ),
    );
  }
}
