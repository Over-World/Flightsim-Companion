import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../../core/nav_math.dart';
import '../db/database.dart';
import '../navdata/navdata_importer.dart';

class AirportDetails {
  const AirportDetails({
    required this.airport,
    required this.runways,
    required this.frequencies,
    required this.navaids,
  });

  final Airport airport;
  final List<Runway> runways;
  final List<AirportFrequency> frequencies;

  /// Nearby navaids with their distance in NM, closest first.
  final List<({Navaid navaid, double distanceNm})> navaids;
}

class NavdataRepository {
  NavdataRepository(this._db);

  final AppDatabase _db;

  static const _typeRank = {
    'large_airport': 0,
    'medium_airport': 1,
    'small_airport': 2,
    'seaplane_base': 3,
    'heliport': 4,
  };

  Future<NavdataCounts> counts() async {
    Future<int> count(TableInfo table) {
      final total = countAll();
      return (_db.selectOnly(
        table,
      )..addColumns([total])).map((r) => r.read(total)!).getSingle();
    }

    return NavdataCounts(
      airports: await count(_db.airports),
      runways: await count(_db.runways),
      frequencies: await count(_db.airportFrequencies),
      navaids: await count(_db.navaids),
    );
  }

  /// Matches ident/ICAO/IATA prefixes and name/city substrings.
  Future<List<Airport>> searchAirports(String query, {int limit = 50}) async {
    final q = query.trim();
    if (q.length < 2) return const [];
    final upper = q.toUpperCase();
    final like = '%$q%';
    final results =
        await (_db.select(_db.airports)
              ..where(
                (a) =>
                    a.ident.like('$upper%') |
                    a.icaoCode.like('$upper%') |
                    a.iataCode.equals(upper) |
                    a.name.like(like) |
                    a.municipality.like(like),
              )
              ..limit(limit * 4))
            .get();
    int rank(Airport a) {
      final exact =
          a.ident == upper || a.icaoCode == upper || a.iataCode == upper;
      final prefix = a.ident.startsWith(upper);
      return (exact
              ? 0
              : prefix
              ? 10
              : 20) +
          (_typeRank[a.type] ?? 5);
    }

    results.sort((a, b) => rank(a).compareTo(rank(b)));
    return results.take(limit).toList();
  }

  Future<List<Navaid>> searchNavaids(String query, {int limit = 30}) async {
    final q = query.trim();
    if (q.length < 2) return const [];
    final upper = q.toUpperCase();
    final results =
        await (_db.select(_db.navaids)
              ..where((n) => n.ident.like('$upper%') | n.name.like('%$q%'))
              ..limit(limit * 3))
            .get();
    results.sort(
      (a, b) => (a.ident == upper ? 0 : 1).compareTo(b.ident == upper ? 0 : 1),
    );
    return results.take(limit).toList();
  }

  Future<List<Navaid>> navaidsByIdent(String ident) => (_db.select(
    _db.navaids,
  )..where((n) => n.ident.equals(ident.toUpperCase()))).get();

  Future<Navaid?> navaidById(int id) => (_db.select(
    _db.navaids,
  )..where((n) => n.id.equals(id))).getSingleOrNull();

  Future<Airport?> airportById(int id) => (_db.select(
    _db.airports,
  )..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<List<AirportFrequency>> frequencies(int airportId) =>
      (_db.select(_db.airportFrequencies)
            ..where((f) => f.airportId.equals(airportId))
            ..orderBy([(f) => OrderingTerm.asc(f.type)]))
          .get();

  Future<Airport?> airportByIdent(String ident) =>
      (_db.select(_db.airports)
            ..where((a) => a.ident.equals(ident.toUpperCase()))
            ..limit(1))
          .getSingleOrNull();

  Future<AirportDetails?> airportDetails(int airportId) async {
    final airport = await (_db.select(
      _db.airports,
    )..where((a) => a.id.equals(airportId))).getSingleOrNull();
    if (airport == null) return null;
    final runways =
        await (_db.select(_db.runways)
              ..where(
                (r) => r.airportId.equals(airportId) & r.closed.equals(false),
              )
              ..orderBy([(r) => OrderingTerm.asc(r.leIdent)]))
            .get();
    final frequencies =
        await (_db.select(_db.airportFrequencies)
              ..where((f) => f.airportId.equals(airportId))
              ..orderBy([(f) => OrderingTerm.asc(f.type)]))
            .get();
    return AirportDetails(
      airport: airport,
      runways: runways,
      frequencies: frequencies,
      navaids: await navaidsNear(airport.latitude, airport.longitude),
    );
  }

  Future<List<({Navaid navaid, double distanceNm})>> navaidsNear(
    double lat,
    double lon, {
    double radiusNm = 40,
    int limit = 10,
  }) async {
    // Bounding box prefilter on the position index, exact distance after.
    final dLat = radiusNm / 60;
    final dLon =
        radiusNm / (60 * math.max(0.01, math.cos(lat * math.pi / 180)));
    final candidates =
        await (_db.select(_db.navaids)..where(
              (n) =>
                  n.latitude.isBetweenValues(lat - dLat, lat + dLat) &
                  n.longitude.isBetweenValues(lon - dLon, lon + dLon),
            ))
            .get();
    final withDistance = [
      for (final n in candidates)
        (navaid: n, distanceNm: distanceNm(lat, lon, n.latitude, n.longitude)),
    ]..removeWhere((e) => e.distanceNm > radiusNm);
    withDistance.sort((a, b) => a.distanceNm.compareTo(b.distanceNm));
    return withDistance.take(limit).toList();
  }
}
