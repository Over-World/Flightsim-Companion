import 'package:drift/native.dart';
import 'package:flightsim_companion/app.dart';
import 'package:flightsim_companion/app_scope.dart';
import 'package:flightsim_companion/core/router.dart';
import 'package:flightsim_companion/core/settings.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures.dart';

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

    final prefs = await SharedPreferences.getInstance();
    final settings = SettingsController(prefs);
    await tester.pumpWidget(
      AppScope(
        db: db,
        prefs: prefs,
        settings: settings,
        httpClient: fakeWeatherClient(),
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
