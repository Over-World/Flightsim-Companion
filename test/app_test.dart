import 'package:drift/native.dart';
import 'package:flightsim_companion/app.dart';
import 'package:flightsim_companion/core/router.dart';
import 'package:flightsim_companion/core/settings.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/navdata/navdata_importer.dart';
import 'package:flightsim_companion/data/repositories/aircraft_repository.dart';
import 'package:flightsim_companion/data/repositories/navdata_repository.dart';
import 'package:flightsim_companion/features/navdata/navdata_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Unmounts the app so drift's stream-close timers fire inside the test.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 10));
  await tester.pump(const Duration(milliseconds: 10));
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<void> pumpApp(
    WidgetTester tester,
    Size size, {
    bool onboarded = true,
  }) async {
    SharedPreferences.setMockInitialValues({
      'themeMode': 'light',
      'language': 'en',
      'onboardingCompleted': onboarded,
    });
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final settings = await SettingsController.load();
    final navdata = NavdataRepository(db);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: db),
          Provider.value(value: AircraftRepository(db)),
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
    await tester.pumpAndSettle();
  }

  testWidgets('phone uses a bottom navigation bar', (tester) async {
    await pumpApp(tester, const Size(400, 800));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('Plan'), findsWidgets);
    await unmount(tester);
  });

  testWidgets('tablet portrait and landscape use a navigation rail', (
    tester,
  ) async {
    await pumpApp(tester, const Size(800, 1280));
    expect(find.byType(NavigationRail), findsOneWidget);
    await pumpApp(tester, const Size(1280, 800));
    expect(find.byType(NavigationRail), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('shows the navdata prompt while the database is empty', (
    tester,
  ) async {
    await pumpApp(tester, const Size(1280, 800));
    expect(find.text('No navigation data yet'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('fresh install starts the setup and finishes in the planner', (
    tester,
  ) async {
    await pumpApp(tester, const Size(1280, 800), onboarded: false);
    expect(find.text('Welcome aboard'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Home base'), findsOneWidget);
    await tester.tap(find.text("Let's fly"));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('setup fits on a phone', (tester) async {
    await pumpApp(tester, const Size(360, 640), onboarded: false);
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
    await unmount(tester);
  });
}
