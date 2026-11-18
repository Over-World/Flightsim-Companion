import 'dart:io';

import 'package:drift/native.dart';
import 'package:flightsim_companion/data/charts/chart_naming.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/charts_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('chart naming', () {
    test('guesses the category from the file name', () {
      final cases = {
        'EDDF_ILS_25R.pdf': ChartCategory.approach,
        'EDDF RNAV RWY 07L.pdf': ChartCategory.approach,
        'EDDF-SID-RWY25C-RNAV.pdf': ChartCategory.departure,
        'EDDF_STAR_RWY07.pdf': ChartCategory.arrival,
        'EDFE_VFR.png': ChartCategory.vfr,
        'EDFE Sichtanflugkarte.pdf': ChartCategory.vfr,
        'EDDF_GND_Parking.pdf': ChartCategory.ground,
        'EDDF Rollkarte.jpg': ChartCategory.ground,
        'EDDF_ADC.pdf': ChartCategory.airport,
        'EDDF AD 2.pdf': ChartCategory.airport,
        'Inside notes.pdf': ChartCategory.other,
      };
      for (final MapEntry(:key, :value) in cases.entries) {
        expect(guessChartCategory(key), value, reason: key);
      }
    });

    test('readable names, airport ident and file types', () {
      expect(chartNameFromFile('/x/EDDF_ILS_25R.pdf'), 'EDDF ILS 25R');
      expect(chartNameFromFile('EDDF-SID-RWY25C.pdf'), 'EDDF SID RWY25C');
      expect(guessAirportIdent('eddf_ils.pdf', ['EDFE', 'EDDF']), 'EDDF');
      expect(guessAirportIdent('ils.pdf', ['EDDF']), isNull);
      expect(chartFileType('a.PDF'), ChartFileType.pdf);
      expect(chartFileType('a.jpeg'), ChartFileType.image);
      expect(chartFileType('a.txt'), isNull);
    });
  });

  group('ChartsRepository', () {
    late AppDatabase db;
    late Directory dir;
    late ChartsRepository repo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      dir = await Directory.systemTemp.createTemp('charts_test');
      repo = ChartsRepository(
        db,
        directory: () async => Directory('${dir.path}/charts'),
      );
    });

    tearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    test('imports, lists, updates and deletes charts', () async {
      final src = File('${dir.path}/EDDF_ILS_25R.pdf')
        ..writeAsBytesSync([1, 2, 3]);
      final id = await repo.import(
        src.path,
        src.openRead(),
        airportIdent: 'eddf',
        name: '',
        category: ChartCategory.approach,
      );
      final chart = (await repo.byId(id))!;
      expect(chart.airportIdent, 'EDDF');
      expect(chart.name, 'EDDF ILS 25R');
      expect(chart.fileType, ChartFileType.pdf);
      final copy = await repo.file(chart);
      expect(copy.readAsBytesSync(), [1, 2, 3]);

      expect(await repo.watchForAirports(['EDDF', 'EDFE']).first, hasLength(1));
      expect(await repo.watchForAirports(['EDFE']).first, isEmpty);

      await repo.update(
        id,
        airportIdent: 'EDDF',
        name: 'ILS Z 25R',
        category: ChartCategory.approach,
      );
      expect((await repo.byId(id))!.name, 'ILS Z 25R');

      await repo.delete(chart);
      expect(await repo.byId(id), isNull);
      expect(copy.existsSync(), isFalse);
    });

    test('keeps ink per page and per flight', () async {
      final src = File('${dir.path}/a.png')..writeAsBytesSync([0]);
      final id = await repo.import(
        src.path,
        src.openRead(),
        airportIdent: 'EDDF',
        name: 'A',
        category: ChartCategory.ground,
      );
      final flightId = await db
          .into(db.flights)
          .insert(
            FlightsCompanion.insert(
              title: 'T',
              rules: FlightRules.vfr,
              departureIdent: 'EDDF',
              destinationIdent: 'EDFE',
            ),
          );
      await repo.saveAnnotations(id, null, 0, '[1]');
      await repo.saveAnnotations(id, flightId, 0, '[2]');
      await repo.saveAnnotations(id, flightId, 0, '[3]');
      await repo.saveAnnotations(id, flightId, 1, '[4]');
      expect(await repo.annotations(id, null), {0: '[1]'});
      expect(await repo.annotations(id, flightId), {0: '[3]', 1: '[4]'});
    });
  });
}
