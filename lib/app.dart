import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'core/settings.dart';
import 'core/theme.dart';
import 'l10n/app_localizations.dart';

class FlightsimCompanionApp extends StatelessWidget {
  const FlightsimCompanionApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: lightTheme(settings.accent),
      darkTheme: darkTheme(settings.accent),
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
