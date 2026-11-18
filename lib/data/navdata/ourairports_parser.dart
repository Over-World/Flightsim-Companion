import 'package:csv/csv.dart';
import 'package:drift/drift.dart';

import '../db/database.dart';

/// Parses the OurAirports CSV exports (https://ourairports.com/data/).
///
/// Columns are looked up by header name, so added or reordered columns in
/// future exports don't break the import.
class OurAirportsParser {
  static const excludedAirportTypes = {'closed', 'balloonport'};

  static List<AirportsCompanion> parseAirports(String source) {
    return _rows(source)
        .where((r) => !excludedAirportTypes.contains(r.str('type')))
        .map(
          (r) => AirportsCompanion.insert(
            id: Value(r.integer('id')!),
            ident: r.str('ident')!,
            type: r.str('type')!,
            name: r.str('name') ?? '',
            latitude: r.real('latitude_deg')!,
            longitude: r.real('longitude_deg')!,
            elevationFt: Value(r.integer('elevation_ft')),
            isoCountry: r.str('iso_country') ?? '',
            isoRegion: r.str('iso_region') ?? '',
            municipality: Value(r.str('municipality')),
            icaoCode: Value(r.str('icao_code') ?? r.str('gps_code')),
            iataCode: Value(r.str('iata_code')),
          ),
        )
        .toList();
  }

  static List<RunwaysCompanion> parseRunways(String source) {
    return _rows(source)
        .where((r) => r.integer('airport_ref') != null)
        .map(
          (r) => RunwaysCompanion.insert(
            id: Value(r.integer('id')!),
            airportId: r.integer('airport_ref')!,
            lengthFt: Value(r.integer('length_ft')),
            widthFt: Value(r.integer('width_ft')),
            surface: Value(r.str('surface')),
            lighted: r.str('lighted') == '1',
            closed: r.str('closed') == '1',
            leIdent: Value(r.str('le_ident')),
            leHeadingTrue: Value(r.real('le_heading_degT')),
            leElevationFt: Value(r.integer('le_elevation_ft')),
            leLatitude: Value(r.real('le_latitude_deg')),
            leLongitude: Value(r.real('le_longitude_deg')),
            heIdent: Value(r.str('he_ident')),
            heHeadingTrue: Value(r.real('he_heading_degT')),
            heElevationFt: Value(r.integer('he_elevation_ft')),
            heLatitude: Value(r.real('he_latitude_deg')),
            heLongitude: Value(r.real('he_longitude_deg')),
          ),
        )
        .toList();
  }

  static List<AirportFrequenciesCompanion> parseFrequencies(String source) {
    return _rows(source)
        .where(
          (r) =>
              r.integer('airport_ref') != null &&
              r.real('frequency_mhz') != null,
        )
        .map(
          (r) => AirportFrequenciesCompanion.insert(
            id: Value(r.integer('id')!),
            airportId: r.integer('airport_ref')!,
            type: (r.str('type') ?? '').toUpperCase(),
            description: Value(r.str('description')),
            frequencyMhz: r.real('frequency_mhz')!,
          ),
        )
        .toList();
  }

  static List<NavaidsCompanion> parseNavaids(String source) {
    return _rows(source)
        .where((r) => r.real('latitude_deg') != null)
        .map(
          (r) => NavaidsCompanion.insert(
            id: Value(r.integer('id')!),
            ident: r.str('ident')!,
            name: r.str('name') ?? '',
            type: r.str('type') ?? '',
            frequencyKhz: Value(r.integer('frequency_khz')),
            latitude: r.real('latitude_deg')!,
            longitude: r.real('longitude_deg')!,
            elevationFt: Value(r.integer('elevation_ft')),
            isoCountry: r.str('iso_country') ?? '',
            magneticVariation: Value(r.real('magnetic_variation_deg')),
            associatedAirport: Value(r.str('associated_airport')),
          ),
        )
        .toList();
  }

  static Iterable<_Row> _rows(String source) sync* {
    final rows = csv.decode(source);
    if (rows.isEmpty) return;
    final header = {
      for (var i = 0; i < rows.first.length; i++) '${rows.first[i]}'.trim(): i,
    };
    for (final row in rows.skip(1)) {
      // Trailing blank line or truncated row.
      if (row.length < 2) continue;
      final parsed = _Row(header, row);
      if (parsed.integer('id') == null) continue;
      yield parsed;
    }
  }
}

class _Row {
  _Row(this._header, this._values);

  final Map<String, int> _header;
  final List<dynamic> _values;

  String? str(String column) {
    final i = _header[column];
    if (i == null || i >= _values.length) return null;
    final v = '${_values[i]}'.trim();
    return v.isEmpty ? null : v;
  }

  int? integer(String column) {
    final v = str(column);
    if (v == null) return null;
    return int.tryParse(v) ?? double.tryParse(v)?.round();
  }

  double? real(String column) {
    final v = str(column);
    return v == null ? null : double.tryParse(v);
  }
}
