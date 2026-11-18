import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/router.dart';
import 'core/service_credentials.dart';
import 'core/settings.dart';
import 'data/db/database.dart';
import 'data/navdata/navdata_importer.dart';
import 'data/repositories/aircraft_repository.dart';
import 'data/repositories/navdata_repository.dart';
import 'features/navdata/navdata_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = await SettingsController.load();
  final db = AppDatabase();
  final aircraft = AircraftRepository(db);
  await aircraft.seedDefaults();
  final navdata = NavdataRepository(db);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: db),
        Provider<ServiceCredentials>.value(value: const BuildTimeCredentials()),
        Provider.value(value: aircraft),
        Provider.value(value: navdata),
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider(
          create: (_) => NavdataController(
            importerFactory: () => NavdataImporter(db),
            repository: navdata,
            settings: settings,
          ),
        ),
      ],
      child: FlightsimCompanionApp(router: createRouter(settings)),
    ),
  );
}
