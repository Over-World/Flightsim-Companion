import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/drift.dart';
import 'package:flightsim_companion/data/charts/chart_document.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:flightsim_companion/data/sim/sim_snapshot.dart';
import 'package:flightsim_companion/features/sim/sim_controller.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Egelsbach, Mainz-Finthen and the Frankfurt VOR with a few frequencies.
Future<void> insertNavdataFixtures(AppDatabase db) async {
  await db.batch((b) {
    b.insertAll(db.airports, [
      AirportsCompanion.insert(
        id: const Value(2283),
        ident: 'EDFE',
        type: 'small_airport',
        name: 'Frankfurt-Egelsbach Airport',
        latitude: 49.96,
        longitude: 8.6458,
        isoCountry: 'DE',
        isoRegion: 'DE-HE',
      ),
      AirportsCompanion.insert(
        id: const Value(2290),
        ident: 'EDFZ',
        type: 'small_airport',
        name: 'Mainz-Finthen Airport',
        latitude: 49.9675,
        longitude: 8.1475,
        isoCountry: 'DE',
        isoRegion: 'DE-RP',
      ),
    ]);
    b.insertAll(db.airportFrequencies, [
      AirportFrequenciesCompanion.insert(
        id: const Value(1),
        airportId: 2283,
        type: 'INFO',
        frequencyMhz: 118.405,
      ),
      AirportFrequenciesCompanion.insert(
        id: const Value(2),
        airportId: 2290,
        type: 'INFO',
        frequencyMhz: 122.880,
      ),
    ]);
    b.insertAll(db.runways, [
      RunwaysCompanion.insert(
        id: const Value(1),
        airportId: 2283,
        lengthFt: const Value(4600),
        surface: const Value('ASP'),
        lighted: true,
        closed: false,
        leIdent: const Value('08'),
        leHeadingTrue: const Value(84),
        leElevationFt: const Value(384),
        heIdent: const Value('26'),
        heHeadingTrue: const Value(264),
        heElevationFt: const Value(380),
      ),
      RunwaysCompanion.insert(
        id: const Value(2),
        airportId: 2290,
        lengthFt: const Value(3500),
        surface: const Value('ASP'),
        lighted: false,
        closed: false,
        leIdent: const Value('08'),
        heIdent: const Value('26'),
      ),
    ]);
    b.insert(
      db.navaids,
      NavaidsCompanion.insert(
        id: const Value(85093),
        ident: 'FFM',
        name: 'Frankfurt',
        type: 'VOR-DME',
        frequencyKhz: const Value(114200),
        latitude: 50.0536,
        longitude: 8.6372,
        isoCountry: 'DE',
      ),
    );
  });
}

/// EDFE → FFM → EDFZ with the default C172 (id 1).
Future<int> createFixtureFlight(FlightRepository flights) async {
  const airport = Airport.new;
  final id = await flights.createFlight(
    rules: FlightRules.vfr,
    departure: airport(
      id: 2283,
      ident: 'EDFE',
      type: 'small_airport',
      name: 'Frankfurt-Egelsbach Airport',
      latitude: 49.96,
      longitude: 8.6458,
      isoCountry: 'DE',
      isoRegion: 'DE-HE',
    ),
    destination: airport(
      id: 2290,
      ident: 'EDFZ',
      type: 'small_airport',
      name: 'Mainz-Finthen Airport',
      latitude: 49.9675,
      longitude: 8.1475,
      isoCountry: 'DE',
      isoRegion: 'DE-RP',
    ),
    aircraftId: 1,
    cruiseAltitudeFt: 3500,
  );
  await flights.insertWaypoint(
    id,
    FlightWaypointsCompanion.insert(
      flightId: id,
      sequence: 0,
      kind: WaypointKind.navaid,
      refId: const Value(85093),
      ident: 'FFM',
      name: const Value('Frankfurt VOR-DME'),
      latitude: 50.0536,
      longitude: 8.6372,
    ),
  );
  return id;
}

/// Fake aviationweather.gov: a METAR for EDDF (also found by area search,
/// so EDFE gets it as nearest station), nothing else.
http.Client fakeWeatherClient() => MockClient((request) async {
  final q = request.url.queryParameters;
  final kind = request.url.pathSegments.last;
  if (kind == 'metar' && (q['ids'] == 'EDDF' || q['bbox'] != null)) {
    return http.Response(
      jsonEncode([
        {
          'icaoId': 'EDDF',
          'obsTime': DateTime.now().millisecondsSinceEpoch ~/ 1000 - 600,
          'temp': 10,
          'dewp': 8,
          'wdir': 220,
          'wspd': 17,
          'visib': '6+',
          'altim': 989,
          'rawOb': 'METAR EDDF 180820Z 22017KT 9999 FEW021 10/08 Q0989',
          'lat': 50.045,
          'lon': 8.598,
          'clouds': [
            {'cover': 'FEW', 'base': 2100},
          ],
          'fltCat': 'VFR',
        },
      ]),
      200,
    );
  }
  return http.Response('', 204);
});

/// Chart files without the platform picker or PDFium: [pick] returns
/// [next], every document has [pageCount] pages showing [image].
class FakeChartFiles extends ChartFileAccess {
  List<PickedChartFile> next = [];
  ui.Image? image;
  int pageCount = 2;

  @override
  Future<List<PickedChartFile>> pick() async => next;

  @override
  Future<ChartDocument> open(File file, ChartFileType type) async =>
      _FakeChartDocument(image!, pageCount);
}

class _FakeChartDocument implements ChartDocument {
  _FakeChartDocument(this.image, this.pageCount);

  final ui.Image image;

  @override
  final int pageCount;

  @override
  ui.Size pageSize(int page) => const ui.Size(600, 800);

  @override
  Future<ui.Image> render(int page, int maxPixels) async => image.clone();

  @override
  Future<void> dispose() async {}
}

/// A simulator session driven by the test: [send] pushes snapshots,
/// [tuned] records radio changes.
class FakeSimSession implements SimSession {
  final _snapshots = StreamController<SimSnapshot>.broadcast();
  final _done = Completer<Object?>();
  final tuned = <(SimRadio, int, bool)>[];
  SimSnapshot? latest;

  void send(SimSnapshot s) {
    latest = s;
    _snapshots.add(s);
  }

  void drop() {
    if (!_done.isCompleted) _done.complete();
  }

  @override
  String? get version => '12.1.4';
  @override
  Stream<SimSnapshot> get snapshots => _snapshots.stream;
  @override
  Future<Object?> get done => _done.future;
  @override
  bool tune(SimRadio radio, int khz, {required bool standby}) {
    tuned.add((radio, khz, standby));
    return true;
  }

  @override
  bool swap(SimRadio radio) => tune(radio, 0, standby: false);
  @override
  Future<void> close() async => drop();
}

/// Snapshot with radios tuned like a C172 at Egelsbach.
SimSnapshot simAt(
  double lat,
  double lon, {
  bool onGround = true,
  double gs = 0,
  double vs = 0,
  double g = 1,
  bool parkingBrake = false,
  bool engine = true,
}) => SimSnapshot(
  latitude: lat,
  longitude: lon,
  altitudeFt: onGround ? 400 : 3500,
  groundSpeedKt: gs,
  verticalSpeedFpm: vs,
  gLoad: g,
  onGround: onGround,
  parkingBrake: parkingBrake,
  engineRunning: engine,
  radios: {
    SimRadio.com1: RadioTuning(active: 119150, standby: 121730),
    SimRadio.nav1: RadioTuning(active: 114200, standby: 115900),
  },
);
