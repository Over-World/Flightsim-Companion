import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/service_credentials.dart';
import 'core/settings.dart';
import 'data/db/database.dart';
import 'data/navdata/navdata_importer.dart';
import 'data/repositories/aircraft_repository.dart';
import 'data/repositories/flight_repository.dart';
import 'data/repositories/navdata_repository.dart';
import 'data/repositories/notes_repository.dart';
import 'features/kneeboard/kneeboard_controller.dart';
import 'data/weather/weather_repository.dart';
import 'features/navdata/navdata_controller.dart';
import 'features/weather/weather_controller.dart';

/// All app-wide services and controllers, shared by `main` and tests.
class AppScope extends StatelessWidget {
  AppScope({
    super.key,
    required this.db,
    required this.prefs,
    required this.settings,
    required this.child,
    this.credentials = const BuildTimeCredentials(),

    /// Shared HTTP client for online services; tests pass a fake.
    http.Client? httpClient,
  }) : aircraft = AircraftRepository(db),
       navdata = NavdataRepository(db),
       flights = FlightRepository(db),
       notes = NotesRepository(db),
       weather = WeatherRepository(db, client: httpClient);

  final AppDatabase db;
  final SharedPreferences prefs;
  final SettingsController settings;
  final ServiceCredentials credentials;
  final AircraftRepository aircraft;
  final NavdataRepository navdata;
  final FlightRepository flights;
  final NotesRepository notes;
  final WeatherRepository weather;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: db),
        Provider<ServiceCredentials>.value(value: credentials),
        Provider.value(value: aircraft),
        Provider.value(value: navdata),
        Provider.value(value: flights),
        Provider.value(value: notes),
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider(
          create: (_) => NavdataController(
            importerFactory: () => NavdataImporter(db),
            repository: navdata,
            settings: settings,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              WeatherController(repository: weather, navdata: navdata),
        ),
        ChangeNotifierProvider(
          create: (_) => KneeboardController(
            prefs: prefs,
            flights: flights,
            navdata: navdata,
          ),
        ),
      ],
      child: child,
    );
  }
}
