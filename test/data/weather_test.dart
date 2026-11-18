import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/weather/weather_models.dart';
import 'package:flightsim_companion/data/weather/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

// Shapes as returned by aviationweather.gov.
const eddfMetar = {
  'icaoId': 'EDDF',
  'obsTime': 1794990000,
  'temp': 10,
  'dewp': 8,
  'wdir': 220,
  'wspd': 17,
  'wgst': 27,
  'visib': '6+',
  'altim': 989,
  'wxString': 'SHRA',
  'rawOb': 'METAR EDDF 180820Z 22017G27KT 9999 SHRA FEW021 BKN048 10/08 Q0989',
  'lat': 50.045,
  'lon': 8.598,
  'name': 'Frankfurt/Main Arpt, HE, DE',
  'clouds': [
    {'cover': 'FEW', 'base': 2100},
    {'cover': 'BKN', 'base': 4800},
  ],
  'fltCat': 'VFR',
};

const eddfTaf = {
  'icaoId': 'EDDF',
  'validTimeFrom': 1794981600,
  'validTimeTo': 1795089600,
  'rawTAF': 'TAF EDDF 180500Z 1806/1912 22015G25KT 9999 SCT025 BKN040',
};

Airport airport(String ident, double lat, double lon) => Airport(
  id: ident.hashCode,
  ident: ident,
  type: 'small_airport',
  name: ident,
  latitude: lat,
  longitude: lon,
  isoCountry: 'DE',
  isoRegion: 'DE-HE',
);

void main() {
  late AppDatabase db;
  late List<Uri> requests;
  var online = true;

  WeatherRepository repo() => WeatherRepository(
    db,
    client: MockClient((request) async {
      requests.add(request.url);
      if (!online) throw http.ClientException('offline');
      final q = request.url.queryParameters;
      final kind = request.url.pathSegments.last;
      if (kind == 'metar' && q['ids'] == 'EDDF') {
        return http.Response(jsonEncode([eddfMetar]), 200);
      }
      if (kind == 'metar' && q['bbox'] != null) {
        return http.Response(jsonEncode([eddfMetar]), 200);
      }
      if (kind == 'taf' && q['ids'] == 'EDDF') {
        return http.Response(jsonEncode([eddfTaf]), 200);
      }
      return http.Response('', 204);
    }),
  );

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    requests = [];
    online = true;
  });

  tearDown(() => db.close());

  test('decodes METAR and TAF of the airport itself', () async {
    final r = await repo().weatherFor(airport('EDDF', 50.03, 8.57));
    final m = r.metar!;
    expect(r.isLocal, isTrue);
    expect(m.windDirection, 220);
    expect(m.gustKt, 27);
    expect(m.qnhHpa, 989);
    expect(m.visibilityTenKmOrMore, isTrue);
    expect(m.ceiling!.baseFt, 4800);
    expect(m.category, FlightCategory.vfr);
    expect(r.taf!.raw, startsWith('TAF EDDF'));
  });

  test('falls back to the nearest station for small airfields', () async {
    final r = await repo().weatherFor(airport('EDFE', 49.96, 8.6458));
    expect(r.metar!.station, 'EDDF');
    expect(r.distanceNm, closeTo(5.4, 0.1));
    expect(r.isLocal, isFalse);
    expect(requests.any((u) => u.queryParameters.containsKey('bbox')), isTrue);
  });

  test('serves fresh reports from the cache and stale ones offline', () async {
    final eddf = airport('EDDF', 50.03, 8.57);
    await repo().weatherFor(eddf);
    final count = requests.length;
    await repo().weatherFor(eddf);
    expect(requests.length, count, reason: 'fresh cache, no request');

    online = false;
    final offline = await repo().weatherFor(eddf, force: true);
    expect(offline.metar!.station, 'EDDF');
  });

  test('throws when offline without cache', () async {
    online = false;
    expect(
      () => repo().weatherFor(airport('EDDF', 50.03, 8.57)),
      throwsA(isA<WeatherException>()),
    );
  });

  test('variable wind and low visibility', () {
    final m = Metar.fromJson({
      ...eddfMetar,
      'wdir': 'VRB',
      'wspd': 3,
      'visib': 1.5,
      'clouds': [
        {'cover': 'OVC', 'base': 400},
      ],
      'fltCat': 'IFR',
    });
    expect(m.windVariable, isTrue);
    expect(m.hasUsableWind, isFalse);
    expect(m.visibilityMeters, 2400);
    expect(m.category, FlightCategory.ifr);
  });
}
