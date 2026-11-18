import 'dart:ui';

import 'package:drift/native.dart';
import 'package:flightsim_companion/app.dart';
import 'package:flightsim_companion/app_scope.dart';
import 'package:flightsim_companion/core/router.dart';
import 'package:flightsim_companion/core/settings.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/features/notes/drawing_canvas.dart';
import 'package:flightsim_companion/features/notes/drawing_controller.dart';
import 'package:flightsim_companion/features/notes/stroke.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fixtures.dart';

void main() {
  group('DrawingController', () {
    test('draw, undo, redo and erase', () {
      final commits = <int>[];
      final c = DrawingController(onCommit: (s) => commits.add(s.length));
      c.begin(10, 10, 0.5);
      c.extend(50, 50, 0.6);
      c.end();
      c.begin(500, 500, 0.5);
      c.extend(520, 520, 0.5);
      c.end();
      expect(c.strokes, hasLength(2));

      c.undo();
      expect(c.strokes, hasLength(1));
      c.redo();
      expect(c.strokes, hasLength(2));

      // The inverted stylus end erases the stroke under it.
      c.begin(505, 505, 0.5, eraser: true);
      c.end();
      expect(c.strokes, hasLength(1));
      c.undo();
      expect(c.strokes, hasLength(2));
      expect(commits, [1, 2, 1, 2, 1, 2]);
    });

    test('strokes survive a JSON round trip', () {
      final s = Stroke(
        tool: StrokeTool.highlighter,
        color: 2,
        size: 26,
        simulatePressure: true,
        points: [1.04, 2, 0.5, 3, 4.26, 0.7],
      );
      final back = Stroke.decodeAll(Stroke.encodeAll([s])).single;
      expect(back.tool, StrokeTool.highlighter);
      expect(back.color, 2);
      expect(back.simulatePressure, isTrue);
      expect(back.points, [1.0, 2, 0.5, 3, 4.3, 0.7]);
    });
  });

  group('Notepad screen', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() => db.close());

    Future<void> pumpNotepad(
      WidgetTester tester, {
      bool finger = true,
      Size size = const Size(800, 1280),
    }) async {
      SharedPreferences.setMockInitialValues({
        'language': 'en',
        'onboardingCompleted': true,
        'fingerDrawing': finger,
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
      await tester.tap(find.byTooltip('Notepad'));
      await settle(tester);
    }

    Future<void> drawLine(WidgetTester tester, PointerDeviceKind kind) async {
      final center = tester.getCenter(find.byType(DrawingCanvas));
      final gesture = await tester.startGesture(center, kind: kind);
      for (var i = 1; i <= 5; i++) {
        await gesture.moveBy(const Offset(10, 6));
      }
      await gesture.up();
      await tester.pump();
    }

    Future<List<Stroke>> savedStrokes(WidgetTester tester) async {
      await tester.pump(const Duration(milliseconds: 500));
      final pages = await tester.runAsync(
        () => db.select(db.scratchPages).get(),
      );
      return Stroke.decodeAll(pages!.single.strokes);
    }

    Future<void> unmount(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 10));
      await tester.pump(const Duration(milliseconds: 10));
    }

    testWidgets('stylus strokes are saved to a general page', (tester) async {
      await pumpNotepad(tester);
      expect(find.text('General notes'), findsOneWidget);
      await drawLine(tester, PointerDeviceKind.stylus);
      final strokes = await savedStrokes(tester);
      expect(strokes, hasLength(1));
      expect(strokes.single.pointCount, greaterThan(3));
      await unmount(tester);
    });

    testWidgets('notepad with templates fits on a phone and in landscape', (
      tester,
    ) async {
      for (final size in const [Size(360, 740), Size(1280, 800)]) {
        await pumpNotepad(tester, size: size);
        await tester.tap(find.text('Page'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Clearance (CRAFT)').last);
        await settle(tester);
        expect(find.byType(ChoiceChip), findsNWidgets(2));
        expect(tester.takeException(), isNull);
        await unmount(tester);
        await tester.runAsync(() => db.delete(db.scratchPages).go());
      }
    });

    testWidgets('a finger does not draw when finger drawing is off', (
      tester,
    ) async {
      await pumpNotepad(tester, finger: false);
      await drawLine(tester, PointerDeviceKind.touch);
      expect(await savedStrokes(tester), isEmpty);
      await drawLine(tester, PointerDeviceKind.stylus);
      expect(await savedStrokes(tester), hasLength(1));
      await unmount(tester);
    });
  });
}

/// Lets drift queries complete on the real event loop.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 50));
  }
}
