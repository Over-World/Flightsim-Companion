import 'package:drift/native.dart';
import 'package:flightsim_companion/data/db/database.dart';
import 'package:flightsim_companion/data/navdata/ourairports_parser.dart';
import 'package:flightsim_companion/data/repositories/navdata_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// Trimmed rows in the real OurAirports column layout.
const airportsCsv =
    '"id","ident","type","name","latitude_deg","longitude_deg","elevation_ft",'
    '"continent","iso_country","iso_region","municipality","scheduled_service",'
    '"icao_code","iata_code","gps_code","local_code","home_link",'
    '"wikipedia_link","keywords"\n'
    '2212,"EDDF","large_airport","Frankfurt am Main Airport",50.036249,'
    '8.559294,364,"EU","DE","DE-HE","Frankfurt am Main","yes","EDDF","FRA",'
    '"EDDF","","","",""\n'
    '2283,"EDFE","small_airport","Frankfurt-Egelsbach Airport",49.959999,'
    '8.645833,384,"EU","DE","DE-HE","Egelsbach","no","EDFE","","EDFE","",'
    '"","",""\n'
    '9999,"XXXX","closed","Old Field",50,8,,"EU","DE","DE-HE","","no","","",'
    '"","","","",""\n';

const runwaysCsv =
    '"id","airport_ref","airport_ident","length_ft","width_ft","surface",'
    '"lighted","closed","le_ident","le_latitude_deg","le_longitude_deg",'
    '"le_elevation_ft","le_heading_degT","le_displaced_threshold_ft",'
    '"he_ident","he_latitude_deg","he_longitude_deg","he_elevation_ft",'
    '"he_heading_degT","he_displaced_threshold_ft"\n'
    '244381,2283,"EDFE",4600,66,"ASP",1,0,"09",49.96,8.63,384,92,,"27",'
    '49.96,8.66,384,272,\n';

const frequenciesCsv =
    '"id","airport_ref","airport_ident","type","description","frequency_mhz"\n'
    '60001,2283,"EDFE","INFO","Langen Information",118.4\n'
    '60002,2212,"EDDF","ATIS","Frankfurt ATIS",118.025\n';

const navaidsCsv =
    '"id","filename","ident","name","type","frequency_khz","latitude_deg",'
    '"longitude_deg","elevation_ft","iso_country","dme_frequency_khz",'
    '"dme_channel","dme_latitude_deg","dme_longitude_deg","dme_elevation_ft",'
    '"slaved_variation_deg","magnetic_variation_deg","usageType","power",'
    '"associated_airport"\n'
    '85093,"Frankfurt_VOR-DME_DE","FFM","Frankfurt","VOR-DME",114200,'
    '50.0536,8.6372,400,"DE",,"089X",,,,,2.9,"BOTH","HIGH","EDDF"\n'
    '85999,"Far_NDB","FAR","Far Away","NDB",400,53,13,,"DE",,,,,,,3.5,'
    '"BOTH","LOW",""\n';

void main() {
  group('OurAirportsParser', () {
    test('skips closed airports and maps columns by header', () {
      final airports = OurAirportsParser.parseAirports(airportsCsv);
      expect(airports.map((a) => a.ident.value), ['EDDF', 'EDFE']);
      expect(airports.first.iataCode.value, 'FRA');
      expect(airports.last.elevationFt.value, 384);
    });

    test('runways, frequencies and navaids', () {
      final runway = OurAirportsParser.parseRunways(runwaysCsv).single;
      expect(runway.leIdent.value, '09');
      expect(runway.lighted.value, isTrue);
      expect(runway.heHeadingTrue.value, 272);

      final freqs = OurAirportsParser.parseFrequencies(frequenciesCsv);
      expect(freqs.map((f) => f.frequencyMhz.value), [118.4, 118.025]);

      final navaid = OurAirportsParser.parseNavaids(navaidsCsv).first;
      expect(navaid.frequencyKhz.value, 114200);
      expect(navaid.magneticVariation.value, 2.9);
    });
  });

  group('NavdataRepository', () {
    late AppDatabase db;
    late NavdataRepository repo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repo = NavdataRepository(db);
      await db.batch((b) {
        b.insertAll(db.airports, OurAirportsParser.parseAirports(airportsCsv));
        b.insertAll(db.runways, OurAirportsParser.parseRunways(runwaysCsv));
        b.insertAll(
          db.airportFrequencies,
          OurAirportsParser.parseFrequencies(frequenciesCsv),
        );
        b.insertAll(db.navaids, OurAirportsParser.parseNavaids(navaidsCsv));
      });
    });

    tearDown(() => db.close());

    test('search ranks exact ident and large airports first', () async {
      final byName = await repo.searchAirports('frankfurt');
      expect(byName.map((a) => a.ident), ['EDDF', 'EDFE']);

      final byIata = await repo.searchAirports('fra');
      expect(byIata.first.ident, 'EDDF');

      final byIdent = await repo.searchAirports('EDFE');
      expect(byIdent.first.ident, 'EDFE');
    });

    test('details include runways, frequencies and nearby navaids', () async {
      final details = (await repo.airportDetails(2283))!;
      expect(details.runways, hasLength(1));
      expect(details.frequencies.single.type, 'INFO');
      expect(details.navaids.map((n) => n.navaid.ident), ['FFM']);
      expect(details.navaids.single.distanceNm, closeTo(6, 1));
    });

    test('counts', () async {
      final counts = await repo.counts();
      expect(counts.airports, 2);
      expect(counts.navaids, 2);
    });
  });
}
