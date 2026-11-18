import 'package:flightsim_companion/core/runways.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // EDFE: 08/26, plus a parallel grass strip and a helipad.
  const runways = [
    RunwayData(
      leIdent: '08',
      leHeadingTrue: 84,
      leElevationFt: 384,
      heIdent: '26',
      heHeadingTrue: 264,
      heElevationFt: 380,
      lengthFt: 4600,
      surface: 'ASP',
      lighted: true,
    ),
    RunwayData(leIdent: '08R', heIdent: '26L', lengthFt: 2200, surface: 'GRS'),
    RunwayData(leIdent: 'H1', lengthFt: 60),
  ];

  List<RunwayEnd> ends() => runwayEnds(
    runways,
    latitude: 49.96,
    longitude: 8.65,
    airportElevationFt: 384,
    variation: 4,
  );

  test('splits runways into ends and skips helipads', () {
    final e = ends();
    expect(e.map((r) => r.ident), ['08', '08R', '26', '26L']);
    final r26 = e.firstWhere((r) => r.ident == '26');
    expect(r26.magneticHeading, closeTo(260, 1e-9));
    expect(r26.patternAltitudeFt, 1380);
    // Missing true heading derived from the designator and variation.
    final grass = e.firstWhere((r) => r.ident == '26L');
    expect(grass.trueHeading, closeTo(264, 1e-9));
    expect(grass.elevationFt, 384);
  });

  test('suggests the runway with most headwind, longer one on ties', () {
    expect(suggestRunway(ends(), windFrom: 250, windSpeed: 15)!.ident, '26');
    expect(suggestRunway(ends(), windFrom: 100, windSpeed: 10)!.ident, '08');
    expect(suggestRunway(ends(), windFrom: 250, windSpeed: 2), isNull);
  });

  test('wind components per runway end', () {
    final w = runwayWinds(ends(), windFrom: 300, windSpeed: 20);
    final r26 = w.firstWhere((x) => x.end.ident == '26');
    expect(r26.headwind, closeTo(16.2, 0.1));
    expect(r26.crosswind, closeTo(11.8, 0.1));
    final r08 = w.firstWhere((x) => x.end.ident == '08');
    expect(r08.headwind, lessThan(0));
  });
}
