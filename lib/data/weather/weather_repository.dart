import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../../core/nav_math.dart';
import '../db/database.dart';
import 'weather_models.dart';

class WeatherException implements Exception {
  const WeatherException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// METAR/TAF from aviationweather.gov (no key needed), cached in the
/// database so the last reports stay available offline in flight.
class WeatherRepository {
  WeatherRepository(this._db, {http.Client? client})
    : _client = client ?? http.Client();

  static const _base = 'https://aviationweather.gov/api/data';

  /// Reports younger than this are served from the cache.
  static const maxAge = Duration(minutes: 10);

  /// Search radius for a substitute station when an airport has no METAR.
  static const nearbyRadiusNm = 40.0;

  final AppDatabase _db;
  final http.Client _client;
  final _inFlight = <String, Future<WeatherReport>>{};

  Future<WeatherReport?> cached(String airportIdent) async {
    final row = await (_db.select(
      _db.weatherCache,
    )..where((w) => w.airportIdent.equals(airportIdent))).getSingleOrNull();
    return row == null ? null : WeatherReport.decode(row.payload);
  }

  /// Fresh-enough cached report, otherwise fetched. Falls back to the
  /// cache (however old) when offline; throws only without any data.
  Future<WeatherReport> weatherFor(Airport airport, {bool force = false}) {
    return _inFlight.putIfAbsent(airport.ident, () async {
      try {
        final cachedReport = await cached(airport.ident);
        if (!force &&
            cachedReport != null &&
            DateTime.now().difference(cachedReport.fetchedAt) < maxAge) {
          return cachedReport;
        }
        try {
          final report = await _fetch(airport);
          await _db
              .into(_db.weatherCache)
              .insertOnConflictUpdate(
                WeatherCacheCompanion.insert(
                  airportIdent: airport.ident,
                  payload: report.encode(),
                  fetchedAt: report.fetchedAt,
                ),
              );
          return report;
        } on Exception {
          if (cachedReport != null) return cachedReport;
          rethrow;
        }
      } finally {
        _inFlight.remove(airport.ident);
      }
    });
  }

  Future<WeatherReport> _fetch(Airport airport) async {
    final codes = {
      airport.ident,
      if (airport.icaoCode != null) airport.icaoCode!,
    }.where((c) => RegExp(r'^[A-Z0-9]{4}$').hasMatch(c)).toList();

    var metars = codes.isEmpty
        ? const <Map<String, dynamic>>[]
        : await _get('metar', {'ids': codes.join(',')});
    var distance = 0.0;
    if (metars.isEmpty) {
      // No own METAR (typical for small airfields): nearest station.
      final dLat = nearbyRadiusNm / 60;
      final dLon =
          nearbyRadiusNm /
          (60 * math.max(0.1, math.cos(airport.latitude * math.pi / 180)));
      final nearby = await _get('metar', {
        'bbox': [
          airport.latitude - dLat,
          airport.longitude - dLon,
          airport.latitude + dLat,
          airport.longitude + dLon,
        ].map((v) => v.toStringAsFixed(3)).join(','),
      });
      final ranked = [
        for (final m in nearby)
          if (m['lat'] is num && m['lon'] is num)
            (
              json: m,
              d: distanceNm(
                airport.latitude,
                airport.longitude,
                (m['lat'] as num).toDouble(),
                (m['lon'] as num).toDouble(),
              ),
            ),
      ]..sort((a, b) => a.d.compareTo(b.d));
      if (ranked.isNotEmpty && ranked.first.d <= nearbyRadiusNm) {
        metars = [ranked.first.json];
        distance = ranked.first.d;
      }
    }
    final metar = metars.firstOrNull;
    final station = metar?['icaoId'] as String? ?? codes.firstOrNull;
    final tafs = station == null
        ? const <Map<String, dynamic>>[]
        : await _get('taf', {'ids': station});
    final taf = tafs.firstOrNull;
    return WeatherReport(
      airportIdent: airport.ident,
      fetchedAt: DateTime.now(),
      distanceNm: distance,
      metar: metar == null ? null : Metar.fromJson(metar),
      taf: taf == null ? null : Taf.fromJson(taf),
      metarJson: metar,
      tafJson: taf,
    );
  }

  Future<List<Map<String, dynamic>>> _get(
    String kind,
    Map<String, String> params,
  ) async {
    final uri = Uri.parse('$_base/$kind')
        .replace(queryParameters: {...params, 'format': 'json'});
    final http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const WeatherException('timeout');
    } on http.ClientException catch (e) {
      throw WeatherException(e.message);
    }
    // 204: no reports for this query.
    if (response.statusCode == 204 || response.body.trim().isEmpty) {
      return const [];
    }
    if (response.statusCode != 200) {
      throw WeatherException('HTTP ${response.statusCode}');
    }
    final json = jsonDecode(response.body);
    return json is List ? json.whereType<Map<String, dynamic>>().toList() : [];
  }
}
