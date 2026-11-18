import 'package:drift/drift.dart';

import '../db/database.dart';

/// Handwritten notepad pages, per flight or general (`flightId == null`).
class NotesRepository {
  NotesRepository(this._db);

  final AppDatabase _db;

  Expression<bool> _forFlight($ScratchPagesTable p, int? flightId) =>
      flightId == null ? p.flightId.isNull() : p.flightId.equals(flightId);

  Stream<List<ScratchPage>> watchPages(int? flightId) =>
      (_db.select(_db.scratchPages)
            ..where((p) => _forFlight(p, flightId))
            ..orderBy([(p) => OrderingTerm.asc(p.sequence)]))
          .watch();

  Future<int> addPage(int? flightId, PageBackground background) async {
    final pages = await (_db.select(
      _db.scratchPages,
    )..where((p) => _forFlight(p, flightId))).get();
    final next = pages.isEmpty
        ? 0
        : pages.map((p) => p.sequence).reduce((a, b) => a > b ? a : b) + 1;
    return _db
        .into(_db.scratchPages)
        .insert(
          ScratchPagesCompanion.insert(
            flightId: Value(flightId),
            sequence: next,
            background: Value(background),
          ),
        );
  }

  Future<void> saveStrokes(int pageId, String strokes) =>
      (_db.update(_db.scratchPages)..where((p) => p.id.equals(pageId))).write(
        ScratchPagesCompanion(
          strokes: Value(strokes),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> setBackground(int pageId, PageBackground background) =>
      (_db.update(_db.scratchPages)..where((p) => p.id.equals(pageId))).write(
        ScratchPagesCompanion(background: Value(background)),
      );

  Future<void> deletePage(int pageId) =>
      (_db.delete(_db.scratchPages)..where((p) => p.id.equals(pageId))).go();
}
