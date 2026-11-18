import 'package:drift/native.dart';
import 'package:flightsim_companion/app.dart';
import 'package:flightsim_companion/app_scope.dart';
import 'package:flightsim_companion/core/router.dart';
import 'package:flightsim_companion/core/settings.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/aircraft_repository.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:flightsim_companion/features/kneeboard/kneeboard_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures.dart';

const sizes = {
  'phone': Size(360, 740),
  'tablet portrait': Size(800, 1280),
  'tablet landscape': Size(1280, 800),
};

void main() {
  late AppDatabase db;
  late int flightId;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'language': 'en',
      'onboardingCompleted': true,
    });
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<GoRouter> pumpApp(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.runAsync(() async {
      await AircraftRepository(db).seedDefaults();
      await insertNavdataFixtures(db);
      flightId = await createFixtureFlight(FlightRepository(db));
    });
    final prefs = await SharedPreferences.getInstance();
    final settings = SettingsController(prefs);
    final router = createRouter(settings);
    await tester.pumpWidget(
      AppScope(
        db: db,
        prefs: prefs,
        settings: settings,
        child: FlightsimCompanionApp(router: router),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
  }

  /// Lets drift queries complete on the real event loop.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  for (final MapEntry(key: name, value: size) in sizes.entries) {
    testWidgets('flight list and editor on $name', (tester) async {
      final router = await pumpApp(tester, size);
      await settle(tester);
      expect(find.text('EDFE → EDFZ'), findsOneWidget);

      router.go('/plan/flights/$flightId');
      await settle(tester);
      Finder inRoute(String text) => find.descendant(
        of: find.byType(ReorderableListView),
        matching: find.text(text),
      );
      expect(inRoute('FFM'), findsNWidgets(1));

      // Add a second FFM via the waypoint dialog.
      await tester.tap(find.text('Add waypoint'));
      await tester.pumpAndSettle();
      expect(find.text('Radial/DME'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'FFM');
      await tester.pump(const Duration(milliseconds: 300));
      await settle(tester);
      await tester.tap(find.text('Frankfurt · VOR-DME'));
      await tester.pumpAndSettle();
      await settle(tester);
      expect(inRoute('FFM'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
      if (size.width < 1000) {
        await tester.tap(find.text('Navlog'));
        await settle(tester);
      }
      expect(find.text('Total'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    testWidgets('kneeboard on $name', (tester) async {
      final router = await pumpApp(tester, size);
      final context = tester.element(find.byType(Scaffold).first);
      await tester.runAsync(
        () => context.read<KneeboardController>().open(flightId),
      );
      router.go('/fly');
      await settle(tester);
      expect(find.text('Off block'), findsWidgets);

      await tester.tap(find.widgetWithText(FilledButton, 'Off block'));
      await settle(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Takeoff'));
      await settle(tester);
      expect(find.text('Over FFM'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('114.20'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ListView).first,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('114.20'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }
}
