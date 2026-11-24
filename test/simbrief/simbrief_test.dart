import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/repositories/aircraft_repository.dart';
import 'package:flightsim_companion/data/repositories/flight_repository.dart';
import 'package:flightsim_companion/data/simbrief/simbrief_client.dart';
import 'package:flightsim_companion/data/simbrief/simbrief_ofp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../fixtures.dart';
import 'ofp_fixture.dart';

void main() {
  group('SimbriefOfp', () {
    test('parses an OFP', () {
      final ofp = SimbriefOfp.fromJson(ofpJson());
      expect(ofp.callsign, 'DLH100');
      expect(ofp.origin.icao, 'EDDF');
      expect(ofp.origin.runway, '25C');
      expect(ofp.destination.runway, '26R');
      expect(ofp.alternate, 'EDDN');
      expect(ofp.aircraftIcao, 'A20N');
      expect(ofp.cruiseAltitudeFt, 26000);
      expect(ofp.enrouteTime, const Duration(minutes: 49));
      expect(ofp.generatedAt!.millisecondsSinceEpoch, 1795526400000);
      expect(ofp.fuel.ramp, 4820);
      expect(ofp.fixes, hasLength(8));
      expect(ofp.fixes[3].ident, 'DKB');
      expect(ofp.fixes[3].isNavaid, isTrue);
      expect(ofp.fixes[3].frequency, '117.80');
      expect(ofp.fixes[3].windSpeedKt, 45);
      expect(ofp.sid, 'ULKI1G');
      expect(ofp.star, 'ROKI1A');
    });

    test('converts pounds to kilograms', () {
      final ofp = SimbriefOfp.fromJson(ofpJson(units: 'lbs'));
      expect(ofp.fuel.ramp, closeTo(4820 * 0.45359237, 1e-6));
      expect(ofp.fixes.first.fuelFlowKgph, closeTo(3600 * 0.45359237, 1e-6));
    });

    test('empty values and a missing alternate', () {
      final ofp = SimbriefOfp.fromJson(ofpJson(turbine: false));
      expect(ofp.alternate, isNull);
      expect(ofp.costIndex, '');
      expect(ofp.callsign, 'DEABC');
      expect(ofp.sid, isNull);
      expect(ofp.fixes.first.frequency, '114.20');
      expect(ofp.fixes[1].frequency, isNull);
    });

    test('reports SimBrief errors', () {
      expect(
        () => SimbriefOfp.parseResponse(
          jsonEncode({
            'fetch': {'status': 'Error: Unknown UserID'},
          }),
        ),
        throwsA(
          isA<SimbriefException>().having(
            (e) => e.message,
            'message',
            'Error: Unknown UserID',
          ),
        ),
      );
      expect(
        () => SimbriefOfp.parseResponse(
          '<OFP><fetch><status>Error: Unknown UserID</status></fetch></OFP>',
        ),
        throwsA(isA<SimbriefException>()),
      );
      expect(
        () => SimbriefOfp.parseResponse('{"fetch":{"status":"Success"}}'),
        throwsA(isA<SimbriefException>()),
      );
    });

    test('summary round trip', () {
      final summary = OfpSummary.of(SimbriefOfp.fromJson(ofpJson()));
      final back = OfpSummary.decode(summary.encode())!;
      expect(back.requestId, '123456789');
      expect(back.callsign, 'DLH100');
      expect(back.sid, 'ULKI1G');
      expect(back.blockKg, 4820);
      expect(back.enrouteTime, const Duration(minutes: 49));
      expect(back.generatedAt!.millisecondsSinceEpoch, 1795526400000);
      expect(OfpSummary.decode(null), isNull);
      expect(OfpSummary.decode('nonsense'), isNull);
    });
  });

  group('SimbriefClient', () {
    test('uses userid for pilot IDs and username otherwise', () {
      expect(SimbriefClient.latestOfpUri('123456').queryParameters, {
        'userid': '123456',
        'json': '1',
      });
      expect(SimbriefClient.latestOfpUri(' pilot ').queryParameters, {
        'username': 'pilot',
        'json': '1',
      });
    });

    test('fetches the OFP and maps errors', () async {
      var status = 200;
      final client = SimbriefClient(
        client: MockClient((request) async {
          if (status == 0) throw http.ClientException('offline');
          return status == 200
              ? http.Response(ofpBody(), 200)
              : http.Response(
                  '{"fetch":{"status":"Error: Unknown UserID"}}',
                  400,
                );
        }),
      );
      expect((await client.latestOfp('pilot')).callsign, 'DLH100');
      status = 400;
      await expectLater(
        client.latestOfp('nobody'),
        throwsA(isA<SimbriefException>()),
      );
      status = 0;
      await expectLater(
        client.latestOfp('pilot'),
        throwsA(isA<SimbriefOfflineException>()),
      );
    });
  });

  group('importOfp', () {
    late AppDatabase db;
    late FlightRepository flights;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      await AircraftRepository(db).seedDefaults();
      await insertNavdataFixtures(db);
      flights = FlightRepository(db);
    });
    tearDown(() => db.close());

    test('airliner without navdata: route, fuel and a new profile', () async {
      final ofp = SimbriefOfp.fromJson(ofpJson());
      final profilesBefore = await db.select(db.aircraftProfiles).get();
      final id = await flights.importOfp(ofp);
      final data = (await flights.loadFlight(id))!;
      final f = data.flight;

      expect(f.rules, FlightRules.ifr);
      expect(f.title, 'DLH100 · EDDF – EDDM');
      expect(f.departureRunway, '25C');
      expect(f.arrivalRunway, '26R');
      expect(f.alternateIdent, 'EDDN');
      expect(f.cruiseAltitudeFt, 26000);
      expect(f.plannedDeparture!.millisecondsSinceEpoch, 1795530000000);

      // New Jet A-1 profile from the OFP.
      final profiles = await db.select(db.aircraftProfiles).get();
      expect(profiles, hasLength(profilesBefore.length + 1));
      final a = data.aircraft!;
      expect(a.icaoType, 'A20N');
      expect(a.registration, 'DAINA');
      expect(a.fuelType, 'jeta');
      expect(a.cruiseTas, 430);
      expect(a.fuelBurnLph, closeTo(2200 / 0.8, 1e-6));

      // Fuel in litres of Jet A-1.
      expect(f.fuelOnBoardL, closeTo(4820 / 0.8, 1e-6));
      expect(f.taxiFuelL, closeTo(200 / 0.8, 1e-6));
      expect(f.contingencyPercent, 5);
      expect(f.finalReserveMinutes, 30);
      expect(data.alternateFuelL, closeTo(1000 / 0.8, 1e-6));
      expect(data.ofp!.callsign, 'DLH100');

      // Origin + 8 fixes; airports from the OFP positions.
      final w = data.waypoints;
      expect(
        [for (final x in w) x.ident],
        [
          'EDDF',
          'DF155',
          'ULKIG',
          'TOC',
          'DKB',
          'TOD',
          'ROKIL',
          'MBG32',
          'EDDM',
        ],
      );
      expect(w.first.kind, WaypointKind.airport);
      expect(w.first.refId, isNull);
      expect(w.first.latitude, 50.033);
      expect(w[1].via, 'ULKI1G');
      expect(w[1].kind, WaypointKind.fix);
      expect(w[4].kind, WaypointKind.fix, reason: 'no DKB in the navdata');
      expect(w[4].windDirection, 270);
      expect(w[4].tasKt, 432);
      expect(w[4].fuelFlowLph, closeTo(2200 / 0.8, 1e-6));
      expect(w.last.via, 'ROKI1A');

      // The navlog uses each leg's TAS and fuel flow.
      final log = data.navlog!;
      expect(log.legs, hasLength(8));
      final first = log.legs.first;
      expect(
        first.fuelL,
        closeTo(first.ete!.inSeconds / 3600 * 3600 / 0.8, 1e-6),
      );
      expect(log.totalTime!.inMinutes, inInclusiveRange(30, 60));
    });

    test('piston OFP uses the matching profile and the navdata', () async {
      final ofp = SimbriefOfp.fromJson(ofpJson(turbine: false));
      final count = (await db.select(db.aircraftProfiles).get()).length;
      final id = await flights.importOfp(ofp);
      final data = (await flights.loadFlight(id))!;
      expect((await db.select(db.aircraftProfiles).get()).length, count);
      expect(data.aircraft!.icaoType, 'C172');
      expect(data.flight.alternateIdent, isNull);

      final w = data.waypoints;
      expect(
        [for (final x in w) x.ident],
        ['EDFE', 'FFM', 'TOC', 'TOD', 'EDFZ'],
      );
      expect(w.first.refId, 2283);
      expect(w[1].kind, WaypointKind.navaid);
      expect(w[1].refId, 85093);
      expect(w[1].name, 'Frankfurt');
      expect(w.last.refId, 2290);
      expect(w.last.name, 'Mainz-Finthen Airport');
      // Avgas: 0.72 kg/L.
      expect(data.flight.fuelOnBoardL, closeTo(120 / 0.72, 1e-6));
    });

    test('finds a flight imported from the same OFP', () async {
      final ofp = SimbriefOfp.fromJson(ofpJson());
      expect(await flights.flightForOfp(ofp.requestId), isNull);
      final id = await flights.importOfp(ofp);
      expect(await flights.flightForOfp(ofp.requestId), id);
      expect(await flights.flightForOfp('other'), isNull);
      expect(await flights.flightForOfp(''), isNull);
    });
  });
}
