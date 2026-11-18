import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'app_scope.dart';
import 'core/router.dart';
import 'core/settings.dart';
import 'data/db/database.dart';
import 'data/repositories/aircraft_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final settings = SettingsController(prefs);
  final db = AppDatabase();
  await AircraftRepository(db).seedDefaults();

  runApp(
    AppScope(
      db: db,
      prefs: prefs,
      settings: settings,
      child: FlightsimCompanionApp(router: createRouter(settings)),
    ),
  );
}
