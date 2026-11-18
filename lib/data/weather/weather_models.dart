import 'dart:convert';

/// Flight category as reported by aviationweather.gov.
enum FlightCategory { vfr, mvfr, ifr, lifr, unknown }

class CloudLayer {
  const CloudLayer(this.cover, this.baseFt);

  /// FEW, SCT, BKN, OVC, VV, CLR, SKC, CAVOK, ...
  final String cover;
  final int? baseFt;

  bool get isCeiling => cover == 'BKN' || cover == 'OVC' || cover == 'VV';
}

/// Decoded METAR (aviationweather.gov JSON). Wind direction is true.
class Metar {
  const Metar({
    required this.station,
    required this.raw,
    required this.observed,
    this.name,
    this.latitude,
    this.longitude,
    this.windDirection,
    this.windVariable = false,
    this.windSpeedKt,
    this.gustKt,
    this.visibility,
    this.temperatureC,
    this.dewpointC,
    this.qnhHpa,
    this.weather,
    this.clouds = const [],
    this.category = FlightCategory.unknown,
  });

  final String station;
  final String raw;
  final DateTime observed;
  final String? name;
  final double? latitude;
  final double? longitude;

  /// `null` when variable (VRB) or missing.
  final int? windDirection;
  final bool windVariable;
  final int? windSpeedKt;
  final int? gustKt;

  /// Statute miles as reported: a number or `6+` (≥ 10 km).
  final String? visibility;
  final double? temperatureC;
  final double? dewpointC;
  final double? qnhHpa;
  final String? weather;
  final List<CloudLayer> clouds;
  final FlightCategory category;

  bool get hasUsableWind => windDirection != null && windSpeedKt != null;

  CloudLayer? get ceiling => clouds.where((c) => c.isCeiling).firstOrNull;

  /// Visibility in metres; `null` for "6+" (10 km or more) or unknown.
  int? get visibilityMeters {
    final v = visibility;
    if (v == null || v.endsWith('+')) return null;
    final sm = double.tryParse(v);
    return sm == null ? null : (sm * 1609.344 / 100).round() * 100;
  }

  bool get visibilityTenKmOrMore => visibility?.endsWith('+') ?? false;

  factory Metar.fromJson(Map<String, dynamic> json) {
    final wdir = json['wdir'];
    return Metar(
      station: json['icaoId'] as String,
      raw: (json['rawOb'] as String?) ?? '',
      observed: DateTime.fromMillisecondsSinceEpoch(
        ((json['obsTime'] as num?) ?? 0).toInt() * 1000,
        isUtc: true,
      ),
      name: json['name'] as String?,
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['lon'] as num?)?.toDouble(),
      windDirection: wdir is num ? wdir.toInt() : null,
      windVariable: wdir == 'VRB',
      windSpeedKt: (json['wspd'] as num?)?.toInt(),
      gustKt: (json['wgst'] as num?)?.toInt(),
      visibility: json['visib']?.toString(),
      temperatureC: (json['temp'] as num?)?.toDouble(),
      dewpointC: (json['dewp'] as num?)?.toDouble(),
      qnhHpa: (json['altim'] as num?)?.toDouble(),
      weather: json['wxString'] as String?,
      clouds: [
        for (final c in (json['clouds'] as List?) ?? const [])
          if (c is Map && c['cover'] != null)
            CloudLayer(c['cover'] as String, (c['base'] as num?)?.toInt()),
      ],
      category: switch (json['fltCat']) {
        'VFR' => FlightCategory.vfr,
        'MVFR' => FlightCategory.mvfr,
        'IFR' => FlightCategory.ifr,
        'LIFR' => FlightCategory.lifr,
        _ => FlightCategory.unknown,
      },
    );
  }
}

class Taf {
  const Taf({
    required this.station,
    required this.raw,
    this.validFrom,
    this.validTo,
  });

  final String station;
  final String raw;
  final DateTime? validFrom;
  final DateTime? validTo;

  factory Taf.fromJson(Map<String, dynamic> json) {
    DateTime? time(Object? v) => v is num
        ? DateTime.fromMillisecondsSinceEpoch(v.toInt() * 1000, isUtc: true)
        : null;
    return Taf(
      station: json['icaoId'] as String,
      raw: (json['rawTAF'] as String?) ?? '',
      validFrom: time(json['validTimeFrom']),
      validTo: time(json['validTimeTo']),
    );
  }
}

/// Weather for an airport: its own reports or those of the nearest station.
class WeatherReport {
  const WeatherReport({
    required this.airportIdent,
    required this.fetchedAt,
    this.metar,
    this.taf,
    this.distanceNm = 0,
    this.metarJson,
    this.tafJson,
  });

  final String airportIdent;
  final DateTime fetchedAt;
  final Metar? metar;
  final Taf? taf;

  /// Distance of the reporting station from the airport, 0 = on field.
  final double distanceNm;

  // Raw API objects, kept for the offline cache.
  final Map<String, dynamic>? metarJson;
  final Map<String, dynamic>? tafJson;

  bool get isEmpty => metar == null && taf == null;

  /// Station on (or very near) the airport, so its wind applies there.
  bool get isLocal => distanceNm <= 5;

  String encode() => jsonEncode({
    'airport': airportIdent,
    'fetchedAt': fetchedAt.millisecondsSinceEpoch,
    'distance': distanceNm,
    'metar': metarJson,
    'taf': tafJson,
  });

  static WeatherReport decode(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    final metar = json['metar'] as Map<String, dynamic>?;
    final taf = json['taf'] as Map<String, dynamic>?;
    return WeatherReport(
      airportIdent: json['airport'] as String,
      fetchedAt: DateTime.fromMillisecondsSinceEpoch(json['fetchedAt'] as int),
      distanceNm: (json['distance'] as num).toDouble(),
      metar: metar == null ? null : Metar.fromJson(metar),
      taf: taf == null ? null : Taf.fromJson(taf),
      metarJson: metar,
      tafJson: taf,
    );
  }
}
