import '../db/tables.dart';

final _separators = RegExp(r'[^A-Za-z0-9ÄÖÜäöü]+');

List<String> _tokens(String s) => [
  for (final t in s.toUpperCase().split(_separators))
    if (t.isNotEmpty) t,
];

const _rules = <(ChartCategory, List<String>)>[
  (ChartCategory.vfr, ['VFR', 'VAC', 'SICHTANFLUG', 'SICHTANFLUGKARTE']),
  (ChartCategory.departure, ['SID', 'SIDS', 'DEPARTURE', 'DEP', 'ABFLUG']),
  (ChartCategory.arrival, ['STAR', 'STARS', 'ARRIVAL', 'ARR', 'ANKUNFT']),
  (
    ChartCategory.approach,
    [
      'ILS',
      'LOC',
      'RNAV',
      'RNP',
      'VOR',
      'NDB',
      'GLS',
      'LPV',
      'IAC',
      'APP',
      'APPROACH',
      'ANFLUG',
      'INSTRUMENTENANFLUG',
      'IAP',
    ],
  ),
  (
    ChartCategory.ground,
    [
      'GND',
      'GROUND',
      'TAXI',
      'PARKING',
      'APRON',
      'STAND',
      'STANDS',
      'PDC',
      'DOCKING',
      'ROLLKARTE',
      'ROLLWEG',
      'VORFELD',
      'GMC',
    ],
  ),
  (
    ChartCategory.airport,
    [
      'ADC',
      'AD',
      'AERODROME',
      'AIRPORT',
      'FLUGPLATZKARTE',
      'FLUGHAFENKARTE',
      'FLUGPLATZ',
      'FLUGHAFEN',
    ],
  ),
];

/// Best guess of a chart's category from its file name, e.g.
/// `EDDF_ILS_25R.pdf` → approach, `EDFE-VFR.pdf` → VFR.
ChartCategory guessChartCategory(String fileName) {
  final tokens = _tokens(_stripExtension(fileName)).toSet();
  for (final (category, words) in _rules) {
    if (words.any(tokens.contains)) return category;
  }
  return ChartCategory.other;
}

/// A readable chart name from a file name: no extension, separators as
/// spaces.
String chartNameFromFile(String fileName) =>
    _stripExtension(fileName)
        .split(RegExp(r'[_\s]+|(?<=\S)-(?=\S)'))
        .where((p) => p.isNotEmpty)
        .join(' ');

/// The first 4-letter token of [fileName] that is one of [idents].
String? guessAirportIdent(String fileName, Iterable<String> idents) {
  final set = {for (final i in idents) i.toUpperCase()};
  for (final t in _tokens(_stripExtension(fileName))) {
    if (set.contains(t)) return t;
  }
  return null;
}

ChartFileType? chartFileType(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  return switch (ext) {
    'pdf' => ChartFileType.pdf,
    'png' || 'jpg' || 'jpeg' || 'webp' => ChartFileType.image,
    _ => null,
  };
}

const chartFileExtensions = ['pdf', 'png', 'jpg', 'jpeg', 'webp'];

String _stripExtension(String fileName) {
  final name = fileName.split(RegExp(r'[/\\]')).last;
  final dot = name.lastIndexOf('.');
  return dot > 0 ? name.substring(0, dot) : name;
}
