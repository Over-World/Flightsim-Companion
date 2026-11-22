import 'dart:io';

import 'package:drift/native.dart';
import 'package:flightsim_companion/app.dart';
import 'package:flightsim_companion/app_scope.dart';
import 'package:flightsim_companion/core/router.dart';
import 'package:flightsim_companion/core/settings.dart';
import 'package:flightsim_companion/data/charts/chart_document.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/aircraft_repository.dart';
import 'package:flightsim_companion/data/repositories/charts_repository.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:flightsim_companion/data/sim/sim_snapshot.dart';
import 'package:flightsim_companion/features/charts/chart_ink_layer.dart';
import 'package:flightsim_companion/features/charts/charts_list.dart';
import 'package:flightsim_companion/features/notes/stroke.dart';
import 'package:flightsim_companion/features/sim/sim_widgets.dart';
import 'package:flightsim_companion/features/kneeboard/kneeboard_controller.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/gestures.dart';
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
  late Directory chartsDir;
  late FakeChartFiles chartFiles;
  late FakeSimSession simSession;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'language': 'en',
      'onboardingCompleted': true,
    });
    db = AppDatabase(NativeDatabase.memory());
    chartsDir = Directory.systemTemp.createTempSync('fsc_charts');
    chartFiles = FakeChartFiles();
    simSession = FakeSimSession();
  });

  tearDown(() async {
    await db.close();
    chartsDir.deleteSync(recursive: true);
  });

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
        httpClient: fakeWeatherClient(),
        chartsDirectory: () async => chartsDir,
        chartFiles: chartFiles,
        simConnector: (_, _) async => simSession,
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
      final route = await tester.runAsync(
        () => FlightRepository(db).loadFlight(flightId),
      );
      expect(route!.waypoints.where((w) => w.ident == 'FFM'), hasLength(2));
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

    testWidgets('E6B on $name', (tester) async {
      final router = await pumpApp(tester, size);
      router.go('/e6b');
      await settle(tester);
      if (size.width < 840) {
        await tester.tap(find.text('Wind triangle'));
        await tester.pumpAndSettle();
      }
      // Wind triangle: TC 090, TAS 100, wind 360/20 → WCA -12, GS 98.
      final fields = find.descendant(
        of: find.byType(Card).first,
        matching: find.byType(TextField),
      );
      await tester.enterText(fields.at(0), '90');
      await tester.enterText(fields.at(1), '100');
      await tester.enterText(fields.at(2), '360');
      await tester.enterText(fields.at(3), '20');
      await tester.pump();
      expect(find.text('-12°'), findsOneWidget);
      expect(find.text('078°'), findsWidgets);
      expect(find.text('98 kt'), findsOneWidget);

      // Search narrows the index; values survive switching calculators.
      if (size.width < 840) {
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
      }
      await tester.enterText(find.byType(TextField).first, 'TOD');
      await tester.pumpAndSettle();
      expect(find.text('Descent planning'), findsOneWidget);
      expect(find.text('Fuel'), findsNothing);
      await tester.tap(find.text('Descent planning'));
      await tester.pumpAndSettle();
      expect(find.text('Top of descent before'), findsOneWidget);
      if (size.width < 840) {
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
      }
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();
      expect(find.text('Recently used'), findsOneWidget);
      await tester.tap(find.text('Wind triangle').last);
      await tester.pumpAndSettle();
      expect(find.text('98 kt'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    testWidgets('E6B takes values from the active flight on $name', (
      tester,
    ) async {
      final router = await pumpApp(tester, size);
      final context = tester.element(find.byType(Scaffold).first);
      await tester.runAsync(
        () => context.read<KneeboardController>().open(flightId),
      );
      router.go('/e6b');
      await settle(tester);
      await tester.tap(find.text('From flight'));
      await settle(tester);
      if (size.width < 840) {
        await tester.tap(find.text('Wind triangle'));
        await tester.pumpAndSettle();
      }
      // C172 cruise TAS lands in the wind triangle.
      expect(find.widgetWithText(TextField, '115'), findsWidgets);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    testWidgets('aircraft profiles live under Plan on $name', (tester) async {
      await pumpApp(tester, size);
      await tester.tap(find.byTooltip('Aircraft'));
      await settle(tester);
      expect(find.text('Cessna 172 SP'), findsOneWidget);
      await unmount(tester);
    });

    testWidgets('runway selection on $name', (tester) async {
      final router = await pumpApp(tester, size);
      await tester.runAsync(
        () => FlightRepository(db).updateFlight(
          flightId,
          const FlightsCompanion(
            windDirection: Value(300),
            windSpeedKt: Value(20),
          ),
        ),
      );
      router.go('/plan/flights/$flightId');
      await settle(tester);
      expect(find.text('Expected runways'), findsOneWidget);
      expect(find.text('Most headwind: 26'), findsNWidgets(2));

      await tester.tap(find.widgetWithText(ChoiceChip, '26').first);
      await settle(tester);
      expect(find.textContaining('Pattern 1380 ft'), findsOneWidget);
      // C172: 15 kt demonstrated; 20 kt at 36° gives 12 kt – no warning.
      expect(find.textContaining('Crosswind above'), findsNothing);

      await tester.tap(find.widgetWithText(ChoiceChip, '08').first);
      await settle(tester);
      expect(find.textContaining('Tailwind –'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    testWidgets('weather tab and use wind on $name', (tester) async {
      final router = await pumpApp(tester, size);
      router.go('/plan/flights/$flightId');
      await settle(tester);
      await tester.ensureVisible(find.text('Weather'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Weather'));
      await settle(tester);
      await settle(tester);
      // EDFE has no METAR of its own: nearest station EDDF.
      expect(find.textContaining('Nearest report EDDF'), findsWidgets);
      expect(find.text('989'), findsWidgets);
      await tester.tap(find.text('Use wind 220° / 17 kt').first);
      await settle(tester);
      final flight = await tester.runAsync(
        () => FlightRepository(db).loadFlight(flightId),
      );
      expect(flight!.flight.windDirection, 220);
      expect(flight.flight.windSpeedKt, 17);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    testWidgets('fuel plan and weight & balance on $name', (tester) async {
      final router = await pumpApp(tester, size);
      router.go('/plan/flights/$flightId');
      await settle(tester);
      Future<void> openTab(String label) async {
        await tester.ensureVisible(find.text(label).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text(label).first);
        await settle(tester);
      }

      await openTab('Fuel');
      // The breakdown is built below the inputs; bring rows into view
      // directly instead of dragging (the drag point can hit a text field).
      Future<void> reveal(String text) async {
        await tester.ensureVisible(find.text(text, skipOffstage: false));
        await tester.pumpAndSettle();
        expect(find.text(text), findsOneWidget);
      }

      await reveal('Fuel plan');
      await reveal('Final reserve 30 min');
      // C172: 4 L taxi + trip + 17 L reserve, planned as required.
      await reveal('+0.0 L');

      await openTab('W&B');
      expect(find.text('Loading'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextField, 'Pilot & front passenger'),
        '160',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await settle(tester);
      final f = await tester.runAsync(
        () => FlightRepository(db).loadFlight(flightId),
      );
      expect(f!.loadsKg[0], 160);
      expect(f.weightBalance!.ok, isTrue);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    testWidgets('chart import, viewer and ink on $name', (tester) async {
      final router = await pumpApp(tester, size);
      chartFiles.image = await tester.runAsync(
        () => createTestImage(width: 60, height: 80),
      );
      chartFiles.next = [
        PickedChartFile('EDFE_VFR.png', () => Stream.value([1, 2, 3])),
        PickedChartFile('EDFZ ILS 26.pdf', () => Stream.value([4, 5])),
      ];
      router.go('/plan/flights/$flightId');
      await settle(tester);
      await tester.ensureVisible(find.text('Charts').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Charts').first);
      await settle(tester);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(ChartsList),
          matching: find.text('Departure · EDFE'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.widgetWithText(TextButton, 'Import').first);
      await tester.pumpAndSettle();
      expect(find.text('Import charts (2)'), findsOneWidget);
      // Category and airport guessed from the file names.
      expect(find.text('VFR chart'), findsOneWidget);
      expect(find.text('Approach'), findsOneWidget);
      expect(find.text('EDFZ'), findsWidgets);
      await tester.tap(find.widgetWithText(FilledButton, 'Import'));
      await tester.pumpAndSettle();
      for (var i = 0; i < 4; i++) {
        await settle(tester);
      }
      expect(find.text('2 of 2 charts imported'), findsOneWidget);
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
          .removeCurrentSnackBar();
      final charts = await tester.runAsync(() => db.select(db.charts).get());
      expect(
        {for (final c in charts!) c.name: (c.airportIdent, c.category)},
        {
          'EDFE VFR': ('EDFE', ChartCategory.vfr),
          'EDFZ ILS 26': ('EDFZ', ChartCategory.approach),
        },
      );
      expect(find.text('EDFE VFR'), findsOneWidget);

      await tester.tap(find.text('EDFE VFR'));
      for (var i = 0; i < 4; i++) {
        await settle(tester);
      }
      expect(find.byType(RawImage), findsOneWidget);
      expect(find.text('Page 1 of 2'), findsOneWidget);

      // A stylus draws, a finger only pans.
      final page = tester.getCenter(find.byType(ChartInkLayer));
      final pen = await tester.startGesture(
        page,
        kind: PointerDeviceKind.stylus,
      );
      for (var i = 0; i < 5; i++) {
        await pen.moveBy(const Offset(10, 6));
        await tester.pump();
      }
      await pen.up();
      await tester.drag(find.byType(ChartInkLayer), const Offset(-40, 30));
      await settle(tester);
      final chartId = charts.firstWhere((c) => c.name == 'EDFE VFR').id;
      final ink = await tester.runAsync(
        () => ChartsRepository(db).annotations(chartId, flightId),
      );
      expect(Stroke.decodeAll(ink![0]!), hasLength(1));

      await tester.tap(find.byTooltip('Night mode'));
      await tester.tap(find.byTooltip('Next page'));
      await settle(tester);
      expect(find.text('Page 2 of 2'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // The kneeboard links the flight's charts.
      final context = tester.element(find.byType(Scaffold).first);
      await tester.runAsync(
        () => context.read<KneeboardController>().open(flightId),
      );
      router.go('/fly');
      await settle(tester);
      await tester.scrollUntilVisible(
        find.widgetWithText(ActionChip, 'EDFZ ILS 26'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ListView).last,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.widgetWithText(ActionChip, 'EDFE VFR'), findsOneWidget);
      await settle(tester);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    testWidgets('kneeboard with X-Plane on $name', (tester) async {
      SharedPreferences.setMockInitialValues({
        'language': 'en',
        'onboardingCompleted': true,
        'simHost': '127.0.0.1',
      });
      final router = await pumpApp(tester, size);
      final context = tester.element(find.byType(Scaffold).first);
      await tester.runAsync(
        () => context.read<KneeboardController>().open(flightId),
      );
      router.go('/fly');
      await settle(tester);
      simSession.send(simAt(49.96, 8.6458, parkingBrake: true));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byTooltip('X-Plane: Connected'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Off block'));
      await settle(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Takeoff'));
      await settle(tester);
      simSession.send(simAt(50.0, 8.62, onGround: false, gs: 98));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('DTG'), findsOneWidget);
      expect(find.text('XTK'), findsOneWidget);
      expect(find.text('X-Plane records this automatically'), findsOneWidget);

      final list = find
          .descendant(
            of: find.byType(ListView).last,
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        find.text('119.150'),
        200,
        scrollable: list,
      );
      expect(find.text('COM1'), findsOneWidget);

      // Tap the FFM frequency and tune NAV1 standby.
      final ffm = find.descendant(
        of: find.byType(TunableFrequency),
        matching: find.text('114.20'),
      );
      // In landscape the frequencies are in the left column.
      final landscape = size.width >= 960 && size.width > size.height;
      await tester.scrollUntilVisible(
        ffm,
        200,
        scrollable: find
            .descendant(
              of: landscape
                  ? find.byType(ListView).first
                  : find.byType(ListView).last,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.ensureVisible(ffm);
      await tester.pumpAndSettle();
      await tester.tap(ffm);
      await tester.pumpAndSettle();
      await tester.tap(find.text('NAV1 standby'));
      await tester.pumpAndSettle();
      expect(simSession.tuned.last, (SimRadio.nav1, 114200, true));
      expect(find.text('NAV1 standby set to 114.20'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    testWidgets('logbook on $name', (tester) async {
      final router = await pumpApp(tester, size);
      await tester.runAsync(() async {
        final off = DateTime(2026, 11, 21, 14, 2);
        await db
            .into(db.logbookEntries)
            .insert(
              LogbookEntriesCompanion.insert(
                rules: FlightRules.vfr,
                departureIdent: 'EDFE',
                destinationIdent: 'EDFZ',
                aircraftName: const Value('Cessna 172 SP'),
                blockOffAt: off,
                takeoffAt: Value(off.add(const Duration(minutes: 8))),
                landingAt: Value(off.add(const Duration(minutes: 31))),
                blockOnAt: off.add(const Duration(minutes: 37)),
                distanceNm: const Value(24.6),
                touchdownFpm: const Value(-96),
                touchdownG: const Value(1.12),
              ),
            );
      });
      router.go('/logbook');
      await settle(tester);
      expect(find.text('EDFE → EDFZ'), findsOneWidget);
      expect(find.text('0:37'), findsOneWidget);
      expect(find.text('0:23'), findsOneWidget);
      expect(find.text('96 fpm'), findsOneWidget);

      await tester.tap(find.text('EDFE → EDFZ'));
      await tester.pumpAndSettle();
      expect(find.text('Butter · 96 fpm'), findsOneWidget);
      expect(find.text('25 NM'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }
}
