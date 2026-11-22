import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/nav_math.dart';
import '../db/database.dart';
import 'flight_repository.dart';

/// Logbook totals over a list of entries.
class LogbookTotals {
  const LogbookTotals({
    required this.flights,
    required this.block,
    required this.air,
    required this.landings,
  });

  factory LogbookTotals.of(List<LogbookEntry> entries) {
    var block = Duration.zero;
    var air = Duration.zero;
    var landings = 0;
    for (final e in entries) {
      block += e.blockOnAt.difference(e.blockOffAt);
      if (e.takeoffAt != null && e.landingAt != null) {
        air += e.landingAt!.difference(e.takeoffAt!);
      }
      landings += e.landings;
    }
    return LogbookTotals(
      flights: entries.length,
      block: block,
      air: air,
      landings: landings,
    );
  }

  final int flights;
  final Duration block;
  final Duration air;
  final int landings;
}

/// Length of a recorded track (`[[lat, lon, ...], ...]`) in NM.
double? trackLengthNm(String track) {
  final points = jsonDecode(track);
  if (points is! List || points.length < 2) return null;
  var total = 0.0;
  for (var i = 1; i < points.length; i++) {
    final a = points[i - 1] as List;
    final b = points[i] as List;
    total += distanceNm(
      (a[0] as num).toDouble(),
      (a[1] as num).toDouble(),
      (b[0] as num).toDouble(),
      (b[1] as num).toDouble(),
    );
  }
  return total;
}

class LogbookRepository {
  LogbookRepository(this._db);

  final AppDatabase _db;

  Stream<List<LogbookEntry>> watchAll() => (_db.select(
    _db.logbookEntries,
  )..orderBy([(e) => OrderingTerm.desc(e.blockOffAt)])).watch();

  Future<LogbookEntry?> byId(int id) => (_db.select(
    _db.logbookEntries,
  )..where((e) => e.id.equals(id))).getSingleOrNull();

  /// Writes (or rewrites) the entry of a blocked-on flight. Does nothing
  /// while block off or block on is missing.
  Future<void> recordFlight(FlightWithRoute data) async {
    final f = data.flight;
    final off = f.blockOffAt ?? f.takeoffAt;
    final on = f.blockOnAt;
    if (off == null || on == null) return;
    final entry = LogbookEntriesCompanion.insert(
      flightId: Value(f.id),
      rules: f.rules,
      departureIdent: f.departureIdent,
      destinationIdent: f.destinationIdent,
      aircraftName: Value(data.aircraft?.name),
      aircraftType: Value(data.aircraft?.icaoType),
      blockOffAt: off,
      takeoffAt: Value(f.takeoffAt),
      landingAt: Value(f.landingAt),
      blockOnAt: on,
      landings: Value(f.landingAt == null ? 0 : 1),
      distanceNm: Value(trackLengthNm(f.track) ?? data.navlog?.totalDistanceNm),
      touchdownFpm: Value(f.touchdownFpm),
      touchdownG: Value(f.touchdownG),
      track: Value(f.track),
    );
    await _db.transaction(() async {
      final existing = await (_db.select(
        _db.logbookEntries,
      )..where((e) => e.flightId.equals(f.id))).getSingleOrNull();
      if (existing == null) {
        await _db.into(_db.logbookEntries).insert(entry);
      } else {
        await (_db.update(_db.logbookEntries)
              ..where((e) => e.id.equals(existing.id)))
            .write(entry.copyWith(remarks: Value(existing.remarks)));
      }
    });
  }

  /// Removes the entry of a flight, e.g. when block on is undone.
  Future<void> removeFlight(int flightId) => (_db.delete(
    _db.logbookEntries,
  )..where((e) => e.flightId.equals(flightId))).go();

  Future<void> setRemarks(int id, String remarks) =>
      (_db.update(_db.logbookEntries)..where((e) => e.id.equals(id))).write(
        LogbookEntriesCompanion(remarks: Value(remarks.trim())),
      );

  Future<void> delete(int id) =>
      (_db.delete(_db.logbookEntries)..where((e) => e.id.equals(id))).go();
}
