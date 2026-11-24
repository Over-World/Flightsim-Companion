import 'dart:convert';

/// One fix of the OFP navlog, including TOC/TOD.
class OfpFix {
  const OfpFix({
    required this.ident,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.via,
    required this.sidStar,
    this.altitudeFt,
    this.trueAirspeedKt,
    this.windDirection,
    this.windSpeedKt,
    this.fuelFlowKgph,
    this.frequency,
  });

  final String ident;
  final String name;

  /// SimBrief type: `apt`, `vor`, `ndb`, `wpt`, `ltlg` (TOC/TOD, lat/lon).
  final String type;
  final double latitude;
  final double longitude;

  /// Airway, SID/STAR name or `DCT` on the leg to this fix.
  final String via;
  final bool sidStar;
  final int? altitudeFt;
  final int? trueAirspeedKt;
  final int? windDirection;
  final int? windSpeedKt;

  /// Total fuel flow on the leg to this fix, in kg per hour.
  final double? fuelFlowKgph;

  /// VOR/NDB frequency as written in the OFP (`114.30`, `373`).
  final String? frequency;

  bool get isNavaid => type == 'vor' || type == 'ndb';
  bool get isAirport => type == 'apt';
}

/// The parts of a SimBrief OFP the app uses. All fuel and weights in kg,
/// whatever unit the OFP was planned in.
class SimbriefOfp {
  const SimbriefOfp({
    required this.requestId,
    required this.generatedAt,
    required this.callsign,
    required this.aircraftIcao,
    required this.aircraftName,
    required this.registration,
    required this.origin,
    required this.destination,
    required this.alternate,
    required this.route,
    required this.cruiseAltitudeFt,
    required this.cruiseTasKt,
    required this.costIndex,
    required this.airac,
    required this.scheduledOut,
    required this.enrouteTime,
    required this.fuel,
    required this.emptyWeightKg,
    required this.maxTakeoffWeightKg,
    required this.fixes,
  });

  final String requestId;
  final DateTime? generatedAt;
  final String callsign;
  final String aircraftIcao;
  final String aircraftName;
  final String registration;
  final OfpAirport origin;
  final OfpAirport destination;
  final String? alternate;

  /// ATC route without the airports, e.g. `ANEK1F ANEKI Y163 ... ROXOG1A`.
  final String route;
  final int? cruiseAltitudeFt;
  final int? cruiseTasKt;
  final String costIndex;
  final String airac;
  final DateTime? scheduledOut;
  final Duration? enrouteTime;
  final OfpFuel fuel;
  final double? emptyWeightKg;
  final double? maxTakeoffWeightKg;
  final List<OfpFix> fixes;

  /// SID and STAR names, taken from the fixes flown on them.
  String? get sid => _procedure(fixes);
  String? get star => _procedure(fixes.reversed);

  static String? _procedure(Iterable<OfpFix> fixes) {
    // TOC/TOD and the airports don't belong to the procedure.
    final first = fixes.where(
      (f) => f.ident != 'TOC' && f.ident != 'TOD' && !f.isAirport,
    );
    if (first.isEmpty || !first.first.sidStar) return null;
    final via = first.first.via;
    return via.isEmpty || via == 'DCT' ? null : via;
  }

  /// Parses the JSON from `xml.fetcher.php?json=1`. Throws [FormatException]
  /// when it isn't an OFP.
  factory SimbriefOfp.fromJson(Map<String, dynamic> json) {
    final params = _map(json['params']);
    final general = _map(json['general']);
    final origin = _map(json['origin']);
    final dest = _map(json['destination']);
    final aircraft = _map(json['aircraft']);
    final fuelJson = _map(json['fuel']);
    final weights = _map(json['weights']);
    final times = _map(json['times']);
    final atc = _map(json['atc']);
    final altnList = _list(json['alternate']);
    final altn = altnList.isEmpty
        ? const <String, dynamic>{}
        : _map(altnList.first);

    // SimBrief plans in kg or lb; the app works in kg.
    final toKg = _str(params['units']).toLowerCase().startsWith('lb')
        ? 0.45359237
        : 1.0;
    double? kg(Object? v) {
      final n = _num(v);
      return n == null ? null : n * toKg;
    }

    OfpAirport airport(Map<String, dynamic> a) {
      final icao = _str(a['icao_code']);
      final lat = _num(a['pos_lat']);
      final lon = _num(a['pos_long']);
      if (icao.isEmpty || lat == null || lon == null) {
        throw const FormatException('No origin or destination in the OFP');
      }
      return OfpAirport(
        icao: icao,
        name: _str(a['name']),
        latitude: lat.toDouble(),
        longitude: lon.toDouble(),
        runway: _nonEmpty(a['plan_rwy']),
      );
    }

    final fixes = <OfpFix>[
      for (final f in _list(_map(json['navlog'])['fix']).map(_map))
        if (_num(f['pos_lat']) != null && _num(f['pos_long']) != null)
          OfpFix(
            ident: _str(f['ident']),
            name: _str(f['name']),
            type: _str(f['type']),
            latitude: _num(f['pos_lat'])!.toDouble(),
            longitude: _num(f['pos_long'])!.toDouble(),
            via: _str(f['via_airway']),
            sidStar: _str(f['is_sid_star']) == '1',
            altitudeFt: _int(f['altitude_feet']),
            trueAirspeedKt: _int(f['true_airspeed']),
            windDirection: _int(f['wind_dir']),
            windSpeedKt: _int(f['wind_spd']),
            fuelFlowKgph: kg(f['fuel_flow']),
            frequency: _str(f['frequency']).isEmpty
                ? null
                : _str(f['frequency']),
          ),
    ];

    final callsign = _str(atc['callsign']);
    final airline = _str(general['icao_airline']);
    final number = _str(general['flight_number']);
    return SimbriefOfp(
      requestId: _str(params['request_id']),
      generatedAt: _epoch(params['time_generated']),
      callsign: callsign.isNotEmpty ? callsign : '$airline$number',
      aircraftIcao: _str(aircraft['icaocode']).toUpperCase(),
      aircraftName: _str(aircraft['name']),
      registration: _str(aircraft['reg']),
      origin: airport(origin),
      destination: airport(dest),
      alternate: _nonEmpty(altn['icao_code']),
      route: _str(general['route']),
      cruiseAltitudeFt: _int(general['initial_altitude']),
      cruiseTasKt: _int(general['cruise_tas']),
      costIndex: _str(general['costindex']),
      airac: _str(params['airac']),
      scheduledOut: _epoch(times['sched_out']),
      enrouteTime: switch (_int(times['est_time_enroute'])) {
        final s? => Duration(seconds: s),
        null => null,
      },
      fuel: OfpFuel(
        taxi: kg(fuelJson['taxi']),
        trip: kg(fuelJson['enroute_burn']),
        contingency: kg(fuelJson['contingency']),
        alternate: kg(fuelJson['alternate_burn']),
        finalReserve: kg(fuelJson['reserve']),
        extra: kg(fuelJson['extra']),
        ramp: kg(fuelJson['plan_ramp']),
        takeoff: kg(fuelJson['plan_takeoff']),
        landing: kg(fuelJson['plan_landing']),
        averageFlowKgph: kg(fuelJson['avg_fuel_flow']),
        maxTanks: kg(fuelJson['max_tanks']),
      ),
      emptyWeightKg: kg(weights['oew']),
      maxTakeoffWeightKg: kg(weights['max_tow']),
      fixes: fixes,
    );
  }

  /// Decodes an error or OFP response body; returns the OFP or throws
  /// [SimbriefException] with SimBrief's message.
  static SimbriefOfp parseResponse(String body) {
    Object? json;
    try {
      json = jsonDecode(body);
    } on FormatException {
      // Errors may come as XML even with json=1.
      final status = RegExp(r'<status>([^<]*)</status>').firstMatch(body);
      throw SimbriefException(status?.group(1) ?? 'Unexpected response');
    }
    final map = _map(json);
    final status = _str(_map(map['fetch'])['status']);
    if (status.isNotEmpty && status.toLowerCase() != 'success') {
      throw SimbriefException(status);
    }
    try {
      return SimbriefOfp.fromJson(map);
    } on FormatException catch (e) {
      throw SimbriefException(e.message);
    }
  }
}

class OfpAirport {
  const OfpAirport({
    required this.icao,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.runway,
  });

  final String icao;
  final String name;
  final double latitude;
  final double longitude;

  /// Planned runway, e.g. `25C`.
  final String? runway;
}

class OfpFuel {
  const OfpFuel({
    this.taxi,
    this.trip,
    this.contingency,
    this.alternate,
    this.finalReserve,
    this.extra,
    this.ramp,
    this.takeoff,
    this.landing,
    this.averageFlowKgph,
    this.maxTanks,
  });

  final double? taxi;
  final double? trip;
  final double? contingency;
  final double? alternate;
  final double? finalReserve;
  final double? extra;

  /// Block fuel.
  final double? ramp;
  final double? takeoff;
  final double? landing;
  final double? averageFlowKgph;
  final double? maxTanks;
}

class SimbriefException implements Exception {
  const SimbriefException(this.message);

  /// SimBrief's own message, e.g. `Error: Unknown UserID`.
  final String message;

  @override
  String toString() => 'SimbriefException: $message';
}

/// What the flight keeps from the OFP (`Flights.ofp`), all fuel in kg.
class OfpSummary {
  const OfpSummary({
    required this.requestId,
    required this.callsign,
    required this.route,
    this.generatedAt,
    this.sid,
    this.star,
    this.costIndex = '',
    this.airac = '',
    this.enrouteTime,
    this.tripKg,
    this.contingencyKg,
    this.alternateKg,
    this.finalReserveKg,
    this.extraKg,
    this.taxiKg,
    this.blockKg,
    this.landingKg,
  });

  factory OfpSummary.of(SimbriefOfp ofp) => OfpSummary(
    requestId: ofp.requestId,
    callsign: ofp.callsign,
    route: ofp.route,
    generatedAt: ofp.generatedAt,
    sid: ofp.sid,
    star: ofp.star,
    costIndex: ofp.costIndex,
    airac: ofp.airac,
    enrouteTime: ofp.enrouteTime,
    tripKg: ofp.fuel.trip,
    contingencyKg: ofp.fuel.contingency,
    alternateKg: ofp.fuel.alternate,
    finalReserveKg: ofp.fuel.finalReserve,
    extraKg: ofp.fuel.extra,
    taxiKg: ofp.fuel.taxi,
    blockKg: ofp.fuel.ramp,
    landingKg: ofp.fuel.landing,
  );

  final String requestId;
  final String callsign;
  final String route;
  final DateTime? generatedAt;
  final String? sid;
  final String? star;
  final String costIndex;
  final String airac;
  final Duration? enrouteTime;
  final double? tripKg;
  final double? contingencyKg;
  final double? alternateKg;
  final double? finalReserveKg;
  final double? extraKg;
  final double? taxiKg;
  final double? blockKg;
  final double? landingKg;

  /// `null` for flights without an OFP or with an unreadable one.
  static OfpSummary? decode(String? text) {
    if (text == null || text.isEmpty) return null;
    final Object? decoded;
    try {
      decoded = jsonDecode(text);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;
    final json = decoded;
    double? d(String k) => (json[k] as num?)?.toDouble();
    return OfpSummary(
      requestId: json['requestId'] as String? ?? '',
      callsign: json['callsign'] as String? ?? '',
      route: json['route'] as String? ?? '',
      generatedAt: _epoch(json['generatedAt']),
      sid: json['sid'] as String?,
      star: json['star'] as String?,
      costIndex: json['costIndex'] as String? ?? '',
      airac: json['airac'] as String? ?? '',
      enrouteTime: switch (json['enrouteSeconds']) {
        final int s => Duration(seconds: s),
        _ => null,
      },
      tripKg: d('tripKg'),
      contingencyKg: d('contingencyKg'),
      alternateKg: d('alternateKg'),
      finalReserveKg: d('finalReserveKg'),
      extraKg: d('extraKg'),
      taxiKg: d('taxiKg'),
      blockKg: d('blockKg'),
      landingKg: d('landingKg'),
    );
  }

  String encode() => jsonEncode({
    'requestId': requestId,
    'callsign': callsign,
    'route': route,
    'generatedAt': ?_seconds(generatedAt),
    'sid': ?sid,
    'star': ?star,
    'costIndex': costIndex,
    'airac': airac,
    'enrouteSeconds': ?enrouteTime?.inSeconds,
    'tripKg': ?tripKg,
    'contingencyKg': ?contingencyKg,
    'alternateKg': ?alternateKg,
    'finalReserveKg': ?finalReserveKg,
    'extraKg': ?extraKg,
    'taxiKg': ?taxiKg,
    'blockKg': ?blockKg,
    'landingKg': ?landingKg,
  });
}

int? _seconds(DateTime? t) =>
    t == null ? null : t.millisecondsSinceEpoch ~/ 1000;

// SimBrief's JSON comes from XML: every value is a string, an empty element
// becomes `{}`, and a list with one entry becomes a single object.

Map<String, dynamic> _map(Object? v) =>
    v is Map<String, dynamic> ? v : const <String, dynamic>{};

List<Object?> _list(Object? v) => switch (v) {
  List<Object?> l => l,
  Map<String, dynamic> m when m.isNotEmpty => [m],
  _ => const [],
};

String _str(Object? v) => switch (v) {
  String s => s.trim(),
  num n => '$n',
  _ => '',
};

String? _nonEmpty(Object? v) => _str(v).isEmpty ? null : _str(v);

num? _num(Object? v) => v is num ? v : num.tryParse(_str(v));

int? _int(Object? v) => _num(v)?.round();

DateTime? _epoch(Object? v) => switch (_int(v)) {
  final s? when s > 0 => DateTime.fromMillisecondsSinceEpoch(
    s * 1000,
    isUtc: true,
  ),
  _ => null,
};
