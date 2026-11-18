import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../db/database.dart';
import 'ourairports_parser.dart';

enum ImportStage { downloading, parsing, writing, done }

class ImportProgress {
  const ImportProgress(this.stage, this.fraction, [this.file]);

  final ImportStage stage;

  /// Overall progress 0..1.
  final double fraction;
  final String? file;
}

class NavdataCounts {
  const NavdataCounts({
    required this.airports,
    required this.runways,
    required this.frequencies,
    required this.navaids,
  });

  final int airports;
  final int runways;
  final int frequencies;
  final int navaids;
}

/// Downloads the OurAirports exports and replaces the navdata tables.
class NavdataImporter {
  NavdataImporter(this._db, {http.Client? client})
    : _client = client ?? http.Client();

  static const baseUrl = 'https://davidmegginson.github.io/ourairports-data';
  static const files = [
    'airports.csv',
    'runways.csv',
    'airport-frequencies.csv',
    'navaids.csv',
  ];

  final AppDatabase _db;
  final http.Client _client;

  Stream<ImportProgress> run() async* {
    // Downloading is ~70 % of the work, parsing and writing the rest.
    const downloadShare = 0.7;
    final sources = <String, String>{};
    for (var i = 0; i < files.length; i++) {
      final file = files[i];
      await for (final p in _download(file, sources)) {
        yield ImportProgress(
          ImportStage.downloading,
          (i + p) / files.length * downloadShare,
          file,
        );
      }
    }

    yield const ImportProgress(ImportStage.parsing, downloadShare);
    final parsed = await compute(_parseAll, sources);

    yield const ImportProgress(ImportStage.writing, 0.85);
    await _db.transaction(() async {
      await _db.delete(_db.airportFrequencies).go();
      await _db.delete(_db.runways).go();
      await _db.delete(_db.navaids).go();
      await _db.delete(_db.airports).go();
      await _db.batch((b) {
        b.insertAll(_db.airports, parsed.airports);
        b.insertAll(_db.runways, parsed.runways);
        b.insertAll(_db.airportFrequencies, parsed.frequencies);
        b.insertAll(_db.navaids, parsed.navaids);
      });
    });
    yield const ImportProgress(ImportStage.done, 1);
  }

  /// Emits the per-file download fraction and stores the body in [into].
  Stream<double> _download(String file, Map<String, String> into) async* {
    final response = await _client.send(
      http.Request('GET', Uri.parse('$baseUrl/$file')),
    );
    if (response.statusCode != 200) {
      throw http.ClientException(
        'HTTP ${response.statusCode} for $file',
        response.request?.url,
      );
    }
    final total = response.contentLength;
    final bytes = <int>[];
    await for (final chunk in response.stream) {
      bytes.addAll(chunk);
      if (total != null && total > 0) yield bytes.length / total;
    }
    into[file] = utf8.decode(bytes, allowMalformed: true);
    yield 1;
  }
}

typedef _Parsed = ({
  List<AirportsCompanion> airports,
  List<RunwaysCompanion> runways,
  List<AirportFrequenciesCompanion> frequencies,
  List<NavaidsCompanion> navaids,
});

_Parsed _parseAll(Map<String, String> sources) => (
  airports: OurAirportsParser.parseAirports(sources['airports.csv']!),
  runways: OurAirportsParser.parseRunways(sources['runways.csv']!),
  frequencies: OurAirportsParser.parseFrequencies(
    sources['airport-frequencies.csv']!,
  ),
  navaids: OurAirportsParser.parseNavaids(sources['navaids.csv']!),
);
