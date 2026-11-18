import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../charts/chart_naming.dart';
import '../db/database.dart';

/// Imported chart files and the ink drawn on them.
class ChartsRepository {
  ChartsRepository(this._db, {Future<Directory> Function()? directory})
    : _directory = directory ?? _defaultDirectory;

  final AppDatabase _db;
  final Future<Directory> Function() _directory;
  Directory? _dir;

  static Future<Directory> _defaultDirectory() async => Directory(
    p.join((await getApplicationSupportDirectory()).path, 'charts'),
  );

  Future<Directory> _chartsDir() async {
    final dir = _dir ??= await _directory();
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> file(Chart chart) async =>
      File(p.join((await _chartsDir()).path, chart.fileName));

  Stream<List<Chart>> watchForAirports(Iterable<String> idents) {
    final list = {for (final i in idents) i.toUpperCase()}.toList();
    return (_db.select(_db.charts)
          ..where((c) => c.airportIdent.isIn(list))
          ..orderBy([
            (c) => OrderingTerm.asc(c.airportIdent),
            (c) => OrderingTerm.asc(c.category),
            (c) => OrderingTerm.asc(c.name),
          ]))
        .watch();
  }

  Future<Chart?> byId(int id) =>
      (_db.select(_db.charts)..where((c) => c.id.equals(id))).getSingleOrNull();

  /// Stores [content] (a file called [fileName]) in the charts directory
  /// and registers it.
  Future<int> import(
    String fileName,
    Stream<List<int>> content, {
    required String airportIdent,
    required String name,
    required ChartCategory category,
  }) async {
    final type = chartFileType(fileName);
    if (type == null) throw ArgumentError.value(fileName, 'fileName');
    final ext = p.extension(fileName).toLowerCase();
    final dir = await _chartsDir();
    final stored =
        '${DateTime.now().microsecondsSinceEpoch}_${airportIdent.toUpperCase()}$ext';
    final target = File(p.join(dir.path, stored));
    try {
      await content.pipe(target.openWrite());
    } catch (_) {
      if (await target.exists()) await target.delete();
      rethrow;
    }
    return _db
        .into(_db.charts)
        .insert(
          ChartsCompanion.insert(
            airportIdent: airportIdent.toUpperCase(),
            name: name.trim().isEmpty
                ? chartNameFromFile(fileName)
                : name.trim(),
            category: category,
            fileType: type,
            fileName: stored,
          ),
        );
  }

  Future<void> update(
    int id, {
    required String airportIdent,
    required String name,
    required ChartCategory category,
  }) => (_db.update(_db.charts)..where((c) => c.id.equals(id))).write(
    ChartsCompanion(
      airportIdent: Value(airportIdent.toUpperCase()),
      name: Value(name.trim()),
      category: Value(category),
    ),
  );

  Future<void> delete(Chart chart) async {
    await (_db.delete(_db.charts)..where((c) => c.id.equals(chart.id))).go();
    final f = await file(chart);
    if (await f.exists()) await f.delete();
  }

  Expression<bool> _annotationsFor(
    $ChartAnnotationsTable a,
    int chartId,
    int? flightId,
  ) =>
      a.chartId.equals(chartId) &
      (flightId == null ? a.flightId.isNull() : a.flightId.equals(flightId));

  /// Encoded strokes per page.
  Future<Map<int, String>> annotations(int chartId, int? flightId) async {
    final rows = await (_db.select(
      _db.chartAnnotations,
    )..where((a) => _annotationsFor(a, chartId, flightId))).get();
    return {for (final r in rows) r.page: r.strokes};
  }

  Future<void> saveAnnotations(
    int chartId,
    int? flightId,
    int page,
    String strokes,
  ) => _db.transaction(() async {
    final updated =
        await (_db.update(_db.chartAnnotations)..where(
              (a) =>
                  _annotationsFor(a, chartId, flightId) & a.page.equals(page),
            ))
            .write(ChartAnnotationsCompanion(strokes: Value(strokes)));
    if (updated == 0) {
      await _db
          .into(_db.chartAnnotations)
          .insert(
            ChartAnnotationsCompanion.insert(
              chartId: chartId,
              flightId: Value(flightId),
              page: page,
              strokes: Value(strokes),
            ),
          );
    }
  });
}
