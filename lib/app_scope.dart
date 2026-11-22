import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/service_credentials.dart';
import 'core/settings.dart';
import 'data/charts/chart_document.dart';
import 'data/db/database.dart';
import 'data/navdata/navdata_importer.dart';
import 'data/repositories/aircraft_repository.dart';
import 'data/repositories/charts_repository.dart';
import 'data/repositories/flight_repository.dart';
import 'data/repositories/logbook_repository.dart';
import 'data/repositories/navdata_repository.dart';
import 'data/repositories/notes_repository.dart';
import 'features/kneeboard/kneeboard_controller.dart';
import 'data/weather/weather_repository.dart';
import 'features/navdata/navdata_controller.dart';
import 'features/sim/sim_controller.dart';
import 'features/sim/sim_flight_tracker.dart';
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

    /// Where imported charts are stored; tests pass a temp directory.
    Future<Directory> Function()? chartsDirectory,
    this.chartFiles = const ChartFileAccess(),

    /// Opens simulator sessions; tests pass a fake.
    this.simConnector = connectXPlane,
  }) : aircraft = AircraftRepository(db),
       navdata = NavdataRepository(db),
       flights = FlightRepository(db),
       notes = NotesRepository(db),
       logbook = LogbookRepository(db),
       charts = ChartsRepository(db, directory: chartsDirectory),
       weather = WeatherRepository(db, client: httpClient);

  final AppDatabase db;
  final SharedPreferences prefs;
  final SettingsController settings;
  final ServiceCredentials credentials;
  final AircraftRepository aircraft;
  final NavdataRepository navdata;
  final FlightRepository flights;
  final NotesRepository notes;
  final LogbookRepository logbook;
  final SimConnector simConnector;
  final ChartsRepository charts;
  final ChartFileAccess chartFiles;
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
        Provider.value(value: logbook),
        Provider.value(value: charts),
        Provider.value(value: chartFiles),
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
            logbook: logbook,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              SimController(settings: settings, connector: simConnector),
        ),
        Provider(
          lazy: false,
          create: (context) => SimFlightTracker(
            sim: context.read<SimController>(),
            kneeboard: context.read<KneeboardController>(),
            settings: settings,
          ),
          dispose: (_, tracker) => tracker.dispose(),
        ),
      ],
      child: child,
    );
  }
}
