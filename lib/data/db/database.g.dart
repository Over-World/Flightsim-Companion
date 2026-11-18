// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AirportsTable extends Airports with TableInfo<$AirportsTable, Airport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AirportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identMeta = const VerificationMeta('ident');
  @override
  late final GeneratedColumn<String> ident = GeneratedColumn<String>(
    'ident',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elevationFtMeta = const VerificationMeta(
    'elevationFt',
  );
  @override
  late final GeneratedColumn<int> elevationFt = GeneratedColumn<int>(
    'elevation_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isoCountryMeta = const VerificationMeta(
    'isoCountry',
  );
  @override
  late final GeneratedColumn<String> isoCountry = GeneratedColumn<String>(
    'iso_country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isoRegionMeta = const VerificationMeta(
    'isoRegion',
  );
  @override
  late final GeneratedColumn<String> isoRegion = GeneratedColumn<String>(
    'iso_region',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _municipalityMeta = const VerificationMeta(
    'municipality',
  );
  @override
  late final GeneratedColumn<String> municipality = GeneratedColumn<String>(
    'municipality',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _icaoCodeMeta = const VerificationMeta(
    'icaoCode',
  );
  @override
  late final GeneratedColumn<String> icaoCode = GeneratedColumn<String>(
    'icao_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iataCodeMeta = const VerificationMeta(
    'iataCode',
  );
  @override
  late final GeneratedColumn<String> iataCode = GeneratedColumn<String>(
    'iata_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ident,
    type,
    name,
    latitude,
    longitude,
    elevationFt,
    isoCountry,
    isoRegion,
    municipality,
    icaoCode,
    iataCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'airports';
  @override
  VerificationContext validateIntegrity(
    Insertable<Airport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ident')) {
      context.handle(
        _identMeta,
        ident.isAcceptableOrUnknown(data['ident']!, _identMeta),
      );
    } else if (isInserting) {
      context.missing(_identMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('elevation_ft')) {
      context.handle(
        _elevationFtMeta,
        elevationFt.isAcceptableOrUnknown(
          data['elevation_ft']!,
          _elevationFtMeta,
        ),
      );
    }
    if (data.containsKey('iso_country')) {
      context.handle(
        _isoCountryMeta,
        isoCountry.isAcceptableOrUnknown(data['iso_country']!, _isoCountryMeta),
      );
    } else if (isInserting) {
      context.missing(_isoCountryMeta);
    }
    if (data.containsKey('iso_region')) {
      context.handle(
        _isoRegionMeta,
        isoRegion.isAcceptableOrUnknown(data['iso_region']!, _isoRegionMeta),
      );
    } else if (isInserting) {
      context.missing(_isoRegionMeta);
    }
    if (data.containsKey('municipality')) {
      context.handle(
        _municipalityMeta,
        municipality.isAcceptableOrUnknown(
          data['municipality']!,
          _municipalityMeta,
        ),
      );
    }
    if (data.containsKey('icao_code')) {
      context.handle(
        _icaoCodeMeta,
        icaoCode.isAcceptableOrUnknown(data['icao_code']!, _icaoCodeMeta),
      );
    }
    if (data.containsKey('iata_code')) {
      context.handle(
        _iataCodeMeta,
        iataCode.isAcceptableOrUnknown(data['iata_code']!, _iataCodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Airport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Airport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ident: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ident'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      elevationFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elevation_ft'],
      ),
      isoCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iso_country'],
      )!,
      isoRegion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iso_region'],
      )!,
      municipality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}municipality'],
      ),
      icaoCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icao_code'],
      ),
      iataCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iata_code'],
      ),
    );
  }

  @override
  $AirportsTable createAlias(String alias) {
    return $AirportsTable(attachedDatabase, alias);
  }
}

class Airport extends DataClass implements Insertable<Airport> {
  /// OurAirports id.
  final int id;
  final String ident;
  final String type;
  final String name;
  final double latitude;
  final double longitude;
  final int? elevationFt;
  final String isoCountry;
  final String isoRegion;
  final String? municipality;
  final String? icaoCode;
  final String? iataCode;
  const Airport({
    required this.id,
    required this.ident,
    required this.type,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.elevationFt,
    required this.isoCountry,
    required this.isoRegion,
    this.municipality,
    this.icaoCode,
    this.iataCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ident'] = Variable<String>(ident);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || elevationFt != null) {
      map['elevation_ft'] = Variable<int>(elevationFt);
    }
    map['iso_country'] = Variable<String>(isoCountry);
    map['iso_region'] = Variable<String>(isoRegion);
    if (!nullToAbsent || municipality != null) {
      map['municipality'] = Variable<String>(municipality);
    }
    if (!nullToAbsent || icaoCode != null) {
      map['icao_code'] = Variable<String>(icaoCode);
    }
    if (!nullToAbsent || iataCode != null) {
      map['iata_code'] = Variable<String>(iataCode);
    }
    return map;
  }

  AirportsCompanion toCompanion(bool nullToAbsent) {
    return AirportsCompanion(
      id: Value(id),
      ident: Value(ident),
      type: Value(type),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      elevationFt: elevationFt == null && nullToAbsent
          ? const Value.absent()
          : Value(elevationFt),
      isoCountry: Value(isoCountry),
      isoRegion: Value(isoRegion),
      municipality: municipality == null && nullToAbsent
          ? const Value.absent()
          : Value(municipality),
      icaoCode: icaoCode == null && nullToAbsent
          ? const Value.absent()
          : Value(icaoCode),
      iataCode: iataCode == null && nullToAbsent
          ? const Value.absent()
          : Value(iataCode),
    );
  }

  factory Airport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Airport(
      id: serializer.fromJson<int>(json['id']),
      ident: serializer.fromJson<String>(json['ident']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      elevationFt: serializer.fromJson<int?>(json['elevationFt']),
      isoCountry: serializer.fromJson<String>(json['isoCountry']),
      isoRegion: serializer.fromJson<String>(json['isoRegion']),
      municipality: serializer.fromJson<String?>(json['municipality']),
      icaoCode: serializer.fromJson<String?>(json['icaoCode']),
      iataCode: serializer.fromJson<String?>(json['iataCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ident': serializer.toJson<String>(ident),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'elevationFt': serializer.toJson<int?>(elevationFt),
      'isoCountry': serializer.toJson<String>(isoCountry),
      'isoRegion': serializer.toJson<String>(isoRegion),
      'municipality': serializer.toJson<String?>(municipality),
      'icaoCode': serializer.toJson<String?>(icaoCode),
      'iataCode': serializer.toJson<String?>(iataCode),
    };
  }

  Airport copyWith({
    int? id,
    String? ident,
    String? type,
    String? name,
    double? latitude,
    double? longitude,
    Value<int?> elevationFt = const Value.absent(),
    String? isoCountry,
    String? isoRegion,
    Value<String?> municipality = const Value.absent(),
    Value<String?> icaoCode = const Value.absent(),
    Value<String?> iataCode = const Value.absent(),
  }) => Airport(
    id: id ?? this.id,
    ident: ident ?? this.ident,
    type: type ?? this.type,
    name: name ?? this.name,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    elevationFt: elevationFt.present ? elevationFt.value : this.elevationFt,
    isoCountry: isoCountry ?? this.isoCountry,
    isoRegion: isoRegion ?? this.isoRegion,
    municipality: municipality.present ? municipality.value : this.municipality,
    icaoCode: icaoCode.present ? icaoCode.value : this.icaoCode,
    iataCode: iataCode.present ? iataCode.value : this.iataCode,
  );
  Airport copyWithCompanion(AirportsCompanion data) {
    return Airport(
      id: data.id.present ? data.id.value : this.id,
      ident: data.ident.present ? data.ident.value : this.ident,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      elevationFt: data.elevationFt.present
          ? data.elevationFt.value
          : this.elevationFt,
      isoCountry: data.isoCountry.present
          ? data.isoCountry.value
          : this.isoCountry,
      isoRegion: data.isoRegion.present ? data.isoRegion.value : this.isoRegion,
      municipality: data.municipality.present
          ? data.municipality.value
          : this.municipality,
      icaoCode: data.icaoCode.present ? data.icaoCode.value : this.icaoCode,
      iataCode: data.iataCode.present ? data.iataCode.value : this.iataCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Airport(')
          ..write('id: $id, ')
          ..write('ident: $ident, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('elevationFt: $elevationFt, ')
          ..write('isoCountry: $isoCountry, ')
          ..write('isoRegion: $isoRegion, ')
          ..write('municipality: $municipality, ')
          ..write('icaoCode: $icaoCode, ')
          ..write('iataCode: $iataCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ident,
    type,
    name,
    latitude,
    longitude,
    elevationFt,
    isoCountry,
    isoRegion,
    municipality,
    icaoCode,
    iataCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Airport &&
          other.id == this.id &&
          other.ident == this.ident &&
          other.type == this.type &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.elevationFt == this.elevationFt &&
          other.isoCountry == this.isoCountry &&
          other.isoRegion == this.isoRegion &&
          other.municipality == this.municipality &&
          other.icaoCode == this.icaoCode &&
          other.iataCode == this.iataCode);
}

class AirportsCompanion extends UpdateCompanion<Airport> {
  final Value<int> id;
  final Value<String> ident;
  final Value<String> type;
  final Value<String> name;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<int?> elevationFt;
  final Value<String> isoCountry;
  final Value<String> isoRegion;
  final Value<String?> municipality;
  final Value<String?> icaoCode;
  final Value<String?> iataCode;
  const AirportsCompanion({
    this.id = const Value.absent(),
    this.ident = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.elevationFt = const Value.absent(),
    this.isoCountry = const Value.absent(),
    this.isoRegion = const Value.absent(),
    this.municipality = const Value.absent(),
    this.icaoCode = const Value.absent(),
    this.iataCode = const Value.absent(),
  });
  AirportsCompanion.insert({
    this.id = const Value.absent(),
    required String ident,
    required String type,
    required String name,
    required double latitude,
    required double longitude,
    this.elevationFt = const Value.absent(),
    required String isoCountry,
    required String isoRegion,
    this.municipality = const Value.absent(),
    this.icaoCode = const Value.absent(),
    this.iataCode = const Value.absent(),
  }) : ident = Value(ident),
       type = Value(type),
       name = Value(name),
       latitude = Value(latitude),
       longitude = Value(longitude),
       isoCountry = Value(isoCountry),
       isoRegion = Value(isoRegion);
  static Insertable<Airport> custom({
    Expression<int>? id,
    Expression<String>? ident,
    Expression<String>? type,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? elevationFt,
    Expression<String>? isoCountry,
    Expression<String>? isoRegion,
    Expression<String>? municipality,
    Expression<String>? icaoCode,
    Expression<String>? iataCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ident != null) 'ident': ident,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (elevationFt != null) 'elevation_ft': elevationFt,
      if (isoCountry != null) 'iso_country': isoCountry,
      if (isoRegion != null) 'iso_region': isoRegion,
      if (municipality != null) 'municipality': municipality,
      if (icaoCode != null) 'icao_code': icaoCode,
      if (iataCode != null) 'iata_code': iataCode,
    });
  }

  AirportsCompanion copyWith({
    Value<int>? id,
    Value<String>? ident,
    Value<String>? type,
    Value<String>? name,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<int?>? elevationFt,
    Value<String>? isoCountry,
    Value<String>? isoRegion,
    Value<String?>? municipality,
    Value<String?>? icaoCode,
    Value<String?>? iataCode,
  }) {
    return AirportsCompanion(
      id: id ?? this.id,
      ident: ident ?? this.ident,
      type: type ?? this.type,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      elevationFt: elevationFt ?? this.elevationFt,
      isoCountry: isoCountry ?? this.isoCountry,
      isoRegion: isoRegion ?? this.isoRegion,
      municipality: municipality ?? this.municipality,
      icaoCode: icaoCode ?? this.icaoCode,
      iataCode: iataCode ?? this.iataCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ident.present) {
      map['ident'] = Variable<String>(ident.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (elevationFt.present) {
      map['elevation_ft'] = Variable<int>(elevationFt.value);
    }
    if (isoCountry.present) {
      map['iso_country'] = Variable<String>(isoCountry.value);
    }
    if (isoRegion.present) {
      map['iso_region'] = Variable<String>(isoRegion.value);
    }
    if (municipality.present) {
      map['municipality'] = Variable<String>(municipality.value);
    }
    if (icaoCode.present) {
      map['icao_code'] = Variable<String>(icaoCode.value);
    }
    if (iataCode.present) {
      map['iata_code'] = Variable<String>(iataCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AirportsCompanion(')
          ..write('id: $id, ')
          ..write('ident: $ident, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('elevationFt: $elevationFt, ')
          ..write('isoCountry: $isoCountry, ')
          ..write('isoRegion: $isoRegion, ')
          ..write('municipality: $municipality, ')
          ..write('icaoCode: $icaoCode, ')
          ..write('iataCode: $iataCode')
          ..write(')'))
        .toString();
  }
}

class $RunwaysTable extends Runways with TableInfo<$RunwaysTable, Runway> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RunwaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _airportIdMeta = const VerificationMeta(
    'airportId',
  );
  @override
  late final GeneratedColumn<int> airportId = GeneratedColumn<int>(
    'airport_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lengthFtMeta = const VerificationMeta(
    'lengthFt',
  );
  @override
  late final GeneratedColumn<int> lengthFt = GeneratedColumn<int>(
    'length_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthFtMeta = const VerificationMeta(
    'widthFt',
  );
  @override
  late final GeneratedColumn<int> widthFt = GeneratedColumn<int>(
    'width_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surfaceMeta = const VerificationMeta(
    'surface',
  );
  @override
  late final GeneratedColumn<String> surface = GeneratedColumn<String>(
    'surface',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lightedMeta = const VerificationMeta(
    'lighted',
  );
  @override
  late final GeneratedColumn<bool> lighted = GeneratedColumn<bool>(
    'lighted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("lighted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _closedMeta = const VerificationMeta('closed');
  @override
  late final GeneratedColumn<bool> closed = GeneratedColumn<bool>(
    'closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("closed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _leIdentMeta = const VerificationMeta(
    'leIdent',
  );
  @override
  late final GeneratedColumn<String> leIdent = GeneratedColumn<String>(
    'le_ident',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leHeadingTrueMeta = const VerificationMeta(
    'leHeadingTrue',
  );
  @override
  late final GeneratedColumn<double> leHeadingTrue = GeneratedColumn<double>(
    'le_heading_true',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leElevationFtMeta = const VerificationMeta(
    'leElevationFt',
  );
  @override
  late final GeneratedColumn<int> leElevationFt = GeneratedColumn<int>(
    'le_elevation_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leLatitudeMeta = const VerificationMeta(
    'leLatitude',
  );
  @override
  late final GeneratedColumn<double> leLatitude = GeneratedColumn<double>(
    'le_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leLongitudeMeta = const VerificationMeta(
    'leLongitude',
  );
  @override
  late final GeneratedColumn<double> leLongitude = GeneratedColumn<double>(
    'le_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heIdentMeta = const VerificationMeta(
    'heIdent',
  );
  @override
  late final GeneratedColumn<String> heIdent = GeneratedColumn<String>(
    'he_ident',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heHeadingTrueMeta = const VerificationMeta(
    'heHeadingTrue',
  );
  @override
  late final GeneratedColumn<double> heHeadingTrue = GeneratedColumn<double>(
    'he_heading_true',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heElevationFtMeta = const VerificationMeta(
    'heElevationFt',
  );
  @override
  late final GeneratedColumn<int> heElevationFt = GeneratedColumn<int>(
    'he_elevation_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heLatitudeMeta = const VerificationMeta(
    'heLatitude',
  );
  @override
  late final GeneratedColumn<double> heLatitude = GeneratedColumn<double>(
    'he_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heLongitudeMeta = const VerificationMeta(
    'heLongitude',
  );
  @override
  late final GeneratedColumn<double> heLongitude = GeneratedColumn<double>(
    'he_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    airportId,
    lengthFt,
    widthFt,
    surface,
    lighted,
    closed,
    leIdent,
    leHeadingTrue,
    leElevationFt,
    leLatitude,
    leLongitude,
    heIdent,
    heHeadingTrue,
    heElevationFt,
    heLatitude,
    heLongitude,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'runways';
  @override
  VerificationContext validateIntegrity(
    Insertable<Runway> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('airport_id')) {
      context.handle(
        _airportIdMeta,
        airportId.isAcceptableOrUnknown(data['airport_id']!, _airportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_airportIdMeta);
    }
    if (data.containsKey('length_ft')) {
      context.handle(
        _lengthFtMeta,
        lengthFt.isAcceptableOrUnknown(data['length_ft']!, _lengthFtMeta),
      );
    }
    if (data.containsKey('width_ft')) {
      context.handle(
        _widthFtMeta,
        widthFt.isAcceptableOrUnknown(data['width_ft']!, _widthFtMeta),
      );
    }
    if (data.containsKey('surface')) {
      context.handle(
        _surfaceMeta,
        surface.isAcceptableOrUnknown(data['surface']!, _surfaceMeta),
      );
    }
    if (data.containsKey('lighted')) {
      context.handle(
        _lightedMeta,
        lighted.isAcceptableOrUnknown(data['lighted']!, _lightedMeta),
      );
    } else if (isInserting) {
      context.missing(_lightedMeta);
    }
    if (data.containsKey('closed')) {
      context.handle(
        _closedMeta,
        closed.isAcceptableOrUnknown(data['closed']!, _closedMeta),
      );
    } else if (isInserting) {
      context.missing(_closedMeta);
    }
    if (data.containsKey('le_ident')) {
      context.handle(
        _leIdentMeta,
        leIdent.isAcceptableOrUnknown(data['le_ident']!, _leIdentMeta),
      );
    }
    if (data.containsKey('le_heading_true')) {
      context.handle(
        _leHeadingTrueMeta,
        leHeadingTrue.isAcceptableOrUnknown(
          data['le_heading_true']!,
          _leHeadingTrueMeta,
        ),
      );
    }
    if (data.containsKey('le_elevation_ft')) {
      context.handle(
        _leElevationFtMeta,
        leElevationFt.isAcceptableOrUnknown(
          data['le_elevation_ft']!,
          _leElevationFtMeta,
        ),
      );
    }
    if (data.containsKey('le_latitude')) {
      context.handle(
        _leLatitudeMeta,
        leLatitude.isAcceptableOrUnknown(data['le_latitude']!, _leLatitudeMeta),
      );
    }
    if (data.containsKey('le_longitude')) {
      context.handle(
        _leLongitudeMeta,
        leLongitude.isAcceptableOrUnknown(
          data['le_longitude']!,
          _leLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('he_ident')) {
      context.handle(
        _heIdentMeta,
        heIdent.isAcceptableOrUnknown(data['he_ident']!, _heIdentMeta),
      );
    }
    if (data.containsKey('he_heading_true')) {
      context.handle(
        _heHeadingTrueMeta,
        heHeadingTrue.isAcceptableOrUnknown(
          data['he_heading_true']!,
          _heHeadingTrueMeta,
        ),
      );
    }
    if (data.containsKey('he_elevation_ft')) {
      context.handle(
        _heElevationFtMeta,
        heElevationFt.isAcceptableOrUnknown(
          data['he_elevation_ft']!,
          _heElevationFtMeta,
        ),
      );
    }
    if (data.containsKey('he_latitude')) {
      context.handle(
        _heLatitudeMeta,
        heLatitude.isAcceptableOrUnknown(data['he_latitude']!, _heLatitudeMeta),
      );
    }
    if (data.containsKey('he_longitude')) {
      context.handle(
        _heLongitudeMeta,
        heLongitude.isAcceptableOrUnknown(
          data['he_longitude']!,
          _heLongitudeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Runway map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Runway(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      airportId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}airport_id'],
      )!,
      lengthFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}length_ft'],
      ),
      widthFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width_ft'],
      ),
      surface: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surface'],
      ),
      lighted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}lighted'],
      )!,
      closed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}closed'],
      )!,
      leIdent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}le_ident'],
      ),
      leHeadingTrue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}le_heading_true'],
      ),
      leElevationFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}le_elevation_ft'],
      ),
      leLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}le_latitude'],
      ),
      leLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}le_longitude'],
      ),
      heIdent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}he_ident'],
      ),
      heHeadingTrue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}he_heading_true'],
      ),
      heElevationFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}he_elevation_ft'],
      ),
      heLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}he_latitude'],
      ),
      heLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}he_longitude'],
      ),
    );
  }

  @override
  $RunwaysTable createAlias(String alias) {
    return $RunwaysTable(attachedDatabase, alias);
  }
}

class Runway extends DataClass implements Insertable<Runway> {
  final int id;
  final int airportId;
  final int? lengthFt;
  final int? widthFt;
  final String? surface;
  final bool lighted;
  final bool closed;
  final String? leIdent;
  final double? leHeadingTrue;
  final int? leElevationFt;
  final double? leLatitude;
  final double? leLongitude;
  final String? heIdent;
  final double? heHeadingTrue;
  final int? heElevationFt;
  final double? heLatitude;
  final double? heLongitude;
  const Runway({
    required this.id,
    required this.airportId,
    this.lengthFt,
    this.widthFt,
    this.surface,
    required this.lighted,
    required this.closed,
    this.leIdent,
    this.leHeadingTrue,
    this.leElevationFt,
    this.leLatitude,
    this.leLongitude,
    this.heIdent,
    this.heHeadingTrue,
    this.heElevationFt,
    this.heLatitude,
    this.heLongitude,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['airport_id'] = Variable<int>(airportId);
    if (!nullToAbsent || lengthFt != null) {
      map['length_ft'] = Variable<int>(lengthFt);
    }
    if (!nullToAbsent || widthFt != null) {
      map['width_ft'] = Variable<int>(widthFt);
    }
    if (!nullToAbsent || surface != null) {
      map['surface'] = Variable<String>(surface);
    }
    map['lighted'] = Variable<bool>(lighted);
    map['closed'] = Variable<bool>(closed);
    if (!nullToAbsent || leIdent != null) {
      map['le_ident'] = Variable<String>(leIdent);
    }
    if (!nullToAbsent || leHeadingTrue != null) {
      map['le_heading_true'] = Variable<double>(leHeadingTrue);
    }
    if (!nullToAbsent || leElevationFt != null) {
      map['le_elevation_ft'] = Variable<int>(leElevationFt);
    }
    if (!nullToAbsent || leLatitude != null) {
      map['le_latitude'] = Variable<double>(leLatitude);
    }
    if (!nullToAbsent || leLongitude != null) {
      map['le_longitude'] = Variable<double>(leLongitude);
    }
    if (!nullToAbsent || heIdent != null) {
      map['he_ident'] = Variable<String>(heIdent);
    }
    if (!nullToAbsent || heHeadingTrue != null) {
      map['he_heading_true'] = Variable<double>(heHeadingTrue);
    }
    if (!nullToAbsent || heElevationFt != null) {
      map['he_elevation_ft'] = Variable<int>(heElevationFt);
    }
    if (!nullToAbsent || heLatitude != null) {
      map['he_latitude'] = Variable<double>(heLatitude);
    }
    if (!nullToAbsent || heLongitude != null) {
      map['he_longitude'] = Variable<double>(heLongitude);
    }
    return map;
  }

  RunwaysCompanion toCompanion(bool nullToAbsent) {
    return RunwaysCompanion(
      id: Value(id),
      airportId: Value(airportId),
      lengthFt: lengthFt == null && nullToAbsent
          ? const Value.absent()
          : Value(lengthFt),
      widthFt: widthFt == null && nullToAbsent
          ? const Value.absent()
          : Value(widthFt),
      surface: surface == null && nullToAbsent
          ? const Value.absent()
          : Value(surface),
      lighted: Value(lighted),
      closed: Value(closed),
      leIdent: leIdent == null && nullToAbsent
          ? const Value.absent()
          : Value(leIdent),
      leHeadingTrue: leHeadingTrue == null && nullToAbsent
          ? const Value.absent()
          : Value(leHeadingTrue),
      leElevationFt: leElevationFt == null && nullToAbsent
          ? const Value.absent()
          : Value(leElevationFt),
      leLatitude: leLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(leLatitude),
      leLongitude: leLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(leLongitude),
      heIdent: heIdent == null && nullToAbsent
          ? const Value.absent()
          : Value(heIdent),
      heHeadingTrue: heHeadingTrue == null && nullToAbsent
          ? const Value.absent()
          : Value(heHeadingTrue),
      heElevationFt: heElevationFt == null && nullToAbsent
          ? const Value.absent()
          : Value(heElevationFt),
      heLatitude: heLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(heLatitude),
      heLongitude: heLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(heLongitude),
    );
  }

  factory Runway.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Runway(
      id: serializer.fromJson<int>(json['id']),
      airportId: serializer.fromJson<int>(json['airportId']),
      lengthFt: serializer.fromJson<int?>(json['lengthFt']),
      widthFt: serializer.fromJson<int?>(json['widthFt']),
      surface: serializer.fromJson<String?>(json['surface']),
      lighted: serializer.fromJson<bool>(json['lighted']),
      closed: serializer.fromJson<bool>(json['closed']),
      leIdent: serializer.fromJson<String?>(json['leIdent']),
      leHeadingTrue: serializer.fromJson<double?>(json['leHeadingTrue']),
      leElevationFt: serializer.fromJson<int?>(json['leElevationFt']),
      leLatitude: serializer.fromJson<double?>(json['leLatitude']),
      leLongitude: serializer.fromJson<double?>(json['leLongitude']),
      heIdent: serializer.fromJson<String?>(json['heIdent']),
      heHeadingTrue: serializer.fromJson<double?>(json['heHeadingTrue']),
      heElevationFt: serializer.fromJson<int?>(json['heElevationFt']),
      heLatitude: serializer.fromJson<double?>(json['heLatitude']),
      heLongitude: serializer.fromJson<double?>(json['heLongitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'airportId': serializer.toJson<int>(airportId),
      'lengthFt': serializer.toJson<int?>(lengthFt),
      'widthFt': serializer.toJson<int?>(widthFt),
      'surface': serializer.toJson<String?>(surface),
      'lighted': serializer.toJson<bool>(lighted),
      'closed': serializer.toJson<bool>(closed),
      'leIdent': serializer.toJson<String?>(leIdent),
      'leHeadingTrue': serializer.toJson<double?>(leHeadingTrue),
      'leElevationFt': serializer.toJson<int?>(leElevationFt),
      'leLatitude': serializer.toJson<double?>(leLatitude),
      'leLongitude': serializer.toJson<double?>(leLongitude),
      'heIdent': serializer.toJson<String?>(heIdent),
      'heHeadingTrue': serializer.toJson<double?>(heHeadingTrue),
      'heElevationFt': serializer.toJson<int?>(heElevationFt),
      'heLatitude': serializer.toJson<double?>(heLatitude),
      'heLongitude': serializer.toJson<double?>(heLongitude),
    };
  }

  Runway copyWith({
    int? id,
    int? airportId,
    Value<int?> lengthFt = const Value.absent(),
    Value<int?> widthFt = const Value.absent(),
    Value<String?> surface = const Value.absent(),
    bool? lighted,
    bool? closed,
    Value<String?> leIdent = const Value.absent(),
    Value<double?> leHeadingTrue = const Value.absent(),
    Value<int?> leElevationFt = const Value.absent(),
    Value<double?> leLatitude = const Value.absent(),
    Value<double?> leLongitude = const Value.absent(),
    Value<String?> heIdent = const Value.absent(),
    Value<double?> heHeadingTrue = const Value.absent(),
    Value<int?> heElevationFt = const Value.absent(),
    Value<double?> heLatitude = const Value.absent(),
    Value<double?> heLongitude = const Value.absent(),
  }) => Runway(
    id: id ?? this.id,
    airportId: airportId ?? this.airportId,
    lengthFt: lengthFt.present ? lengthFt.value : this.lengthFt,
    widthFt: widthFt.present ? widthFt.value : this.widthFt,
    surface: surface.present ? surface.value : this.surface,
    lighted: lighted ?? this.lighted,
    closed: closed ?? this.closed,
    leIdent: leIdent.present ? leIdent.value : this.leIdent,
    leHeadingTrue: leHeadingTrue.present
        ? leHeadingTrue.value
        : this.leHeadingTrue,
    leElevationFt: leElevationFt.present
        ? leElevationFt.value
        : this.leElevationFt,
    leLatitude: leLatitude.present ? leLatitude.value : this.leLatitude,
    leLongitude: leLongitude.present ? leLongitude.value : this.leLongitude,
    heIdent: heIdent.present ? heIdent.value : this.heIdent,
    heHeadingTrue: heHeadingTrue.present
        ? heHeadingTrue.value
        : this.heHeadingTrue,
    heElevationFt: heElevationFt.present
        ? heElevationFt.value
        : this.heElevationFt,
    heLatitude: heLatitude.present ? heLatitude.value : this.heLatitude,
    heLongitude: heLongitude.present ? heLongitude.value : this.heLongitude,
  );
  Runway copyWithCompanion(RunwaysCompanion data) {
    return Runway(
      id: data.id.present ? data.id.value : this.id,
      airportId: data.airportId.present ? data.airportId.value : this.airportId,
      lengthFt: data.lengthFt.present ? data.lengthFt.value : this.lengthFt,
      widthFt: data.widthFt.present ? data.widthFt.value : this.widthFt,
      surface: data.surface.present ? data.surface.value : this.surface,
      lighted: data.lighted.present ? data.lighted.value : this.lighted,
      closed: data.closed.present ? data.closed.value : this.closed,
      leIdent: data.leIdent.present ? data.leIdent.value : this.leIdent,
      leHeadingTrue: data.leHeadingTrue.present
          ? data.leHeadingTrue.value
          : this.leHeadingTrue,
      leElevationFt: data.leElevationFt.present
          ? data.leElevationFt.value
          : this.leElevationFt,
      leLatitude: data.leLatitude.present
          ? data.leLatitude.value
          : this.leLatitude,
      leLongitude: data.leLongitude.present
          ? data.leLongitude.value
          : this.leLongitude,
      heIdent: data.heIdent.present ? data.heIdent.value : this.heIdent,
      heHeadingTrue: data.heHeadingTrue.present
          ? data.heHeadingTrue.value
          : this.heHeadingTrue,
      heElevationFt: data.heElevationFt.present
          ? data.heElevationFt.value
          : this.heElevationFt,
      heLatitude: data.heLatitude.present
          ? data.heLatitude.value
          : this.heLatitude,
      heLongitude: data.heLongitude.present
          ? data.heLongitude.value
          : this.heLongitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Runway(')
          ..write('id: $id, ')
          ..write('airportId: $airportId, ')
          ..write('lengthFt: $lengthFt, ')
          ..write('widthFt: $widthFt, ')
          ..write('surface: $surface, ')
          ..write('lighted: $lighted, ')
          ..write('closed: $closed, ')
          ..write('leIdent: $leIdent, ')
          ..write('leHeadingTrue: $leHeadingTrue, ')
          ..write('leElevationFt: $leElevationFt, ')
          ..write('leLatitude: $leLatitude, ')
          ..write('leLongitude: $leLongitude, ')
          ..write('heIdent: $heIdent, ')
          ..write('heHeadingTrue: $heHeadingTrue, ')
          ..write('heElevationFt: $heElevationFt, ')
          ..write('heLatitude: $heLatitude, ')
          ..write('heLongitude: $heLongitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    airportId,
    lengthFt,
    widthFt,
    surface,
    lighted,
    closed,
    leIdent,
    leHeadingTrue,
    leElevationFt,
    leLatitude,
    leLongitude,
    heIdent,
    heHeadingTrue,
    heElevationFt,
    heLatitude,
    heLongitude,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Runway &&
          other.id == this.id &&
          other.airportId == this.airportId &&
          other.lengthFt == this.lengthFt &&
          other.widthFt == this.widthFt &&
          other.surface == this.surface &&
          other.lighted == this.lighted &&
          other.closed == this.closed &&
          other.leIdent == this.leIdent &&
          other.leHeadingTrue == this.leHeadingTrue &&
          other.leElevationFt == this.leElevationFt &&
          other.leLatitude == this.leLatitude &&
          other.leLongitude == this.leLongitude &&
          other.heIdent == this.heIdent &&
          other.heHeadingTrue == this.heHeadingTrue &&
          other.heElevationFt == this.heElevationFt &&
          other.heLatitude == this.heLatitude &&
          other.heLongitude == this.heLongitude);
}

class RunwaysCompanion extends UpdateCompanion<Runway> {
  final Value<int> id;
  final Value<int> airportId;
  final Value<int?> lengthFt;
  final Value<int?> widthFt;
  final Value<String?> surface;
  final Value<bool> lighted;
  final Value<bool> closed;
  final Value<String?> leIdent;
  final Value<double?> leHeadingTrue;
  final Value<int?> leElevationFt;
  final Value<double?> leLatitude;
  final Value<double?> leLongitude;
  final Value<String?> heIdent;
  final Value<double?> heHeadingTrue;
  final Value<int?> heElevationFt;
  final Value<double?> heLatitude;
  final Value<double?> heLongitude;
  const RunwaysCompanion({
    this.id = const Value.absent(),
    this.airportId = const Value.absent(),
    this.lengthFt = const Value.absent(),
    this.widthFt = const Value.absent(),
    this.surface = const Value.absent(),
    this.lighted = const Value.absent(),
    this.closed = const Value.absent(),
    this.leIdent = const Value.absent(),
    this.leHeadingTrue = const Value.absent(),
    this.leElevationFt = const Value.absent(),
    this.leLatitude = const Value.absent(),
    this.leLongitude = const Value.absent(),
    this.heIdent = const Value.absent(),
    this.heHeadingTrue = const Value.absent(),
    this.heElevationFt = const Value.absent(),
    this.heLatitude = const Value.absent(),
    this.heLongitude = const Value.absent(),
  });
  RunwaysCompanion.insert({
    this.id = const Value.absent(),
    required int airportId,
    this.lengthFt = const Value.absent(),
    this.widthFt = const Value.absent(),
    this.surface = const Value.absent(),
    required bool lighted,
    required bool closed,
    this.leIdent = const Value.absent(),
    this.leHeadingTrue = const Value.absent(),
    this.leElevationFt = const Value.absent(),
    this.leLatitude = const Value.absent(),
    this.leLongitude = const Value.absent(),
    this.heIdent = const Value.absent(),
    this.heHeadingTrue = const Value.absent(),
    this.heElevationFt = const Value.absent(),
    this.heLatitude = const Value.absent(),
    this.heLongitude = const Value.absent(),
  }) : airportId = Value(airportId),
       lighted = Value(lighted),
       closed = Value(closed);
  static Insertable<Runway> custom({
    Expression<int>? id,
    Expression<int>? airportId,
    Expression<int>? lengthFt,
    Expression<int>? widthFt,
    Expression<String>? surface,
    Expression<bool>? lighted,
    Expression<bool>? closed,
    Expression<String>? leIdent,
    Expression<double>? leHeadingTrue,
    Expression<int>? leElevationFt,
    Expression<double>? leLatitude,
    Expression<double>? leLongitude,
    Expression<String>? heIdent,
    Expression<double>? heHeadingTrue,
    Expression<int>? heElevationFt,
    Expression<double>? heLatitude,
    Expression<double>? heLongitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (airportId != null) 'airport_id': airportId,
      if (lengthFt != null) 'length_ft': lengthFt,
      if (widthFt != null) 'width_ft': widthFt,
      if (surface != null) 'surface': surface,
      if (lighted != null) 'lighted': lighted,
      if (closed != null) 'closed': closed,
      if (leIdent != null) 'le_ident': leIdent,
      if (leHeadingTrue != null) 'le_heading_true': leHeadingTrue,
      if (leElevationFt != null) 'le_elevation_ft': leElevationFt,
      if (leLatitude != null) 'le_latitude': leLatitude,
      if (leLongitude != null) 'le_longitude': leLongitude,
      if (heIdent != null) 'he_ident': heIdent,
      if (heHeadingTrue != null) 'he_heading_true': heHeadingTrue,
      if (heElevationFt != null) 'he_elevation_ft': heElevationFt,
      if (heLatitude != null) 'he_latitude': heLatitude,
      if (heLongitude != null) 'he_longitude': heLongitude,
    });
  }

  RunwaysCompanion copyWith({
    Value<int>? id,
    Value<int>? airportId,
    Value<int?>? lengthFt,
    Value<int?>? widthFt,
    Value<String?>? surface,
    Value<bool>? lighted,
    Value<bool>? closed,
    Value<String?>? leIdent,
    Value<double?>? leHeadingTrue,
    Value<int?>? leElevationFt,
    Value<double?>? leLatitude,
    Value<double?>? leLongitude,
    Value<String?>? heIdent,
    Value<double?>? heHeadingTrue,
    Value<int?>? heElevationFt,
    Value<double?>? heLatitude,
    Value<double?>? heLongitude,
  }) {
    return RunwaysCompanion(
      id: id ?? this.id,
      airportId: airportId ?? this.airportId,
      lengthFt: lengthFt ?? this.lengthFt,
      widthFt: widthFt ?? this.widthFt,
      surface: surface ?? this.surface,
      lighted: lighted ?? this.lighted,
      closed: closed ?? this.closed,
      leIdent: leIdent ?? this.leIdent,
      leHeadingTrue: leHeadingTrue ?? this.leHeadingTrue,
      leElevationFt: leElevationFt ?? this.leElevationFt,
      leLatitude: leLatitude ?? this.leLatitude,
      leLongitude: leLongitude ?? this.leLongitude,
      heIdent: heIdent ?? this.heIdent,
      heHeadingTrue: heHeadingTrue ?? this.heHeadingTrue,
      heElevationFt: heElevationFt ?? this.heElevationFt,
      heLatitude: heLatitude ?? this.heLatitude,
      heLongitude: heLongitude ?? this.heLongitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (airportId.present) {
      map['airport_id'] = Variable<int>(airportId.value);
    }
    if (lengthFt.present) {
      map['length_ft'] = Variable<int>(lengthFt.value);
    }
    if (widthFt.present) {
      map['width_ft'] = Variable<int>(widthFt.value);
    }
    if (surface.present) {
      map['surface'] = Variable<String>(surface.value);
    }
    if (lighted.present) {
      map['lighted'] = Variable<bool>(lighted.value);
    }
    if (closed.present) {
      map['closed'] = Variable<bool>(closed.value);
    }
    if (leIdent.present) {
      map['le_ident'] = Variable<String>(leIdent.value);
    }
    if (leHeadingTrue.present) {
      map['le_heading_true'] = Variable<double>(leHeadingTrue.value);
    }
    if (leElevationFt.present) {
      map['le_elevation_ft'] = Variable<int>(leElevationFt.value);
    }
    if (leLatitude.present) {
      map['le_latitude'] = Variable<double>(leLatitude.value);
    }
    if (leLongitude.present) {
      map['le_longitude'] = Variable<double>(leLongitude.value);
    }
    if (heIdent.present) {
      map['he_ident'] = Variable<String>(heIdent.value);
    }
    if (heHeadingTrue.present) {
      map['he_heading_true'] = Variable<double>(heHeadingTrue.value);
    }
    if (heElevationFt.present) {
      map['he_elevation_ft'] = Variable<int>(heElevationFt.value);
    }
    if (heLatitude.present) {
      map['he_latitude'] = Variable<double>(heLatitude.value);
    }
    if (heLongitude.present) {
      map['he_longitude'] = Variable<double>(heLongitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RunwaysCompanion(')
          ..write('id: $id, ')
          ..write('airportId: $airportId, ')
          ..write('lengthFt: $lengthFt, ')
          ..write('widthFt: $widthFt, ')
          ..write('surface: $surface, ')
          ..write('lighted: $lighted, ')
          ..write('closed: $closed, ')
          ..write('leIdent: $leIdent, ')
          ..write('leHeadingTrue: $leHeadingTrue, ')
          ..write('leElevationFt: $leElevationFt, ')
          ..write('leLatitude: $leLatitude, ')
          ..write('leLongitude: $leLongitude, ')
          ..write('heIdent: $heIdent, ')
          ..write('heHeadingTrue: $heHeadingTrue, ')
          ..write('heElevationFt: $heElevationFt, ')
          ..write('heLatitude: $heLatitude, ')
          ..write('heLongitude: $heLongitude')
          ..write(')'))
        .toString();
  }
}

class $AirportFrequenciesTable extends AirportFrequencies
    with TableInfo<$AirportFrequenciesTable, AirportFrequency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AirportFrequenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _airportIdMeta = const VerificationMeta(
    'airportId',
  );
  @override
  late final GeneratedColumn<int> airportId = GeneratedColumn<int>(
    'airport_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyMhzMeta = const VerificationMeta(
    'frequencyMhz',
  );
  @override
  late final GeneratedColumn<double> frequencyMhz = GeneratedColumn<double>(
    'frequency_mhz',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    airportId,
    type,
    description,
    frequencyMhz,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'airport_frequencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<AirportFrequency> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('airport_id')) {
      context.handle(
        _airportIdMeta,
        airportId.isAcceptableOrUnknown(data['airport_id']!, _airportIdMeta),
      );
    } else if (isInserting) {
      context.missing(_airportIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('frequency_mhz')) {
      context.handle(
        _frequencyMhzMeta,
        frequencyMhz.isAcceptableOrUnknown(
          data['frequency_mhz']!,
          _frequencyMhzMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyMhzMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AirportFrequency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AirportFrequency(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      airportId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}airport_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      frequencyMhz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}frequency_mhz'],
      )!,
    );
  }

  @override
  $AirportFrequenciesTable createAlias(String alias) {
    return $AirportFrequenciesTable(attachedDatabase, alias);
  }
}

class AirportFrequency extends DataClass
    implements Insertable<AirportFrequency> {
  final int id;
  final int airportId;

  /// e.g. ATIS, TWR, GND, APP, INFO, CTAF, UNIC.
  final String type;
  final String? description;
  final double frequencyMhz;
  const AirportFrequency({
    required this.id,
    required this.airportId,
    required this.type,
    this.description,
    required this.frequencyMhz,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['airport_id'] = Variable<int>(airportId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['frequency_mhz'] = Variable<double>(frequencyMhz);
    return map;
  }

  AirportFrequenciesCompanion toCompanion(bool nullToAbsent) {
    return AirportFrequenciesCompanion(
      id: Value(id),
      airportId: Value(airportId),
      type: Value(type),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      frequencyMhz: Value(frequencyMhz),
    );
  }

  factory AirportFrequency.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AirportFrequency(
      id: serializer.fromJson<int>(json['id']),
      airportId: serializer.fromJson<int>(json['airportId']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String?>(json['description']),
      frequencyMhz: serializer.fromJson<double>(json['frequencyMhz']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'airportId': serializer.toJson<int>(airportId),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String?>(description),
      'frequencyMhz': serializer.toJson<double>(frequencyMhz),
    };
  }

  AirportFrequency copyWith({
    int? id,
    int? airportId,
    String? type,
    Value<String?> description = const Value.absent(),
    double? frequencyMhz,
  }) => AirportFrequency(
    id: id ?? this.id,
    airportId: airportId ?? this.airportId,
    type: type ?? this.type,
    description: description.present ? description.value : this.description,
    frequencyMhz: frequencyMhz ?? this.frequencyMhz,
  );
  AirportFrequency copyWithCompanion(AirportFrequenciesCompanion data) {
    return AirportFrequency(
      id: data.id.present ? data.id.value : this.id,
      airportId: data.airportId.present ? data.airportId.value : this.airportId,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      frequencyMhz: data.frequencyMhz.present
          ? data.frequencyMhz.value
          : this.frequencyMhz,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AirportFrequency(')
          ..write('id: $id, ')
          ..write('airportId: $airportId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('frequencyMhz: $frequencyMhz')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, airportId, type, description, frequencyMhz);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AirportFrequency &&
          other.id == this.id &&
          other.airportId == this.airportId &&
          other.type == this.type &&
          other.description == this.description &&
          other.frequencyMhz == this.frequencyMhz);
}

class AirportFrequenciesCompanion extends UpdateCompanion<AirportFrequency> {
  final Value<int> id;
  final Value<int> airportId;
  final Value<String> type;
  final Value<String?> description;
  final Value<double> frequencyMhz;
  const AirportFrequenciesCompanion({
    this.id = const Value.absent(),
    this.airportId = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.frequencyMhz = const Value.absent(),
  });
  AirportFrequenciesCompanion.insert({
    this.id = const Value.absent(),
    required int airportId,
    required String type,
    this.description = const Value.absent(),
    required double frequencyMhz,
  }) : airportId = Value(airportId),
       type = Value(type),
       frequencyMhz = Value(frequencyMhz);
  static Insertable<AirportFrequency> custom({
    Expression<int>? id,
    Expression<int>? airportId,
    Expression<String>? type,
    Expression<String>? description,
    Expression<double>? frequencyMhz,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (airportId != null) 'airport_id': airportId,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (frequencyMhz != null) 'frequency_mhz': frequencyMhz,
    });
  }

  AirportFrequenciesCompanion copyWith({
    Value<int>? id,
    Value<int>? airportId,
    Value<String>? type,
    Value<String?>? description,
    Value<double>? frequencyMhz,
  }) {
    return AirportFrequenciesCompanion(
      id: id ?? this.id,
      airportId: airportId ?? this.airportId,
      type: type ?? this.type,
      description: description ?? this.description,
      frequencyMhz: frequencyMhz ?? this.frequencyMhz,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (airportId.present) {
      map['airport_id'] = Variable<int>(airportId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (frequencyMhz.present) {
      map['frequency_mhz'] = Variable<double>(frequencyMhz.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AirportFrequenciesCompanion(')
          ..write('id: $id, ')
          ..write('airportId: $airportId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('frequencyMhz: $frequencyMhz')
          ..write(')'))
        .toString();
  }
}

class $NavaidsTable extends Navaids with TableInfo<$NavaidsTable, Navaid> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NavaidsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identMeta = const VerificationMeta('ident');
  @override
  late final GeneratedColumn<String> ident = GeneratedColumn<String>(
    'ident',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyKhzMeta = const VerificationMeta(
    'frequencyKhz',
  );
  @override
  late final GeneratedColumn<int> frequencyKhz = GeneratedColumn<int>(
    'frequency_khz',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elevationFtMeta = const VerificationMeta(
    'elevationFt',
  );
  @override
  late final GeneratedColumn<int> elevationFt = GeneratedColumn<int>(
    'elevation_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isoCountryMeta = const VerificationMeta(
    'isoCountry',
  );
  @override
  late final GeneratedColumn<String> isoCountry = GeneratedColumn<String>(
    'iso_country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _magneticVariationMeta = const VerificationMeta(
    'magneticVariation',
  );
  @override
  late final GeneratedColumn<double> magneticVariation =
      GeneratedColumn<double>(
        'magnetic_variation',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _associatedAirportMeta = const VerificationMeta(
    'associatedAirport',
  );
  @override
  late final GeneratedColumn<String> associatedAirport =
      GeneratedColumn<String>(
        'associated_airport',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ident,
    name,
    type,
    frequencyKhz,
    latitude,
    longitude,
    elevationFt,
    isoCountry,
    magneticVariation,
    associatedAirport,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'navaids';
  @override
  VerificationContext validateIntegrity(
    Insertable<Navaid> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ident')) {
      context.handle(
        _identMeta,
        ident.isAcceptableOrUnknown(data['ident']!, _identMeta),
      );
    } else if (isInserting) {
      context.missing(_identMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('frequency_khz')) {
      context.handle(
        _frequencyKhzMeta,
        frequencyKhz.isAcceptableOrUnknown(
          data['frequency_khz']!,
          _frequencyKhzMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('elevation_ft')) {
      context.handle(
        _elevationFtMeta,
        elevationFt.isAcceptableOrUnknown(
          data['elevation_ft']!,
          _elevationFtMeta,
        ),
      );
    }
    if (data.containsKey('iso_country')) {
      context.handle(
        _isoCountryMeta,
        isoCountry.isAcceptableOrUnknown(data['iso_country']!, _isoCountryMeta),
      );
    } else if (isInserting) {
      context.missing(_isoCountryMeta);
    }
    if (data.containsKey('magnetic_variation')) {
      context.handle(
        _magneticVariationMeta,
        magneticVariation.isAcceptableOrUnknown(
          data['magnetic_variation']!,
          _magneticVariationMeta,
        ),
      );
    }
    if (data.containsKey('associated_airport')) {
      context.handle(
        _associatedAirportMeta,
        associatedAirport.isAcceptableOrUnknown(
          data['associated_airport']!,
          _associatedAirportMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Navaid map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Navaid(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ident: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ident'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      frequencyKhz: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_khz'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      elevationFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elevation_ft'],
      ),
      isoCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iso_country'],
      )!,
      magneticVariation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}magnetic_variation'],
      ),
      associatedAirport: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}associated_airport'],
      ),
    );
  }

  @override
  $NavaidsTable createAlias(String alias) {
    return $NavaidsTable(attachedDatabase, alias);
  }
}

class Navaid extends DataClass implements Insertable<Navaid> {
  final int id;
  final String ident;
  final String name;

  /// VOR, VOR-DME, VORTAC, DME, NDB, NDB-DME, TACAN.
  final String type;

  /// VORs are stored in kHz too (e.g. 114300), as in the source data.
  final int? frequencyKhz;
  final double latitude;
  final double longitude;
  final int? elevationFt;
  final String isoCountry;
  final double? magneticVariation;
  final String? associatedAirport;
  const Navaid({
    required this.id,
    required this.ident,
    required this.name,
    required this.type,
    this.frequencyKhz,
    required this.latitude,
    required this.longitude,
    this.elevationFt,
    required this.isoCountry,
    this.magneticVariation,
    this.associatedAirport,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ident'] = Variable<String>(ident);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || frequencyKhz != null) {
      map['frequency_khz'] = Variable<int>(frequencyKhz);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || elevationFt != null) {
      map['elevation_ft'] = Variable<int>(elevationFt);
    }
    map['iso_country'] = Variable<String>(isoCountry);
    if (!nullToAbsent || magneticVariation != null) {
      map['magnetic_variation'] = Variable<double>(magneticVariation);
    }
    if (!nullToAbsent || associatedAirport != null) {
      map['associated_airport'] = Variable<String>(associatedAirport);
    }
    return map;
  }

  NavaidsCompanion toCompanion(bool nullToAbsent) {
    return NavaidsCompanion(
      id: Value(id),
      ident: Value(ident),
      name: Value(name),
      type: Value(type),
      frequencyKhz: frequencyKhz == null && nullToAbsent
          ? const Value.absent()
          : Value(frequencyKhz),
      latitude: Value(latitude),
      longitude: Value(longitude),
      elevationFt: elevationFt == null && nullToAbsent
          ? const Value.absent()
          : Value(elevationFt),
      isoCountry: Value(isoCountry),
      magneticVariation: magneticVariation == null && nullToAbsent
          ? const Value.absent()
          : Value(magneticVariation),
      associatedAirport: associatedAirport == null && nullToAbsent
          ? const Value.absent()
          : Value(associatedAirport),
    );
  }

  factory Navaid.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Navaid(
      id: serializer.fromJson<int>(json['id']),
      ident: serializer.fromJson<String>(json['ident']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      frequencyKhz: serializer.fromJson<int?>(json['frequencyKhz']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      elevationFt: serializer.fromJson<int?>(json['elevationFt']),
      isoCountry: serializer.fromJson<String>(json['isoCountry']),
      magneticVariation: serializer.fromJson<double?>(
        json['magneticVariation'],
      ),
      associatedAirport: serializer.fromJson<String?>(
        json['associatedAirport'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ident': serializer.toJson<String>(ident),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'frequencyKhz': serializer.toJson<int?>(frequencyKhz),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'elevationFt': serializer.toJson<int?>(elevationFt),
      'isoCountry': serializer.toJson<String>(isoCountry),
      'magneticVariation': serializer.toJson<double?>(magneticVariation),
      'associatedAirport': serializer.toJson<String?>(associatedAirport),
    };
  }

  Navaid copyWith({
    int? id,
    String? ident,
    String? name,
    String? type,
    Value<int?> frequencyKhz = const Value.absent(),
    double? latitude,
    double? longitude,
    Value<int?> elevationFt = const Value.absent(),
    String? isoCountry,
    Value<double?> magneticVariation = const Value.absent(),
    Value<String?> associatedAirport = const Value.absent(),
  }) => Navaid(
    id: id ?? this.id,
    ident: ident ?? this.ident,
    name: name ?? this.name,
    type: type ?? this.type,
    frequencyKhz: frequencyKhz.present ? frequencyKhz.value : this.frequencyKhz,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    elevationFt: elevationFt.present ? elevationFt.value : this.elevationFt,
    isoCountry: isoCountry ?? this.isoCountry,
    magneticVariation: magneticVariation.present
        ? magneticVariation.value
        : this.magneticVariation,
    associatedAirport: associatedAirport.present
        ? associatedAirport.value
        : this.associatedAirport,
  );
  Navaid copyWithCompanion(NavaidsCompanion data) {
    return Navaid(
      id: data.id.present ? data.id.value : this.id,
      ident: data.ident.present ? data.ident.value : this.ident,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      frequencyKhz: data.frequencyKhz.present
          ? data.frequencyKhz.value
          : this.frequencyKhz,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      elevationFt: data.elevationFt.present
          ? data.elevationFt.value
          : this.elevationFt,
      isoCountry: data.isoCountry.present
          ? data.isoCountry.value
          : this.isoCountry,
      magneticVariation: data.magneticVariation.present
          ? data.magneticVariation.value
          : this.magneticVariation,
      associatedAirport: data.associatedAirport.present
          ? data.associatedAirport.value
          : this.associatedAirport,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Navaid(')
          ..write('id: $id, ')
          ..write('ident: $ident, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('frequencyKhz: $frequencyKhz, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('elevationFt: $elevationFt, ')
          ..write('isoCountry: $isoCountry, ')
          ..write('magneticVariation: $magneticVariation, ')
          ..write('associatedAirport: $associatedAirport')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ident,
    name,
    type,
    frequencyKhz,
    latitude,
    longitude,
    elevationFt,
    isoCountry,
    magneticVariation,
    associatedAirport,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Navaid &&
          other.id == this.id &&
          other.ident == this.ident &&
          other.name == this.name &&
          other.type == this.type &&
          other.frequencyKhz == this.frequencyKhz &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.elevationFt == this.elevationFt &&
          other.isoCountry == this.isoCountry &&
          other.magneticVariation == this.magneticVariation &&
          other.associatedAirport == this.associatedAirport);
}

class NavaidsCompanion extends UpdateCompanion<Navaid> {
  final Value<int> id;
  final Value<String> ident;
  final Value<String> name;
  final Value<String> type;
  final Value<int?> frequencyKhz;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<int?> elevationFt;
  final Value<String> isoCountry;
  final Value<double?> magneticVariation;
  final Value<String?> associatedAirport;
  const NavaidsCompanion({
    this.id = const Value.absent(),
    this.ident = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.frequencyKhz = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.elevationFt = const Value.absent(),
    this.isoCountry = const Value.absent(),
    this.magneticVariation = const Value.absent(),
    this.associatedAirport = const Value.absent(),
  });
  NavaidsCompanion.insert({
    this.id = const Value.absent(),
    required String ident,
    required String name,
    required String type,
    this.frequencyKhz = const Value.absent(),
    required double latitude,
    required double longitude,
    this.elevationFt = const Value.absent(),
    required String isoCountry,
    this.magneticVariation = const Value.absent(),
    this.associatedAirport = const Value.absent(),
  }) : ident = Value(ident),
       name = Value(name),
       type = Value(type),
       latitude = Value(latitude),
       longitude = Value(longitude),
       isoCountry = Value(isoCountry);
  static Insertable<Navaid> custom({
    Expression<int>? id,
    Expression<String>? ident,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? frequencyKhz,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? elevationFt,
    Expression<String>? isoCountry,
    Expression<double>? magneticVariation,
    Expression<String>? associatedAirport,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ident != null) 'ident': ident,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (frequencyKhz != null) 'frequency_khz': frequencyKhz,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (elevationFt != null) 'elevation_ft': elevationFt,
      if (isoCountry != null) 'iso_country': isoCountry,
      if (magneticVariation != null) 'magnetic_variation': magneticVariation,
      if (associatedAirport != null) 'associated_airport': associatedAirport,
    });
  }

  NavaidsCompanion copyWith({
    Value<int>? id,
    Value<String>? ident,
    Value<String>? name,
    Value<String>? type,
    Value<int?>? frequencyKhz,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<int?>? elevationFt,
    Value<String>? isoCountry,
    Value<double?>? magneticVariation,
    Value<String?>? associatedAirport,
  }) {
    return NavaidsCompanion(
      id: id ?? this.id,
      ident: ident ?? this.ident,
      name: name ?? this.name,
      type: type ?? this.type,
      frequencyKhz: frequencyKhz ?? this.frequencyKhz,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      elevationFt: elevationFt ?? this.elevationFt,
      isoCountry: isoCountry ?? this.isoCountry,
      magneticVariation: magneticVariation ?? this.magneticVariation,
      associatedAirport: associatedAirport ?? this.associatedAirport,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ident.present) {
      map['ident'] = Variable<String>(ident.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (frequencyKhz.present) {
      map['frequency_khz'] = Variable<int>(frequencyKhz.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (elevationFt.present) {
      map['elevation_ft'] = Variable<int>(elevationFt.value);
    }
    if (isoCountry.present) {
      map['iso_country'] = Variable<String>(isoCountry.value);
    }
    if (magneticVariation.present) {
      map['magnetic_variation'] = Variable<double>(magneticVariation.value);
    }
    if (associatedAirport.present) {
      map['associated_airport'] = Variable<String>(associatedAirport.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NavaidsCompanion(')
          ..write('id: $id, ')
          ..write('ident: $ident, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('frequencyKhz: $frequencyKhz, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('elevationFt: $elevationFt, ')
          ..write('isoCountry: $isoCountry, ')
          ..write('magneticVariation: $magneticVariation, ')
          ..write('associatedAirport: $associatedAirport')
          ..write(')'))
        .toString();
  }
}

class $AircraftProfilesTable extends AircraftProfiles
    with TableInfo<$AircraftProfilesTable, AircraftProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AircraftProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _icaoTypeMeta = const VerificationMeta(
    'icaoType',
  );
  @override
  late final GeneratedColumn<String> icaoType = GeneratedColumn<String>(
    'icao_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registrationMeta = const VerificationMeta(
    'registration',
  );
  @override
  late final GeneratedColumn<String> registration = GeneratedColumn<String>(
    'registration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _cruiseTasMeta = const VerificationMeta(
    'cruiseTas',
  );
  @override
  late final GeneratedColumn<int> cruiseTas = GeneratedColumn<int>(
    'cruise_tas',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _climbTasMeta = const VerificationMeta(
    'climbTas',
  );
  @override
  late final GeneratedColumn<int> climbTas = GeneratedColumn<int>(
    'climb_tas',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _climbRateFpmMeta = const VerificationMeta(
    'climbRateFpm',
  );
  @override
  late final GeneratedColumn<int> climbRateFpm = GeneratedColumn<int>(
    'climb_rate_fpm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descentRateFpmMeta = const VerificationMeta(
    'descentRateFpm',
  );
  @override
  late final GeneratedColumn<int> descentRateFpm = GeneratedColumn<int>(
    'descent_rate_fpm',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fuelBurnLphMeta = const VerificationMeta(
    'fuelBurnLph',
  );
  @override
  late final GeneratedColumn<double> fuelBurnLph = GeneratedColumn<double>(
    'fuel_burn_lph',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usableFuelLMeta = const VerificationMeta(
    'usableFuelL',
  );
  @override
  late final GeneratedColumn<double> usableFuelL = GeneratedColumn<double>(
    'usable_fuel_l',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fuelTypeMeta = const VerificationMeta(
    'fuelType',
  );
  @override
  late final GeneratedColumn<String> fuelType = GeneratedColumn<String>(
    'fuel_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('avgas'),
  );
  static const VerificationMeta _emptyWeightKgMeta = const VerificationMeta(
    'emptyWeightKg',
  );
  @override
  late final GeneratedColumn<double> emptyWeightKg = GeneratedColumn<double>(
    'empty_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxTakeoffWeightKgMeta =
      const VerificationMeta('maxTakeoffWeightKg');
  @override
  late final GeneratedColumn<double> maxTakeoffWeightKg =
      GeneratedColumn<double>(
        'max_takeoff_weight_kg',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _maxCrosswindKtMeta = const VerificationMeta(
    'maxCrosswindKt',
  );
  @override
  late final GeneratedColumn<int> maxCrosswindKt = GeneratedColumn<int>(
    'max_crosswind_kt',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icaoType,
    registration,
    cruiseTas,
    climbTas,
    climbRateFpm,
    descentRateFpm,
    fuelBurnLph,
    usableFuelL,
    fuelType,
    emptyWeightKg,
    maxTakeoffWeightKg,
    maxCrosswindKt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'aircraft_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<AircraftProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icao_type')) {
      context.handle(
        _icaoTypeMeta,
        icaoType.isAcceptableOrUnknown(data['icao_type']!, _icaoTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_icaoTypeMeta);
    }
    if (data.containsKey('registration')) {
      context.handle(
        _registrationMeta,
        registration.isAcceptableOrUnknown(
          data['registration']!,
          _registrationMeta,
        ),
      );
    }
    if (data.containsKey('cruise_tas')) {
      context.handle(
        _cruiseTasMeta,
        cruiseTas.isAcceptableOrUnknown(data['cruise_tas']!, _cruiseTasMeta),
      );
    } else if (isInserting) {
      context.missing(_cruiseTasMeta);
    }
    if (data.containsKey('climb_tas')) {
      context.handle(
        _climbTasMeta,
        climbTas.isAcceptableOrUnknown(data['climb_tas']!, _climbTasMeta),
      );
    }
    if (data.containsKey('climb_rate_fpm')) {
      context.handle(
        _climbRateFpmMeta,
        climbRateFpm.isAcceptableOrUnknown(
          data['climb_rate_fpm']!,
          _climbRateFpmMeta,
        ),
      );
    }
    if (data.containsKey('descent_rate_fpm')) {
      context.handle(
        _descentRateFpmMeta,
        descentRateFpm.isAcceptableOrUnknown(
          data['descent_rate_fpm']!,
          _descentRateFpmMeta,
        ),
      );
    }
    if (data.containsKey('fuel_burn_lph')) {
      context.handle(
        _fuelBurnLphMeta,
        fuelBurnLph.isAcceptableOrUnknown(
          data['fuel_burn_lph']!,
          _fuelBurnLphMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fuelBurnLphMeta);
    }
    if (data.containsKey('usable_fuel_l')) {
      context.handle(
        _usableFuelLMeta,
        usableFuelL.isAcceptableOrUnknown(
          data['usable_fuel_l']!,
          _usableFuelLMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_usableFuelLMeta);
    }
    if (data.containsKey('fuel_type')) {
      context.handle(
        _fuelTypeMeta,
        fuelType.isAcceptableOrUnknown(data['fuel_type']!, _fuelTypeMeta),
      );
    }
    if (data.containsKey('empty_weight_kg')) {
      context.handle(
        _emptyWeightKgMeta,
        emptyWeightKg.isAcceptableOrUnknown(
          data['empty_weight_kg']!,
          _emptyWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('max_takeoff_weight_kg')) {
      context.handle(
        _maxTakeoffWeightKgMeta,
        maxTakeoffWeightKg.isAcceptableOrUnknown(
          data['max_takeoff_weight_kg']!,
          _maxTakeoffWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('max_crosswind_kt')) {
      context.handle(
        _maxCrosswindKtMeta,
        maxCrosswindKt.isAcceptableOrUnknown(
          data['max_crosswind_kt']!,
          _maxCrosswindKtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AircraftProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AircraftProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icaoType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icao_type'],
      )!,
      registration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration'],
      )!,
      cruiseTas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cruise_tas'],
      )!,
      climbTas: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}climb_tas'],
      ),
      climbRateFpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}climb_rate_fpm'],
      ),
      descentRateFpm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}descent_rate_fpm'],
      ),
      fuelBurnLph: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fuel_burn_lph'],
      )!,
      usableFuelL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}usable_fuel_l'],
      )!,
      fuelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_type'],
      )!,
      emptyWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}empty_weight_kg'],
      ),
      maxTakeoffWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_takeoff_weight_kg'],
      ),
      maxCrosswindKt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_crosswind_kt'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $AircraftProfilesTable createAlias(String alias) {
    return $AircraftProfilesTable(attachedDatabase, alias);
  }
}

class AircraftProfile extends DataClass implements Insertable<AircraftProfile> {
  final int id;
  final String name;
  final String icaoType;
  final String registration;
  final int cruiseTas;
  final int? climbTas;
  final int? climbRateFpm;
  final int? descentRateFpm;
  final double fuelBurnLph;
  final double usableFuelL;

  /// Drives the fuel unit shown for this aircraft (avgas/jet-a).
  final String fuelType;
  final double? emptyWeightKg;
  final double? maxTakeoffWeightKg;

  /// Maximum demonstrated crosswind component.
  final int? maxCrosswindKt;
  final String notes;
  const AircraftProfile({
    required this.id,
    required this.name,
    required this.icaoType,
    required this.registration,
    required this.cruiseTas,
    this.climbTas,
    this.climbRateFpm,
    this.descentRateFpm,
    required this.fuelBurnLph,
    required this.usableFuelL,
    required this.fuelType,
    this.emptyWeightKg,
    this.maxTakeoffWeightKg,
    this.maxCrosswindKt,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icao_type'] = Variable<String>(icaoType);
    map['registration'] = Variable<String>(registration);
    map['cruise_tas'] = Variable<int>(cruiseTas);
    if (!nullToAbsent || climbTas != null) {
      map['climb_tas'] = Variable<int>(climbTas);
    }
    if (!nullToAbsent || climbRateFpm != null) {
      map['climb_rate_fpm'] = Variable<int>(climbRateFpm);
    }
    if (!nullToAbsent || descentRateFpm != null) {
      map['descent_rate_fpm'] = Variable<int>(descentRateFpm);
    }
    map['fuel_burn_lph'] = Variable<double>(fuelBurnLph);
    map['usable_fuel_l'] = Variable<double>(usableFuelL);
    map['fuel_type'] = Variable<String>(fuelType);
    if (!nullToAbsent || emptyWeightKg != null) {
      map['empty_weight_kg'] = Variable<double>(emptyWeightKg);
    }
    if (!nullToAbsent || maxTakeoffWeightKg != null) {
      map['max_takeoff_weight_kg'] = Variable<double>(maxTakeoffWeightKg);
    }
    if (!nullToAbsent || maxCrosswindKt != null) {
      map['max_crosswind_kt'] = Variable<int>(maxCrosswindKt);
    }
    map['notes'] = Variable<String>(notes);
    return map;
  }

  AircraftProfilesCompanion toCompanion(bool nullToAbsent) {
    return AircraftProfilesCompanion(
      id: Value(id),
      name: Value(name),
      icaoType: Value(icaoType),
      registration: Value(registration),
      cruiseTas: Value(cruiseTas),
      climbTas: climbTas == null && nullToAbsent
          ? const Value.absent()
          : Value(climbTas),
      climbRateFpm: climbRateFpm == null && nullToAbsent
          ? const Value.absent()
          : Value(climbRateFpm),
      descentRateFpm: descentRateFpm == null && nullToAbsent
          ? const Value.absent()
          : Value(descentRateFpm),
      fuelBurnLph: Value(fuelBurnLph),
      usableFuelL: Value(usableFuelL),
      fuelType: Value(fuelType),
      emptyWeightKg: emptyWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(emptyWeightKg),
      maxTakeoffWeightKg: maxTakeoffWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(maxTakeoffWeightKg),
      maxCrosswindKt: maxCrosswindKt == null && nullToAbsent
          ? const Value.absent()
          : Value(maxCrosswindKt),
      notes: Value(notes),
    );
  }

  factory AircraftProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AircraftProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icaoType: serializer.fromJson<String>(json['icaoType']),
      registration: serializer.fromJson<String>(json['registration']),
      cruiseTas: serializer.fromJson<int>(json['cruiseTas']),
      climbTas: serializer.fromJson<int?>(json['climbTas']),
      climbRateFpm: serializer.fromJson<int?>(json['climbRateFpm']),
      descentRateFpm: serializer.fromJson<int?>(json['descentRateFpm']),
      fuelBurnLph: serializer.fromJson<double>(json['fuelBurnLph']),
      usableFuelL: serializer.fromJson<double>(json['usableFuelL']),
      fuelType: serializer.fromJson<String>(json['fuelType']),
      emptyWeightKg: serializer.fromJson<double?>(json['emptyWeightKg']),
      maxTakeoffWeightKg: serializer.fromJson<double?>(
        json['maxTakeoffWeightKg'],
      ),
      maxCrosswindKt: serializer.fromJson<int?>(json['maxCrosswindKt']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icaoType': serializer.toJson<String>(icaoType),
      'registration': serializer.toJson<String>(registration),
      'cruiseTas': serializer.toJson<int>(cruiseTas),
      'climbTas': serializer.toJson<int?>(climbTas),
      'climbRateFpm': serializer.toJson<int?>(climbRateFpm),
      'descentRateFpm': serializer.toJson<int?>(descentRateFpm),
      'fuelBurnLph': serializer.toJson<double>(fuelBurnLph),
      'usableFuelL': serializer.toJson<double>(usableFuelL),
      'fuelType': serializer.toJson<String>(fuelType),
      'emptyWeightKg': serializer.toJson<double?>(emptyWeightKg),
      'maxTakeoffWeightKg': serializer.toJson<double?>(maxTakeoffWeightKg),
      'maxCrosswindKt': serializer.toJson<int?>(maxCrosswindKt),
      'notes': serializer.toJson<String>(notes),
    };
  }

  AircraftProfile copyWith({
    int? id,
    String? name,
    String? icaoType,
    String? registration,
    int? cruiseTas,
    Value<int?> climbTas = const Value.absent(),
    Value<int?> climbRateFpm = const Value.absent(),
    Value<int?> descentRateFpm = const Value.absent(),
    double? fuelBurnLph,
    double? usableFuelL,
    String? fuelType,
    Value<double?> emptyWeightKg = const Value.absent(),
    Value<double?> maxTakeoffWeightKg = const Value.absent(),
    Value<int?> maxCrosswindKt = const Value.absent(),
    String? notes,
  }) => AircraftProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    icaoType: icaoType ?? this.icaoType,
    registration: registration ?? this.registration,
    cruiseTas: cruiseTas ?? this.cruiseTas,
    climbTas: climbTas.present ? climbTas.value : this.climbTas,
    climbRateFpm: climbRateFpm.present ? climbRateFpm.value : this.climbRateFpm,
    descentRateFpm: descentRateFpm.present
        ? descentRateFpm.value
        : this.descentRateFpm,
    fuelBurnLph: fuelBurnLph ?? this.fuelBurnLph,
    usableFuelL: usableFuelL ?? this.usableFuelL,
    fuelType: fuelType ?? this.fuelType,
    emptyWeightKg: emptyWeightKg.present
        ? emptyWeightKg.value
        : this.emptyWeightKg,
    maxTakeoffWeightKg: maxTakeoffWeightKg.present
        ? maxTakeoffWeightKg.value
        : this.maxTakeoffWeightKg,
    maxCrosswindKt: maxCrosswindKt.present
        ? maxCrosswindKt.value
        : this.maxCrosswindKt,
    notes: notes ?? this.notes,
  );
  AircraftProfile copyWithCompanion(AircraftProfilesCompanion data) {
    return AircraftProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icaoType: data.icaoType.present ? data.icaoType.value : this.icaoType,
      registration: data.registration.present
          ? data.registration.value
          : this.registration,
      cruiseTas: data.cruiseTas.present ? data.cruiseTas.value : this.cruiseTas,
      climbTas: data.climbTas.present ? data.climbTas.value : this.climbTas,
      climbRateFpm: data.climbRateFpm.present
          ? data.climbRateFpm.value
          : this.climbRateFpm,
      descentRateFpm: data.descentRateFpm.present
          ? data.descentRateFpm.value
          : this.descentRateFpm,
      fuelBurnLph: data.fuelBurnLph.present
          ? data.fuelBurnLph.value
          : this.fuelBurnLph,
      usableFuelL: data.usableFuelL.present
          ? data.usableFuelL.value
          : this.usableFuelL,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      emptyWeightKg: data.emptyWeightKg.present
          ? data.emptyWeightKg.value
          : this.emptyWeightKg,
      maxTakeoffWeightKg: data.maxTakeoffWeightKg.present
          ? data.maxTakeoffWeightKg.value
          : this.maxTakeoffWeightKg,
      maxCrosswindKt: data.maxCrosswindKt.present
          ? data.maxCrosswindKt.value
          : this.maxCrosswindKt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AircraftProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icaoType: $icaoType, ')
          ..write('registration: $registration, ')
          ..write('cruiseTas: $cruiseTas, ')
          ..write('climbTas: $climbTas, ')
          ..write('climbRateFpm: $climbRateFpm, ')
          ..write('descentRateFpm: $descentRateFpm, ')
          ..write('fuelBurnLph: $fuelBurnLph, ')
          ..write('usableFuelL: $usableFuelL, ')
          ..write('fuelType: $fuelType, ')
          ..write('emptyWeightKg: $emptyWeightKg, ')
          ..write('maxTakeoffWeightKg: $maxTakeoffWeightKg, ')
          ..write('maxCrosswindKt: $maxCrosswindKt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    icaoType,
    registration,
    cruiseTas,
    climbTas,
    climbRateFpm,
    descentRateFpm,
    fuelBurnLph,
    usableFuelL,
    fuelType,
    emptyWeightKg,
    maxTakeoffWeightKg,
    maxCrosswindKt,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AircraftProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.icaoType == this.icaoType &&
          other.registration == this.registration &&
          other.cruiseTas == this.cruiseTas &&
          other.climbTas == this.climbTas &&
          other.climbRateFpm == this.climbRateFpm &&
          other.descentRateFpm == this.descentRateFpm &&
          other.fuelBurnLph == this.fuelBurnLph &&
          other.usableFuelL == this.usableFuelL &&
          other.fuelType == this.fuelType &&
          other.emptyWeightKg == this.emptyWeightKg &&
          other.maxTakeoffWeightKg == this.maxTakeoffWeightKg &&
          other.maxCrosswindKt == this.maxCrosswindKt &&
          other.notes == this.notes);
}

class AircraftProfilesCompanion extends UpdateCompanion<AircraftProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icaoType;
  final Value<String> registration;
  final Value<int> cruiseTas;
  final Value<int?> climbTas;
  final Value<int?> climbRateFpm;
  final Value<int?> descentRateFpm;
  final Value<double> fuelBurnLph;
  final Value<double> usableFuelL;
  final Value<String> fuelType;
  final Value<double?> emptyWeightKg;
  final Value<double?> maxTakeoffWeightKg;
  final Value<int?> maxCrosswindKt;
  final Value<String> notes;
  const AircraftProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icaoType = const Value.absent(),
    this.registration = const Value.absent(),
    this.cruiseTas = const Value.absent(),
    this.climbTas = const Value.absent(),
    this.climbRateFpm = const Value.absent(),
    this.descentRateFpm = const Value.absent(),
    this.fuelBurnLph = const Value.absent(),
    this.usableFuelL = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.emptyWeightKg = const Value.absent(),
    this.maxTakeoffWeightKg = const Value.absent(),
    this.maxCrosswindKt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  AircraftProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icaoType,
    this.registration = const Value.absent(),
    required int cruiseTas,
    this.climbTas = const Value.absent(),
    this.climbRateFpm = const Value.absent(),
    this.descentRateFpm = const Value.absent(),
    required double fuelBurnLph,
    required double usableFuelL,
    this.fuelType = const Value.absent(),
    this.emptyWeightKg = const Value.absent(),
    this.maxTakeoffWeightKg = const Value.absent(),
    this.maxCrosswindKt = const Value.absent(),
    this.notes = const Value.absent(),
  }) : name = Value(name),
       icaoType = Value(icaoType),
       cruiseTas = Value(cruiseTas),
       fuelBurnLph = Value(fuelBurnLph),
       usableFuelL = Value(usableFuelL);
  static Insertable<AircraftProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icaoType,
    Expression<String>? registration,
    Expression<int>? cruiseTas,
    Expression<int>? climbTas,
    Expression<int>? climbRateFpm,
    Expression<int>? descentRateFpm,
    Expression<double>? fuelBurnLph,
    Expression<double>? usableFuelL,
    Expression<String>? fuelType,
    Expression<double>? emptyWeightKg,
    Expression<double>? maxTakeoffWeightKg,
    Expression<int>? maxCrosswindKt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icaoType != null) 'icao_type': icaoType,
      if (registration != null) 'registration': registration,
      if (cruiseTas != null) 'cruise_tas': cruiseTas,
      if (climbTas != null) 'climb_tas': climbTas,
      if (climbRateFpm != null) 'climb_rate_fpm': climbRateFpm,
      if (descentRateFpm != null) 'descent_rate_fpm': descentRateFpm,
      if (fuelBurnLph != null) 'fuel_burn_lph': fuelBurnLph,
      if (usableFuelL != null) 'usable_fuel_l': usableFuelL,
      if (fuelType != null) 'fuel_type': fuelType,
      if (emptyWeightKg != null) 'empty_weight_kg': emptyWeightKg,
      if (maxTakeoffWeightKg != null)
        'max_takeoff_weight_kg': maxTakeoffWeightKg,
      if (maxCrosswindKt != null) 'max_crosswind_kt': maxCrosswindKt,
      if (notes != null) 'notes': notes,
    });
  }

  AircraftProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icaoType,
    Value<String>? registration,
    Value<int>? cruiseTas,
    Value<int?>? climbTas,
    Value<int?>? climbRateFpm,
    Value<int?>? descentRateFpm,
    Value<double>? fuelBurnLph,
    Value<double>? usableFuelL,
    Value<String>? fuelType,
    Value<double?>? emptyWeightKg,
    Value<double?>? maxTakeoffWeightKg,
    Value<int?>? maxCrosswindKt,
    Value<String>? notes,
  }) {
    return AircraftProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icaoType: icaoType ?? this.icaoType,
      registration: registration ?? this.registration,
      cruiseTas: cruiseTas ?? this.cruiseTas,
      climbTas: climbTas ?? this.climbTas,
      climbRateFpm: climbRateFpm ?? this.climbRateFpm,
      descentRateFpm: descentRateFpm ?? this.descentRateFpm,
      fuelBurnLph: fuelBurnLph ?? this.fuelBurnLph,
      usableFuelL: usableFuelL ?? this.usableFuelL,
      fuelType: fuelType ?? this.fuelType,
      emptyWeightKg: emptyWeightKg ?? this.emptyWeightKg,
      maxTakeoffWeightKg: maxTakeoffWeightKg ?? this.maxTakeoffWeightKg,
      maxCrosswindKt: maxCrosswindKt ?? this.maxCrosswindKt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icaoType.present) {
      map['icao_type'] = Variable<String>(icaoType.value);
    }
    if (registration.present) {
      map['registration'] = Variable<String>(registration.value);
    }
    if (cruiseTas.present) {
      map['cruise_tas'] = Variable<int>(cruiseTas.value);
    }
    if (climbTas.present) {
      map['climb_tas'] = Variable<int>(climbTas.value);
    }
    if (climbRateFpm.present) {
      map['climb_rate_fpm'] = Variable<int>(climbRateFpm.value);
    }
    if (descentRateFpm.present) {
      map['descent_rate_fpm'] = Variable<int>(descentRateFpm.value);
    }
    if (fuelBurnLph.present) {
      map['fuel_burn_lph'] = Variable<double>(fuelBurnLph.value);
    }
    if (usableFuelL.present) {
      map['usable_fuel_l'] = Variable<double>(usableFuelL.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(fuelType.value);
    }
    if (emptyWeightKg.present) {
      map['empty_weight_kg'] = Variable<double>(emptyWeightKg.value);
    }
    if (maxTakeoffWeightKg.present) {
      map['max_takeoff_weight_kg'] = Variable<double>(maxTakeoffWeightKg.value);
    }
    if (maxCrosswindKt.present) {
      map['max_crosswind_kt'] = Variable<int>(maxCrosswindKt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AircraftProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icaoType: $icaoType, ')
          ..write('registration: $registration, ')
          ..write('cruiseTas: $cruiseTas, ')
          ..write('climbTas: $climbTas, ')
          ..write('climbRateFpm: $climbRateFpm, ')
          ..write('descentRateFpm: $descentRateFpm, ')
          ..write('fuelBurnLph: $fuelBurnLph, ')
          ..write('usableFuelL: $usableFuelL, ')
          ..write('fuelType: $fuelType, ')
          ..write('emptyWeightKg: $emptyWeightKg, ')
          ..write('maxTakeoffWeightKg: $maxTakeoffWeightKg, ')
          ..write('maxCrosswindKt: $maxCrosswindKt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $FlightsTable extends Flights with TableInfo<$FlightsTable, Flight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FlightRules, String> rules =
      GeneratedColumn<String>(
        'rules',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FlightRules>($FlightsTable.$converterrules);
  @override
  late final GeneratedColumnWithTypeConverter<FlightStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('planned'),
      ).withConverter<FlightStatus>($FlightsTable.$converterstatus);
  static const VerificationMeta _aircraftIdMeta = const VerificationMeta(
    'aircraftId',
  );
  @override
  late final GeneratedColumn<int> aircraftId = GeneratedColumn<int>(
    'aircraft_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES aircraft_profiles (id)',
    ),
  );
  static const VerificationMeta _departureIdentMeta = const VerificationMeta(
    'departureIdent',
  );
  @override
  late final GeneratedColumn<String> departureIdent = GeneratedColumn<String>(
    'departure_ident',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationIdentMeta = const VerificationMeta(
    'destinationIdent',
  );
  @override
  late final GeneratedColumn<String> destinationIdent = GeneratedColumn<String>(
    'destination_ident',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alternateIdentMeta = const VerificationMeta(
    'alternateIdent',
  );
  @override
  late final GeneratedColumn<String> alternateIdent = GeneratedColumn<String>(
    'alternate_ident',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departureRunwayMeta = const VerificationMeta(
    'departureRunway',
  );
  @override
  late final GeneratedColumn<String> departureRunway = GeneratedColumn<String>(
    'departure_runway',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _arrivalRunwayMeta = const VerificationMeta(
    'arrivalRunway',
  );
  @override
  late final GeneratedColumn<String> arrivalRunway = GeneratedColumn<String>(
    'arrival_runway',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cruiseAltitudeFtMeta = const VerificationMeta(
    'cruiseAltitudeFt',
  );
  @override
  late final GeneratedColumn<int> cruiseAltitudeFt = GeneratedColumn<int>(
    'cruise_altitude_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedDepartureMeta = const VerificationMeta(
    'plannedDeparture',
  );
  @override
  late final GeneratedColumn<DateTime> plannedDeparture =
      GeneratedColumn<DateTime>(
        'planned_departure',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _windDirectionMeta = const VerificationMeta(
    'windDirection',
  );
  @override
  late final GeneratedColumn<int> windDirection = GeneratedColumn<int>(
    'wind_direction',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windSpeedKtMeta = const VerificationMeta(
    'windSpeedKt',
  );
  @override
  late final GeneratedColumn<int> windSpeedKt = GeneratedColumn<int>(
    'wind_speed_kt',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _blockOffAtMeta = const VerificationMeta(
    'blockOffAt',
  );
  @override
  late final GeneratedColumn<DateTime> blockOffAt = GeneratedColumn<DateTime>(
    'block_off_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _takeoffAtMeta = const VerificationMeta(
    'takeoffAt',
  );
  @override
  late final GeneratedColumn<DateTime> takeoffAt = GeneratedColumn<DateTime>(
    'takeoff_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _landingAtMeta = const VerificationMeta(
    'landingAt',
  );
  @override
  late final GeneratedColumn<DateTime> landingAt = GeneratedColumn<DateTime>(
    'landing_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _blockOnAtMeta = const VerificationMeta(
    'blockOnAt',
  );
  @override
  late final GeneratedColumn<DateTime> blockOnAt = GeneratedColumn<DateTime>(
    'block_on_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    rules,
    status,
    aircraftId,
    departureIdent,
    destinationIdent,
    alternateIdent,
    departureRunway,
    arrivalRunway,
    cruiseAltitudeFt,
    plannedDeparture,
    windDirection,
    windSpeedKt,
    notes,
    blockOffAt,
    takeoffAt,
    landingAt,
    blockOnAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flights';
  @override
  VerificationContext validateIntegrity(
    Insertable<Flight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('aircraft_id')) {
      context.handle(
        _aircraftIdMeta,
        aircraftId.isAcceptableOrUnknown(data['aircraft_id']!, _aircraftIdMeta),
      );
    }
    if (data.containsKey('departure_ident')) {
      context.handle(
        _departureIdentMeta,
        departureIdent.isAcceptableOrUnknown(
          data['departure_ident']!,
          _departureIdentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departureIdentMeta);
    }
    if (data.containsKey('destination_ident')) {
      context.handle(
        _destinationIdentMeta,
        destinationIdent.isAcceptableOrUnknown(
          data['destination_ident']!,
          _destinationIdentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationIdentMeta);
    }
    if (data.containsKey('alternate_ident')) {
      context.handle(
        _alternateIdentMeta,
        alternateIdent.isAcceptableOrUnknown(
          data['alternate_ident']!,
          _alternateIdentMeta,
        ),
      );
    }
    if (data.containsKey('departure_runway')) {
      context.handle(
        _departureRunwayMeta,
        departureRunway.isAcceptableOrUnknown(
          data['departure_runway']!,
          _departureRunwayMeta,
        ),
      );
    }
    if (data.containsKey('arrival_runway')) {
      context.handle(
        _arrivalRunwayMeta,
        arrivalRunway.isAcceptableOrUnknown(
          data['arrival_runway']!,
          _arrivalRunwayMeta,
        ),
      );
    }
    if (data.containsKey('cruise_altitude_ft')) {
      context.handle(
        _cruiseAltitudeFtMeta,
        cruiseAltitudeFt.isAcceptableOrUnknown(
          data['cruise_altitude_ft']!,
          _cruiseAltitudeFtMeta,
        ),
      );
    }
    if (data.containsKey('planned_departure')) {
      context.handle(
        _plannedDepartureMeta,
        plannedDeparture.isAcceptableOrUnknown(
          data['planned_departure']!,
          _plannedDepartureMeta,
        ),
      );
    }
    if (data.containsKey('wind_direction')) {
      context.handle(
        _windDirectionMeta,
        windDirection.isAcceptableOrUnknown(
          data['wind_direction']!,
          _windDirectionMeta,
        ),
      );
    }
    if (data.containsKey('wind_speed_kt')) {
      context.handle(
        _windSpeedKtMeta,
        windSpeedKt.isAcceptableOrUnknown(
          data['wind_speed_kt']!,
          _windSpeedKtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('block_off_at')) {
      context.handle(
        _blockOffAtMeta,
        blockOffAt.isAcceptableOrUnknown(
          data['block_off_at']!,
          _blockOffAtMeta,
        ),
      );
    }
    if (data.containsKey('takeoff_at')) {
      context.handle(
        _takeoffAtMeta,
        takeoffAt.isAcceptableOrUnknown(data['takeoff_at']!, _takeoffAtMeta),
      );
    }
    if (data.containsKey('landing_at')) {
      context.handle(
        _landingAtMeta,
        landingAt.isAcceptableOrUnknown(data['landing_at']!, _landingAtMeta),
      );
    }
    if (data.containsKey('block_on_at')) {
      context.handle(
        _blockOnAtMeta,
        blockOnAt.isAcceptableOrUnknown(data['block_on_at']!, _blockOnAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Flight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Flight(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      rules: $FlightsTable.$converterrules.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}rules'],
        )!,
      ),
      status: $FlightsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      aircraftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aircraft_id'],
      ),
      departureIdent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departure_ident'],
      )!,
      destinationIdent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_ident'],
      )!,
      alternateIdent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alternate_ident'],
      ),
      departureRunway: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departure_runway'],
      ),
      arrivalRunway: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arrival_runway'],
      ),
      cruiseAltitudeFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cruise_altitude_ft'],
      ),
      plannedDeparture: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_departure'],
      ),
      windDirection: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wind_direction'],
      ),
      windSpeedKt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wind_speed_kt'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      blockOffAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}block_off_at'],
      ),
      takeoffAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}takeoff_at'],
      ),
      landingAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}landing_at'],
      ),
      blockOnAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}block_on_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FlightsTable createAlias(String alias) {
    return $FlightsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FlightRules, String, String> $converterrules =
      const EnumNameConverter<FlightRules>(FlightRules.values);
  static JsonTypeConverter2<FlightStatus, String, String> $converterstatus =
      const EnumNameConverter<FlightStatus>(FlightStatus.values);
}

class Flight extends DataClass implements Insertable<Flight> {
  final int id;
  final String title;
  final FlightRules rules;
  final FlightStatus status;
  final int? aircraftId;
  final String departureIdent;
  final String destinationIdent;
  final String? alternateIdent;

  /// Expected runway ends, e.g. `26` or `08R`.
  final String? departureRunway;
  final String? arrivalRunway;
  final int? cruiseAltitudeFt;
  final DateTime? plannedDeparture;

  /// Wind used for every leg without its own wind (true direction, from).
  final int? windDirection;
  final int? windSpeedKt;
  final String notes;
  final DateTime? blockOffAt;
  final DateTime? takeoffAt;
  final DateTime? landingAt;
  final DateTime? blockOnAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Flight({
    required this.id,
    required this.title,
    required this.rules,
    required this.status,
    this.aircraftId,
    required this.departureIdent,
    required this.destinationIdent,
    this.alternateIdent,
    this.departureRunway,
    this.arrivalRunway,
    this.cruiseAltitudeFt,
    this.plannedDeparture,
    this.windDirection,
    this.windSpeedKt,
    required this.notes,
    this.blockOffAt,
    this.takeoffAt,
    this.landingAt,
    this.blockOnAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    {
      map['rules'] = Variable<String>(
        $FlightsTable.$converterrules.toSql(rules),
      );
    }
    {
      map['status'] = Variable<String>(
        $FlightsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || aircraftId != null) {
      map['aircraft_id'] = Variable<int>(aircraftId);
    }
    map['departure_ident'] = Variable<String>(departureIdent);
    map['destination_ident'] = Variable<String>(destinationIdent);
    if (!nullToAbsent || alternateIdent != null) {
      map['alternate_ident'] = Variable<String>(alternateIdent);
    }
    if (!nullToAbsent || departureRunway != null) {
      map['departure_runway'] = Variable<String>(departureRunway);
    }
    if (!nullToAbsent || arrivalRunway != null) {
      map['arrival_runway'] = Variable<String>(arrivalRunway);
    }
    if (!nullToAbsent || cruiseAltitudeFt != null) {
      map['cruise_altitude_ft'] = Variable<int>(cruiseAltitudeFt);
    }
    if (!nullToAbsent || plannedDeparture != null) {
      map['planned_departure'] = Variable<DateTime>(plannedDeparture);
    }
    if (!nullToAbsent || windDirection != null) {
      map['wind_direction'] = Variable<int>(windDirection);
    }
    if (!nullToAbsent || windSpeedKt != null) {
      map['wind_speed_kt'] = Variable<int>(windSpeedKt);
    }
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || blockOffAt != null) {
      map['block_off_at'] = Variable<DateTime>(blockOffAt);
    }
    if (!nullToAbsent || takeoffAt != null) {
      map['takeoff_at'] = Variable<DateTime>(takeoffAt);
    }
    if (!nullToAbsent || landingAt != null) {
      map['landing_at'] = Variable<DateTime>(landingAt);
    }
    if (!nullToAbsent || blockOnAt != null) {
      map['block_on_at'] = Variable<DateTime>(blockOnAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FlightsCompanion toCompanion(bool nullToAbsent) {
    return FlightsCompanion(
      id: Value(id),
      title: Value(title),
      rules: Value(rules),
      status: Value(status),
      aircraftId: aircraftId == null && nullToAbsent
          ? const Value.absent()
          : Value(aircraftId),
      departureIdent: Value(departureIdent),
      destinationIdent: Value(destinationIdent),
      alternateIdent: alternateIdent == null && nullToAbsent
          ? const Value.absent()
          : Value(alternateIdent),
      departureRunway: departureRunway == null && nullToAbsent
          ? const Value.absent()
          : Value(departureRunway),
      arrivalRunway: arrivalRunway == null && nullToAbsent
          ? const Value.absent()
          : Value(arrivalRunway),
      cruiseAltitudeFt: cruiseAltitudeFt == null && nullToAbsent
          ? const Value.absent()
          : Value(cruiseAltitudeFt),
      plannedDeparture: plannedDeparture == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedDeparture),
      windDirection: windDirection == null && nullToAbsent
          ? const Value.absent()
          : Value(windDirection),
      windSpeedKt: windSpeedKt == null && nullToAbsent
          ? const Value.absent()
          : Value(windSpeedKt),
      notes: Value(notes),
      blockOffAt: blockOffAt == null && nullToAbsent
          ? const Value.absent()
          : Value(blockOffAt),
      takeoffAt: takeoffAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takeoffAt),
      landingAt: landingAt == null && nullToAbsent
          ? const Value.absent()
          : Value(landingAt),
      blockOnAt: blockOnAt == null && nullToAbsent
          ? const Value.absent()
          : Value(blockOnAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Flight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Flight(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      rules: $FlightsTable.$converterrules.fromJson(
        serializer.fromJson<String>(json['rules']),
      ),
      status: $FlightsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      aircraftId: serializer.fromJson<int?>(json['aircraftId']),
      departureIdent: serializer.fromJson<String>(json['departureIdent']),
      destinationIdent: serializer.fromJson<String>(json['destinationIdent']),
      alternateIdent: serializer.fromJson<String?>(json['alternateIdent']),
      departureRunway: serializer.fromJson<String?>(json['departureRunway']),
      arrivalRunway: serializer.fromJson<String?>(json['arrivalRunway']),
      cruiseAltitudeFt: serializer.fromJson<int?>(json['cruiseAltitudeFt']),
      plannedDeparture: serializer.fromJson<DateTime?>(
        json['plannedDeparture'],
      ),
      windDirection: serializer.fromJson<int?>(json['windDirection']),
      windSpeedKt: serializer.fromJson<int?>(json['windSpeedKt']),
      notes: serializer.fromJson<String>(json['notes']),
      blockOffAt: serializer.fromJson<DateTime?>(json['blockOffAt']),
      takeoffAt: serializer.fromJson<DateTime?>(json['takeoffAt']),
      landingAt: serializer.fromJson<DateTime?>(json['landingAt']),
      blockOnAt: serializer.fromJson<DateTime?>(json['blockOnAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'rules': serializer.toJson<String>(
        $FlightsTable.$converterrules.toJson(rules),
      ),
      'status': serializer.toJson<String>(
        $FlightsTable.$converterstatus.toJson(status),
      ),
      'aircraftId': serializer.toJson<int?>(aircraftId),
      'departureIdent': serializer.toJson<String>(departureIdent),
      'destinationIdent': serializer.toJson<String>(destinationIdent),
      'alternateIdent': serializer.toJson<String?>(alternateIdent),
      'departureRunway': serializer.toJson<String?>(departureRunway),
      'arrivalRunway': serializer.toJson<String?>(arrivalRunway),
      'cruiseAltitudeFt': serializer.toJson<int?>(cruiseAltitudeFt),
      'plannedDeparture': serializer.toJson<DateTime?>(plannedDeparture),
      'windDirection': serializer.toJson<int?>(windDirection),
      'windSpeedKt': serializer.toJson<int?>(windSpeedKt),
      'notes': serializer.toJson<String>(notes),
      'blockOffAt': serializer.toJson<DateTime?>(blockOffAt),
      'takeoffAt': serializer.toJson<DateTime?>(takeoffAt),
      'landingAt': serializer.toJson<DateTime?>(landingAt),
      'blockOnAt': serializer.toJson<DateTime?>(blockOnAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Flight copyWith({
    int? id,
    String? title,
    FlightRules? rules,
    FlightStatus? status,
    Value<int?> aircraftId = const Value.absent(),
    String? departureIdent,
    String? destinationIdent,
    Value<String?> alternateIdent = const Value.absent(),
    Value<String?> departureRunway = const Value.absent(),
    Value<String?> arrivalRunway = const Value.absent(),
    Value<int?> cruiseAltitudeFt = const Value.absent(),
    Value<DateTime?> plannedDeparture = const Value.absent(),
    Value<int?> windDirection = const Value.absent(),
    Value<int?> windSpeedKt = const Value.absent(),
    String? notes,
    Value<DateTime?> blockOffAt = const Value.absent(),
    Value<DateTime?> takeoffAt = const Value.absent(),
    Value<DateTime?> landingAt = const Value.absent(),
    Value<DateTime?> blockOnAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Flight(
    id: id ?? this.id,
    title: title ?? this.title,
    rules: rules ?? this.rules,
    status: status ?? this.status,
    aircraftId: aircraftId.present ? aircraftId.value : this.aircraftId,
    departureIdent: departureIdent ?? this.departureIdent,
    destinationIdent: destinationIdent ?? this.destinationIdent,
    alternateIdent: alternateIdent.present
        ? alternateIdent.value
        : this.alternateIdent,
    departureRunway: departureRunway.present
        ? departureRunway.value
        : this.departureRunway,
    arrivalRunway: arrivalRunway.present
        ? arrivalRunway.value
        : this.arrivalRunway,
    cruiseAltitudeFt: cruiseAltitudeFt.present
        ? cruiseAltitudeFt.value
        : this.cruiseAltitudeFt,
    plannedDeparture: plannedDeparture.present
        ? plannedDeparture.value
        : this.plannedDeparture,
    windDirection: windDirection.present
        ? windDirection.value
        : this.windDirection,
    windSpeedKt: windSpeedKt.present ? windSpeedKt.value : this.windSpeedKt,
    notes: notes ?? this.notes,
    blockOffAt: blockOffAt.present ? blockOffAt.value : this.blockOffAt,
    takeoffAt: takeoffAt.present ? takeoffAt.value : this.takeoffAt,
    landingAt: landingAt.present ? landingAt.value : this.landingAt,
    blockOnAt: blockOnAt.present ? blockOnAt.value : this.blockOnAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Flight copyWithCompanion(FlightsCompanion data) {
    return Flight(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      rules: data.rules.present ? data.rules.value : this.rules,
      status: data.status.present ? data.status.value : this.status,
      aircraftId: data.aircraftId.present
          ? data.aircraftId.value
          : this.aircraftId,
      departureIdent: data.departureIdent.present
          ? data.departureIdent.value
          : this.departureIdent,
      destinationIdent: data.destinationIdent.present
          ? data.destinationIdent.value
          : this.destinationIdent,
      alternateIdent: data.alternateIdent.present
          ? data.alternateIdent.value
          : this.alternateIdent,
      departureRunway: data.departureRunway.present
          ? data.departureRunway.value
          : this.departureRunway,
      arrivalRunway: data.arrivalRunway.present
          ? data.arrivalRunway.value
          : this.arrivalRunway,
      cruiseAltitudeFt: data.cruiseAltitudeFt.present
          ? data.cruiseAltitudeFt.value
          : this.cruiseAltitudeFt,
      plannedDeparture: data.plannedDeparture.present
          ? data.plannedDeparture.value
          : this.plannedDeparture,
      windDirection: data.windDirection.present
          ? data.windDirection.value
          : this.windDirection,
      windSpeedKt: data.windSpeedKt.present
          ? data.windSpeedKt.value
          : this.windSpeedKt,
      notes: data.notes.present ? data.notes.value : this.notes,
      blockOffAt: data.blockOffAt.present
          ? data.blockOffAt.value
          : this.blockOffAt,
      takeoffAt: data.takeoffAt.present ? data.takeoffAt.value : this.takeoffAt,
      landingAt: data.landingAt.present ? data.landingAt.value : this.landingAt,
      blockOnAt: data.blockOnAt.present ? data.blockOnAt.value : this.blockOnAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Flight(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('rules: $rules, ')
          ..write('status: $status, ')
          ..write('aircraftId: $aircraftId, ')
          ..write('departureIdent: $departureIdent, ')
          ..write('destinationIdent: $destinationIdent, ')
          ..write('alternateIdent: $alternateIdent, ')
          ..write('departureRunway: $departureRunway, ')
          ..write('arrivalRunway: $arrivalRunway, ')
          ..write('cruiseAltitudeFt: $cruiseAltitudeFt, ')
          ..write('plannedDeparture: $plannedDeparture, ')
          ..write('windDirection: $windDirection, ')
          ..write('windSpeedKt: $windSpeedKt, ')
          ..write('notes: $notes, ')
          ..write('blockOffAt: $blockOffAt, ')
          ..write('takeoffAt: $takeoffAt, ')
          ..write('landingAt: $landingAt, ')
          ..write('blockOnAt: $blockOnAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    rules,
    status,
    aircraftId,
    departureIdent,
    destinationIdent,
    alternateIdent,
    departureRunway,
    arrivalRunway,
    cruiseAltitudeFt,
    plannedDeparture,
    windDirection,
    windSpeedKt,
    notes,
    blockOffAt,
    takeoffAt,
    landingAt,
    blockOnAt,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Flight &&
          other.id == this.id &&
          other.title == this.title &&
          other.rules == this.rules &&
          other.status == this.status &&
          other.aircraftId == this.aircraftId &&
          other.departureIdent == this.departureIdent &&
          other.destinationIdent == this.destinationIdent &&
          other.alternateIdent == this.alternateIdent &&
          other.departureRunway == this.departureRunway &&
          other.arrivalRunway == this.arrivalRunway &&
          other.cruiseAltitudeFt == this.cruiseAltitudeFt &&
          other.plannedDeparture == this.plannedDeparture &&
          other.windDirection == this.windDirection &&
          other.windSpeedKt == this.windSpeedKt &&
          other.notes == this.notes &&
          other.blockOffAt == this.blockOffAt &&
          other.takeoffAt == this.takeoffAt &&
          other.landingAt == this.landingAt &&
          other.blockOnAt == this.blockOnAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FlightsCompanion extends UpdateCompanion<Flight> {
  final Value<int> id;
  final Value<String> title;
  final Value<FlightRules> rules;
  final Value<FlightStatus> status;
  final Value<int?> aircraftId;
  final Value<String> departureIdent;
  final Value<String> destinationIdent;
  final Value<String?> alternateIdent;
  final Value<String?> departureRunway;
  final Value<String?> arrivalRunway;
  final Value<int?> cruiseAltitudeFt;
  final Value<DateTime?> plannedDeparture;
  final Value<int?> windDirection;
  final Value<int?> windSpeedKt;
  final Value<String> notes;
  final Value<DateTime?> blockOffAt;
  final Value<DateTime?> takeoffAt;
  final Value<DateTime?> landingAt;
  final Value<DateTime?> blockOnAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FlightsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.rules = const Value.absent(),
    this.status = const Value.absent(),
    this.aircraftId = const Value.absent(),
    this.departureIdent = const Value.absent(),
    this.destinationIdent = const Value.absent(),
    this.alternateIdent = const Value.absent(),
    this.departureRunway = const Value.absent(),
    this.arrivalRunway = const Value.absent(),
    this.cruiseAltitudeFt = const Value.absent(),
    this.plannedDeparture = const Value.absent(),
    this.windDirection = const Value.absent(),
    this.windSpeedKt = const Value.absent(),
    this.notes = const Value.absent(),
    this.blockOffAt = const Value.absent(),
    this.takeoffAt = const Value.absent(),
    this.landingAt = const Value.absent(),
    this.blockOnAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FlightsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required FlightRules rules,
    this.status = const Value.absent(),
    this.aircraftId = const Value.absent(),
    required String departureIdent,
    required String destinationIdent,
    this.alternateIdent = const Value.absent(),
    this.departureRunway = const Value.absent(),
    this.arrivalRunway = const Value.absent(),
    this.cruiseAltitudeFt = const Value.absent(),
    this.plannedDeparture = const Value.absent(),
    this.windDirection = const Value.absent(),
    this.windSpeedKt = const Value.absent(),
    this.notes = const Value.absent(),
    this.blockOffAt = const Value.absent(),
    this.takeoffAt = const Value.absent(),
    this.landingAt = const Value.absent(),
    this.blockOnAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       rules = Value(rules),
       departureIdent = Value(departureIdent),
       destinationIdent = Value(destinationIdent);
  static Insertable<Flight> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? rules,
    Expression<String>? status,
    Expression<int>? aircraftId,
    Expression<String>? departureIdent,
    Expression<String>? destinationIdent,
    Expression<String>? alternateIdent,
    Expression<String>? departureRunway,
    Expression<String>? arrivalRunway,
    Expression<int>? cruiseAltitudeFt,
    Expression<DateTime>? plannedDeparture,
    Expression<int>? windDirection,
    Expression<int>? windSpeedKt,
    Expression<String>? notes,
    Expression<DateTime>? blockOffAt,
    Expression<DateTime>? takeoffAt,
    Expression<DateTime>? landingAt,
    Expression<DateTime>? blockOnAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (rules != null) 'rules': rules,
      if (status != null) 'status': status,
      if (aircraftId != null) 'aircraft_id': aircraftId,
      if (departureIdent != null) 'departure_ident': departureIdent,
      if (destinationIdent != null) 'destination_ident': destinationIdent,
      if (alternateIdent != null) 'alternate_ident': alternateIdent,
      if (departureRunway != null) 'departure_runway': departureRunway,
      if (arrivalRunway != null) 'arrival_runway': arrivalRunway,
      if (cruiseAltitudeFt != null) 'cruise_altitude_ft': cruiseAltitudeFt,
      if (plannedDeparture != null) 'planned_departure': plannedDeparture,
      if (windDirection != null) 'wind_direction': windDirection,
      if (windSpeedKt != null) 'wind_speed_kt': windSpeedKt,
      if (notes != null) 'notes': notes,
      if (blockOffAt != null) 'block_off_at': blockOffAt,
      if (takeoffAt != null) 'takeoff_at': takeoffAt,
      if (landingAt != null) 'landing_at': landingAt,
      if (blockOnAt != null) 'block_on_at': blockOnAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FlightsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<FlightRules>? rules,
    Value<FlightStatus>? status,
    Value<int?>? aircraftId,
    Value<String>? departureIdent,
    Value<String>? destinationIdent,
    Value<String?>? alternateIdent,
    Value<String?>? departureRunway,
    Value<String?>? arrivalRunway,
    Value<int?>? cruiseAltitudeFt,
    Value<DateTime?>? plannedDeparture,
    Value<int?>? windDirection,
    Value<int?>? windSpeedKt,
    Value<String>? notes,
    Value<DateTime?>? blockOffAt,
    Value<DateTime?>? takeoffAt,
    Value<DateTime?>? landingAt,
    Value<DateTime?>? blockOnAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FlightsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      rules: rules ?? this.rules,
      status: status ?? this.status,
      aircraftId: aircraftId ?? this.aircraftId,
      departureIdent: departureIdent ?? this.departureIdent,
      destinationIdent: destinationIdent ?? this.destinationIdent,
      alternateIdent: alternateIdent ?? this.alternateIdent,
      departureRunway: departureRunway ?? this.departureRunway,
      arrivalRunway: arrivalRunway ?? this.arrivalRunway,
      cruiseAltitudeFt: cruiseAltitudeFt ?? this.cruiseAltitudeFt,
      plannedDeparture: plannedDeparture ?? this.plannedDeparture,
      windDirection: windDirection ?? this.windDirection,
      windSpeedKt: windSpeedKt ?? this.windSpeedKt,
      notes: notes ?? this.notes,
      blockOffAt: blockOffAt ?? this.blockOffAt,
      takeoffAt: takeoffAt ?? this.takeoffAt,
      landingAt: landingAt ?? this.landingAt,
      blockOnAt: blockOnAt ?? this.blockOnAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rules.present) {
      map['rules'] = Variable<String>(
        $FlightsTable.$converterrules.toSql(rules.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $FlightsTable.$converterstatus.toSql(status.value),
      );
    }
    if (aircraftId.present) {
      map['aircraft_id'] = Variable<int>(aircraftId.value);
    }
    if (departureIdent.present) {
      map['departure_ident'] = Variable<String>(departureIdent.value);
    }
    if (destinationIdent.present) {
      map['destination_ident'] = Variable<String>(destinationIdent.value);
    }
    if (alternateIdent.present) {
      map['alternate_ident'] = Variable<String>(alternateIdent.value);
    }
    if (departureRunway.present) {
      map['departure_runway'] = Variable<String>(departureRunway.value);
    }
    if (arrivalRunway.present) {
      map['arrival_runway'] = Variable<String>(arrivalRunway.value);
    }
    if (cruiseAltitudeFt.present) {
      map['cruise_altitude_ft'] = Variable<int>(cruiseAltitudeFt.value);
    }
    if (plannedDeparture.present) {
      map['planned_departure'] = Variable<DateTime>(plannedDeparture.value);
    }
    if (windDirection.present) {
      map['wind_direction'] = Variable<int>(windDirection.value);
    }
    if (windSpeedKt.present) {
      map['wind_speed_kt'] = Variable<int>(windSpeedKt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (blockOffAt.present) {
      map['block_off_at'] = Variable<DateTime>(blockOffAt.value);
    }
    if (takeoffAt.present) {
      map['takeoff_at'] = Variable<DateTime>(takeoffAt.value);
    }
    if (landingAt.present) {
      map['landing_at'] = Variable<DateTime>(landingAt.value);
    }
    if (blockOnAt.present) {
      map['block_on_at'] = Variable<DateTime>(blockOnAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('rules: $rules, ')
          ..write('status: $status, ')
          ..write('aircraftId: $aircraftId, ')
          ..write('departureIdent: $departureIdent, ')
          ..write('destinationIdent: $destinationIdent, ')
          ..write('alternateIdent: $alternateIdent, ')
          ..write('departureRunway: $departureRunway, ')
          ..write('arrivalRunway: $arrivalRunway, ')
          ..write('cruiseAltitudeFt: $cruiseAltitudeFt, ')
          ..write('plannedDeparture: $plannedDeparture, ')
          ..write('windDirection: $windDirection, ')
          ..write('windSpeedKt: $windSpeedKt, ')
          ..write('notes: $notes, ')
          ..write('blockOffAt: $blockOffAt, ')
          ..write('takeoffAt: $takeoffAt, ')
          ..write('landingAt: $landingAt, ')
          ..write('blockOnAt: $blockOnAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FlightWaypointsTable extends FlightWaypoints
    with TableInfo<$FlightWaypointsTable, FlightWaypoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlightWaypointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _flightIdMeta = const VerificationMeta(
    'flightId',
  );
  @override
  late final GeneratedColumn<int> flightId = GeneratedColumn<int>(
    'flight_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flights (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WaypointKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<WaypointKind>($FlightWaypointsTable.$converterkind);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<int> refId = GeneratedColumn<int>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identMeta = const VerificationMeta('ident');
  @override
  late final GeneratedColumn<String> ident = GeneratedColumn<String>(
    'ident',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _altitudeFtMeta = const VerificationMeta(
    'altitudeFt',
  );
  @override
  late final GeneratedColumn<int> altitudeFt = GeneratedColumn<int>(
    'altitude_ft',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windDirectionMeta = const VerificationMeta(
    'windDirection',
  );
  @override
  late final GeneratedColumn<int> windDirection = GeneratedColumn<int>(
    'wind_direction',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _windSpeedKtMeta = const VerificationMeta(
    'windSpeedKt',
  );
  @override
  late final GeneratedColumn<int> windSpeedKt = GeneratedColumn<int>(
    'wind_speed_kt',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _actualTimeOverMeta = const VerificationMeta(
    'actualTimeOver',
  );
  @override
  late final GeneratedColumn<DateTime> actualTimeOver =
      GeneratedColumn<DateTime>(
        'actual_time_over',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    flightId,
    sequence,
    kind,
    refId,
    ident,
    name,
    latitude,
    longitude,
    altitudeFt,
    windDirection,
    windSpeedKt,
    notes,
    actualTimeOver,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flight_waypoints';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlightWaypoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('flight_id')) {
      context.handle(
        _flightIdMeta,
        flightId.isAcceptableOrUnknown(data['flight_id']!, _flightIdMeta),
      );
    } else if (isInserting) {
      context.missing(_flightIdMeta);
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    }
    if (data.containsKey('ident')) {
      context.handle(
        _identMeta,
        ident.isAcceptableOrUnknown(data['ident']!, _identMeta),
      );
    } else if (isInserting) {
      context.missing(_identMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('altitude_ft')) {
      context.handle(
        _altitudeFtMeta,
        altitudeFt.isAcceptableOrUnknown(data['altitude_ft']!, _altitudeFtMeta),
      );
    }
    if (data.containsKey('wind_direction')) {
      context.handle(
        _windDirectionMeta,
        windDirection.isAcceptableOrUnknown(
          data['wind_direction']!,
          _windDirectionMeta,
        ),
      );
    }
    if (data.containsKey('wind_speed_kt')) {
      context.handle(
        _windSpeedKtMeta,
        windSpeedKt.isAcceptableOrUnknown(
          data['wind_speed_kt']!,
          _windSpeedKtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('actual_time_over')) {
      context.handle(
        _actualTimeOverMeta,
        actualTimeOver.isAcceptableOrUnknown(
          data['actual_time_over']!,
          _actualTimeOverMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlightWaypoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlightWaypoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      flightId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flight_id'],
      )!,
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      kind: $FlightWaypointsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ref_id'],
      ),
      ident: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ident'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      altitudeFt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}altitude_ft'],
      ),
      windDirection: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wind_direction'],
      ),
      windSpeedKt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wind_speed_kt'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      actualTimeOver: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_time_over'],
      ),
    );
  }

  @override
  $FlightWaypointsTable createAlias(String alias) {
    return $FlightWaypointsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WaypointKind, String, String> $converterkind =
      const EnumNameConverter<WaypointKind>(WaypointKind.values);
}

class FlightWaypoint extends DataClass implements Insertable<FlightWaypoint> {
  final int id;
  final int flightId;
  final int sequence;
  final WaypointKind kind;

  /// Airport or navaid id for [WaypointKind.airport] / [WaypointKind.navaid].
  final int? refId;
  final String ident;
  final String name;
  final double latitude;
  final double longitude;

  /// Planned altitude for the leg that ends at this waypoint.
  final int? altitudeFt;
  final int? windDirection;
  final int? windSpeedKt;
  final String notes;

  /// Actual time over, filled in during the flight.
  final DateTime? actualTimeOver;
  const FlightWaypoint({
    required this.id,
    required this.flightId,
    required this.sequence,
    required this.kind,
    this.refId,
    required this.ident,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.altitudeFt,
    this.windDirection,
    this.windSpeedKt,
    required this.notes,
    this.actualTimeOver,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['flight_id'] = Variable<int>(flightId);
    map['sequence'] = Variable<int>(sequence);
    {
      map['kind'] = Variable<String>(
        $FlightWaypointsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<int>(refId);
    }
    map['ident'] = Variable<String>(ident);
    map['name'] = Variable<String>(name);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || altitudeFt != null) {
      map['altitude_ft'] = Variable<int>(altitudeFt);
    }
    if (!nullToAbsent || windDirection != null) {
      map['wind_direction'] = Variable<int>(windDirection);
    }
    if (!nullToAbsent || windSpeedKt != null) {
      map['wind_speed_kt'] = Variable<int>(windSpeedKt);
    }
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || actualTimeOver != null) {
      map['actual_time_over'] = Variable<DateTime>(actualTimeOver);
    }
    return map;
  }

  FlightWaypointsCompanion toCompanion(bool nullToAbsent) {
    return FlightWaypointsCompanion(
      id: Value(id),
      flightId: Value(flightId),
      sequence: Value(sequence),
      kind: Value(kind),
      refId: refId == null && nullToAbsent
          ? const Value.absent()
          : Value(refId),
      ident: Value(ident),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      altitudeFt: altitudeFt == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeFt),
      windDirection: windDirection == null && nullToAbsent
          ? const Value.absent()
          : Value(windDirection),
      windSpeedKt: windSpeedKt == null && nullToAbsent
          ? const Value.absent()
          : Value(windSpeedKt),
      notes: Value(notes),
      actualTimeOver: actualTimeOver == null && nullToAbsent
          ? const Value.absent()
          : Value(actualTimeOver),
    );
  }

  factory FlightWaypoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlightWaypoint(
      id: serializer.fromJson<int>(json['id']),
      flightId: serializer.fromJson<int>(json['flightId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      kind: $FlightWaypointsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      refId: serializer.fromJson<int?>(json['refId']),
      ident: serializer.fromJson<String>(json['ident']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      altitudeFt: serializer.fromJson<int?>(json['altitudeFt']),
      windDirection: serializer.fromJson<int?>(json['windDirection']),
      windSpeedKt: serializer.fromJson<int?>(json['windSpeedKt']),
      notes: serializer.fromJson<String>(json['notes']),
      actualTimeOver: serializer.fromJson<DateTime?>(json['actualTimeOver']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'flightId': serializer.toJson<int>(flightId),
      'sequence': serializer.toJson<int>(sequence),
      'kind': serializer.toJson<String>(
        $FlightWaypointsTable.$converterkind.toJson(kind),
      ),
      'refId': serializer.toJson<int?>(refId),
      'ident': serializer.toJson<String>(ident),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'altitudeFt': serializer.toJson<int?>(altitudeFt),
      'windDirection': serializer.toJson<int?>(windDirection),
      'windSpeedKt': serializer.toJson<int?>(windSpeedKt),
      'notes': serializer.toJson<String>(notes),
      'actualTimeOver': serializer.toJson<DateTime?>(actualTimeOver),
    };
  }

  FlightWaypoint copyWith({
    int? id,
    int? flightId,
    int? sequence,
    WaypointKind? kind,
    Value<int?> refId = const Value.absent(),
    String? ident,
    String? name,
    double? latitude,
    double? longitude,
    Value<int?> altitudeFt = const Value.absent(),
    Value<int?> windDirection = const Value.absent(),
    Value<int?> windSpeedKt = const Value.absent(),
    String? notes,
    Value<DateTime?> actualTimeOver = const Value.absent(),
  }) => FlightWaypoint(
    id: id ?? this.id,
    flightId: flightId ?? this.flightId,
    sequence: sequence ?? this.sequence,
    kind: kind ?? this.kind,
    refId: refId.present ? refId.value : this.refId,
    ident: ident ?? this.ident,
    name: name ?? this.name,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    altitudeFt: altitudeFt.present ? altitudeFt.value : this.altitudeFt,
    windDirection: windDirection.present
        ? windDirection.value
        : this.windDirection,
    windSpeedKt: windSpeedKt.present ? windSpeedKt.value : this.windSpeedKt,
    notes: notes ?? this.notes,
    actualTimeOver: actualTimeOver.present
        ? actualTimeOver.value
        : this.actualTimeOver,
  );
  FlightWaypoint copyWithCompanion(FlightWaypointsCompanion data) {
    return FlightWaypoint(
      id: data.id.present ? data.id.value : this.id,
      flightId: data.flightId.present ? data.flightId.value : this.flightId,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      kind: data.kind.present ? data.kind.value : this.kind,
      refId: data.refId.present ? data.refId.value : this.refId,
      ident: data.ident.present ? data.ident.value : this.ident,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      altitudeFt: data.altitudeFt.present
          ? data.altitudeFt.value
          : this.altitudeFt,
      windDirection: data.windDirection.present
          ? data.windDirection.value
          : this.windDirection,
      windSpeedKt: data.windSpeedKt.present
          ? data.windSpeedKt.value
          : this.windSpeedKt,
      notes: data.notes.present ? data.notes.value : this.notes,
      actualTimeOver: data.actualTimeOver.present
          ? data.actualTimeOver.value
          : this.actualTimeOver,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlightWaypoint(')
          ..write('id: $id, ')
          ..write('flightId: $flightId, ')
          ..write('sequence: $sequence, ')
          ..write('kind: $kind, ')
          ..write('refId: $refId, ')
          ..write('ident: $ident, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeFt: $altitudeFt, ')
          ..write('windDirection: $windDirection, ')
          ..write('windSpeedKt: $windSpeedKt, ')
          ..write('notes: $notes, ')
          ..write('actualTimeOver: $actualTimeOver')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    flightId,
    sequence,
    kind,
    refId,
    ident,
    name,
    latitude,
    longitude,
    altitudeFt,
    windDirection,
    windSpeedKt,
    notes,
    actualTimeOver,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlightWaypoint &&
          other.id == this.id &&
          other.flightId == this.flightId &&
          other.sequence == this.sequence &&
          other.kind == this.kind &&
          other.refId == this.refId &&
          other.ident == this.ident &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitudeFt == this.altitudeFt &&
          other.windDirection == this.windDirection &&
          other.windSpeedKt == this.windSpeedKt &&
          other.notes == this.notes &&
          other.actualTimeOver == this.actualTimeOver);
}

class FlightWaypointsCompanion extends UpdateCompanion<FlightWaypoint> {
  final Value<int> id;
  final Value<int> flightId;
  final Value<int> sequence;
  final Value<WaypointKind> kind;
  final Value<int?> refId;
  final Value<String> ident;
  final Value<String> name;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<int?> altitudeFt;
  final Value<int?> windDirection;
  final Value<int?> windSpeedKt;
  final Value<String> notes;
  final Value<DateTime?> actualTimeOver;
  const FlightWaypointsCompanion({
    this.id = const Value.absent(),
    this.flightId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.kind = const Value.absent(),
    this.refId = const Value.absent(),
    this.ident = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitudeFt = const Value.absent(),
    this.windDirection = const Value.absent(),
    this.windSpeedKt = const Value.absent(),
    this.notes = const Value.absent(),
    this.actualTimeOver = const Value.absent(),
  });
  FlightWaypointsCompanion.insert({
    this.id = const Value.absent(),
    required int flightId,
    required int sequence,
    required WaypointKind kind,
    this.refId = const Value.absent(),
    required String ident,
    this.name = const Value.absent(),
    required double latitude,
    required double longitude,
    this.altitudeFt = const Value.absent(),
    this.windDirection = const Value.absent(),
    this.windSpeedKt = const Value.absent(),
    this.notes = const Value.absent(),
    this.actualTimeOver = const Value.absent(),
  }) : flightId = Value(flightId),
       sequence = Value(sequence),
       kind = Value(kind),
       ident = Value(ident),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<FlightWaypoint> custom({
    Expression<int>? id,
    Expression<int>? flightId,
    Expression<int>? sequence,
    Expression<String>? kind,
    Expression<int>? refId,
    Expression<String>? ident,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? altitudeFt,
    Expression<int>? windDirection,
    Expression<int>? windSpeedKt,
    Expression<String>? notes,
    Expression<DateTime>? actualTimeOver,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (flightId != null) 'flight_id': flightId,
      if (sequence != null) 'sequence': sequence,
      if (kind != null) 'kind': kind,
      if (refId != null) 'ref_id': refId,
      if (ident != null) 'ident': ident,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitudeFt != null) 'altitude_ft': altitudeFt,
      if (windDirection != null) 'wind_direction': windDirection,
      if (windSpeedKt != null) 'wind_speed_kt': windSpeedKt,
      if (notes != null) 'notes': notes,
      if (actualTimeOver != null) 'actual_time_over': actualTimeOver,
    });
  }

  FlightWaypointsCompanion copyWith({
    Value<int>? id,
    Value<int>? flightId,
    Value<int>? sequence,
    Value<WaypointKind>? kind,
    Value<int?>? refId,
    Value<String>? ident,
    Value<String>? name,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<int?>? altitudeFt,
    Value<int?>? windDirection,
    Value<int?>? windSpeedKt,
    Value<String>? notes,
    Value<DateTime?>? actualTimeOver,
  }) {
    return FlightWaypointsCompanion(
      id: id ?? this.id,
      flightId: flightId ?? this.flightId,
      sequence: sequence ?? this.sequence,
      kind: kind ?? this.kind,
      refId: refId ?? this.refId,
      ident: ident ?? this.ident,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitudeFt: altitudeFt ?? this.altitudeFt,
      windDirection: windDirection ?? this.windDirection,
      windSpeedKt: windSpeedKt ?? this.windSpeedKt,
      notes: notes ?? this.notes,
      actualTimeOver: actualTimeOver ?? this.actualTimeOver,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (flightId.present) {
      map['flight_id'] = Variable<int>(flightId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $FlightWaypointsTable.$converterkind.toSql(kind.value),
      );
    }
    if (refId.present) {
      map['ref_id'] = Variable<int>(refId.value);
    }
    if (ident.present) {
      map['ident'] = Variable<String>(ident.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitudeFt.present) {
      map['altitude_ft'] = Variable<int>(altitudeFt.value);
    }
    if (windDirection.present) {
      map['wind_direction'] = Variable<int>(windDirection.value);
    }
    if (windSpeedKt.present) {
      map['wind_speed_kt'] = Variable<int>(windSpeedKt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (actualTimeOver.present) {
      map['actual_time_over'] = Variable<DateTime>(actualTimeOver.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlightWaypointsCompanion(')
          ..write('id: $id, ')
          ..write('flightId: $flightId, ')
          ..write('sequence: $sequence, ')
          ..write('kind: $kind, ')
          ..write('refId: $refId, ')
          ..write('ident: $ident, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitudeFt: $altitudeFt, ')
          ..write('windDirection: $windDirection, ')
          ..write('windSpeedKt: $windSpeedKt, ')
          ..write('notes: $notes, ')
          ..write('actualTimeOver: $actualTimeOver')
          ..write(')'))
        .toString();
  }
}

class $ScratchPagesTable extends ScratchPages
    with TableInfo<$ScratchPagesTable, ScratchPage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScratchPagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _flightIdMeta = const VerificationMeta(
    'flightId',
  );
  @override
  late final GeneratedColumn<int> flightId = GeneratedColumn<int>(
    'flight_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES flights (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sequenceMeta = const VerificationMeta(
    'sequence',
  );
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
    'sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PageBackground, String>
  background = GeneratedColumn<String>(
    'background',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('blank'),
  ).withConverter<PageBackground>($ScratchPagesTable.$converterbackground);
  static const VerificationMeta _strokesMeta = const VerificationMeta(
    'strokes',
  );
  @override
  late final GeneratedColumn<String> strokes = GeneratedColumn<String>(
    'strokes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    flightId,
    sequence,
    background,
    strokes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scratch_pages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScratchPage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('flight_id')) {
      context.handle(
        _flightIdMeta,
        flightId.isAcceptableOrUnknown(data['flight_id']!, _flightIdMeta),
      );
    }
    if (data.containsKey('sequence')) {
      context.handle(
        _sequenceMeta,
        sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sequenceMeta);
    }
    if (data.containsKey('strokes')) {
      context.handle(
        _strokesMeta,
        strokes.isAcceptableOrUnknown(data['strokes']!, _strokesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScratchPage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScratchPage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      flightId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flight_id'],
      ),
      sequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sequence'],
      )!,
      background: $ScratchPagesTable.$converterbackground.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}background'],
        )!,
      ),
      strokes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strokes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ScratchPagesTable createAlias(String alias) {
    return $ScratchPagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PageBackground, String, String>
  $converterbackground = const EnumNameConverter<PageBackground>(
    PageBackground.values,
  );
}

class ScratchPage extends DataClass implements Insertable<ScratchPage> {
  final int id;
  final int? flightId;
  final int sequence;
  final PageBackground background;

  /// JSON-encoded strokes, see `Stroke.toJson`.
  final String strokes;
  final DateTime updatedAt;
  const ScratchPage({
    required this.id,
    this.flightId,
    required this.sequence,
    required this.background,
    required this.strokes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || flightId != null) {
      map['flight_id'] = Variable<int>(flightId);
    }
    map['sequence'] = Variable<int>(sequence);
    {
      map['background'] = Variable<String>(
        $ScratchPagesTable.$converterbackground.toSql(background),
      );
    }
    map['strokes'] = Variable<String>(strokes);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ScratchPagesCompanion toCompanion(bool nullToAbsent) {
    return ScratchPagesCompanion(
      id: Value(id),
      flightId: flightId == null && nullToAbsent
          ? const Value.absent()
          : Value(flightId),
      sequence: Value(sequence),
      background: Value(background),
      strokes: Value(strokes),
      updatedAt: Value(updatedAt),
    );
  }

  factory ScratchPage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScratchPage(
      id: serializer.fromJson<int>(json['id']),
      flightId: serializer.fromJson<int?>(json['flightId']),
      sequence: serializer.fromJson<int>(json['sequence']),
      background: $ScratchPagesTable.$converterbackground.fromJson(
        serializer.fromJson<String>(json['background']),
      ),
      strokes: serializer.fromJson<String>(json['strokes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'flightId': serializer.toJson<int?>(flightId),
      'sequence': serializer.toJson<int>(sequence),
      'background': serializer.toJson<String>(
        $ScratchPagesTable.$converterbackground.toJson(background),
      ),
      'strokes': serializer.toJson<String>(strokes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ScratchPage copyWith({
    int? id,
    Value<int?> flightId = const Value.absent(),
    int? sequence,
    PageBackground? background,
    String? strokes,
    DateTime? updatedAt,
  }) => ScratchPage(
    id: id ?? this.id,
    flightId: flightId.present ? flightId.value : this.flightId,
    sequence: sequence ?? this.sequence,
    background: background ?? this.background,
    strokes: strokes ?? this.strokes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ScratchPage copyWithCompanion(ScratchPagesCompanion data) {
    return ScratchPage(
      id: data.id.present ? data.id.value : this.id,
      flightId: data.flightId.present ? data.flightId.value : this.flightId,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      background: data.background.present
          ? data.background.value
          : this.background,
      strokes: data.strokes.present ? data.strokes.value : this.strokes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScratchPage(')
          ..write('id: $id, ')
          ..write('flightId: $flightId, ')
          ..write('sequence: $sequence, ')
          ..write('background: $background, ')
          ..write('strokes: $strokes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, flightId, sequence, background, strokes, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScratchPage &&
          other.id == this.id &&
          other.flightId == this.flightId &&
          other.sequence == this.sequence &&
          other.background == this.background &&
          other.strokes == this.strokes &&
          other.updatedAt == this.updatedAt);
}

class ScratchPagesCompanion extends UpdateCompanion<ScratchPage> {
  final Value<int> id;
  final Value<int?> flightId;
  final Value<int> sequence;
  final Value<PageBackground> background;
  final Value<String> strokes;
  final Value<DateTime> updatedAt;
  const ScratchPagesCompanion({
    this.id = const Value.absent(),
    this.flightId = const Value.absent(),
    this.sequence = const Value.absent(),
    this.background = const Value.absent(),
    this.strokes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ScratchPagesCompanion.insert({
    this.id = const Value.absent(),
    this.flightId = const Value.absent(),
    required int sequence,
    this.background = const Value.absent(),
    this.strokes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : sequence = Value(sequence);
  static Insertable<ScratchPage> custom({
    Expression<int>? id,
    Expression<int>? flightId,
    Expression<int>? sequence,
    Expression<String>? background,
    Expression<String>? strokes,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (flightId != null) 'flight_id': flightId,
      if (sequence != null) 'sequence': sequence,
      if (background != null) 'background': background,
      if (strokes != null) 'strokes': strokes,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ScratchPagesCompanion copyWith({
    Value<int>? id,
    Value<int?>? flightId,
    Value<int>? sequence,
    Value<PageBackground>? background,
    Value<String>? strokes,
    Value<DateTime>? updatedAt,
  }) {
    return ScratchPagesCompanion(
      id: id ?? this.id,
      flightId: flightId ?? this.flightId,
      sequence: sequence ?? this.sequence,
      background: background ?? this.background,
      strokes: strokes ?? this.strokes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (flightId.present) {
      map['flight_id'] = Variable<int>(flightId.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (background.present) {
      map['background'] = Variable<String>(
        $ScratchPagesTable.$converterbackground.toSql(background.value),
      );
    }
    if (strokes.present) {
      map['strokes'] = Variable<String>(strokes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScratchPagesCompanion(')
          ..write('id: $id, ')
          ..write('flightId: $flightId, ')
          ..write('sequence: $sequence, ')
          ..write('background: $background, ')
          ..write('strokes: $strokes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AirportsTable airports = $AirportsTable(this);
  late final $RunwaysTable runways = $RunwaysTable(this);
  late final $AirportFrequenciesTable airportFrequencies =
      $AirportFrequenciesTable(this);
  late final $NavaidsTable navaids = $NavaidsTable(this);
  late final $AircraftProfilesTable aircraftProfiles = $AircraftProfilesTable(
    this,
  );
  late final $FlightsTable flights = $FlightsTable(this);
  late final $FlightWaypointsTable flightWaypoints = $FlightWaypointsTable(
    this,
  );
  late final $ScratchPagesTable scratchPages = $ScratchPagesTable(this);
  late final Index airportsIdent = Index(
    'airports_ident',
    'CREATE INDEX airports_ident ON airports (ident)',
  );
  late final Index airportsPosition = Index(
    'airports_position',
    'CREATE INDEX airports_position ON airports (latitude, longitude)',
  );
  late final Index runwaysAirport = Index(
    'runways_airport',
    'CREATE INDEX runways_airport ON runways (airport_id)',
  );
  late final Index frequenciesAirport = Index(
    'frequencies_airport',
    'CREATE INDEX frequencies_airport ON airport_frequencies (airport_id)',
  );
  late final Index navaidsIdent = Index(
    'navaids_ident',
    'CREATE INDEX navaids_ident ON navaids (ident)',
  );
  late final Index navaidsPosition = Index(
    'navaids_position',
    'CREATE INDEX navaids_position ON navaids (latitude, longitude)',
  );
  late final Index waypointsFlight = Index(
    'waypoints_flight',
    'CREATE INDEX waypoints_flight ON flight_waypoints (flight_id, sequence)',
  );
  late final Index scratchPagesFlight = Index(
    'scratch_pages_flight',
    'CREATE INDEX scratch_pages_flight ON scratch_pages (flight_id, sequence)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    airports,
    runways,
    airportFrequencies,
    navaids,
    aircraftProfiles,
    flights,
    flightWaypoints,
    scratchPages,
    airportsIdent,
    airportsPosition,
    runwaysAirport,
    frequenciesAirport,
    navaidsIdent,
    navaidsPosition,
    waypointsFlight,
    scratchPagesFlight,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'flights',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('flight_waypoints', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'flights',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('scratch_pages', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AirportsTableCreateCompanionBuilder = AirportsCompanion Function({
  Value<int> id,
  required String ident,
  required String type,
  required String name,
  required double latitude,
  required double longitude,
  Value<int?> elevationFt,
  required String isoCountry,
  required String isoRegion,
  Value<String?> municipality,
  Value<String?> icaoCode,
  Value<String?> iataCode,
});
typedef $$AirportsTableUpdateCompanionBuilder = AirportsCompanion Function({
  Value<int> id,
  Value<String> ident,
  Value<String> type,
  Value<String> name,
  Value<double> latitude,
  Value<double> longitude,
  Value<int?> elevationFt,
  Value<String> isoCountry,
  Value<String> isoRegion,
  Value<String?> municipality,
  Value<String?> icaoCode,
  Value<String?> iataCode,
});

class $$AirportsTableFilterComposer
    extends Composer<_$AppDatabase, $AirportsTable> {
  $$AirportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ident => $composableBuilder(
    column: $table.ident,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elevationFt => $composableBuilder(
    column: $table.elevationFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isoCountry => $composableBuilder(
    column: $table.isoCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isoRegion => $composableBuilder(
    column: $table.isoRegion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get municipality => $composableBuilder(
    column: $table.municipality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icaoCode => $composableBuilder(
    column: $table.icaoCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iataCode => $composableBuilder(
    column: $table.iataCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AirportsTableOrderingComposer
    extends Composer<_$AppDatabase, $AirportsTable> {
  $$AirportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ident => $composableBuilder(
    column: $table.ident,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elevationFt => $composableBuilder(
    column: $table.elevationFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isoCountry => $composableBuilder(
    column: $table.isoCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isoRegion => $composableBuilder(
    column: $table.isoRegion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get municipality => $composableBuilder(
    column: $table.municipality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icaoCode => $composableBuilder(
    column: $table.icaoCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iataCode => $composableBuilder(
    column: $table.iataCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AirportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AirportsTable> {
  $$AirportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ident =>
      $composableBuilder(column: $table.ident, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get elevationFt => $composableBuilder(
    column: $table.elevationFt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get isoCountry => $composableBuilder(
    column: $table.isoCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get isoRegion =>
      $composableBuilder(column: $table.isoRegion, builder: (column) => column);

  GeneratedColumn<String> get municipality => $composableBuilder(
    column: $table.municipality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icaoCode =>
      $composableBuilder(column: $table.icaoCode, builder: (column) => column);

  GeneratedColumn<String> get iataCode =>
      $composableBuilder(column: $table.iataCode, builder: (column) => column);
}

class $$AirportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AirportsTable,
          Airport,
          $$AirportsTableFilterComposer,
          $$AirportsTableOrderingComposer,
          $$AirportsTableAnnotationComposer,
          $$AirportsTableCreateCompanionBuilder,
          $$AirportsTableUpdateCompanionBuilder,
          (Airport, BaseReferences<_$AppDatabase, $AirportsTable, Airport>),
          Airport,
          PrefetchHooks Function()
        > {
  $$AirportsTableTableManager(_$AppDatabase db, $AirportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AirportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AirportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AirportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> ident = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<int?> elevationFt = const Value.absent(),
                Value<String> isoCountry = const Value.absent(),
                Value<String> isoRegion = const Value.absent(),
                Value<String?> municipality = const Value.absent(),
                Value<String?> icaoCode = const Value.absent(),
                Value<String?> iataCode = const Value.absent(),
              }) => AirportsCompanion(
                id: id,
                ident: ident,
                type: type,
                name: name,
                latitude: latitude,
                longitude: longitude,
                elevationFt: elevationFt,
                isoCountry: isoCountry,
                isoRegion: isoRegion,
                municipality: municipality,
                icaoCode: icaoCode,
                iataCode: iataCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ident,
                required String type,
                required String name,
                required double latitude,
                required double longitude,
                Value<int?> elevationFt = const Value.absent(),
                required String isoCountry,
                required String isoRegion,
                Value<String?> municipality = const Value.absent(),
                Value<String?> icaoCode = const Value.absent(),
                Value<String?> iataCode = const Value.absent(),
              }) => AirportsCompanion.insert(
                id: id,
                ident: ident,
                type: type,
                name: name,
                latitude: latitude,
                longitude: longitude,
                elevationFt: elevationFt,
                isoCountry: isoCountry,
                isoRegion: isoRegion,
                municipality: municipality,
                icaoCode: icaoCode,
                iataCode: iataCode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AirportsTable, Airport>(table),
                  BaseReferences<_$AppDatabase, $AirportsTable, Airport>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AirportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AirportsTable,
      Airport,
      $$AirportsTableFilterComposer,
      $$AirportsTableOrderingComposer,
      $$AirportsTableAnnotationComposer,
      $$AirportsTableCreateCompanionBuilder,
      $$AirportsTableUpdateCompanionBuilder,
      (Airport, BaseReferences<_$AppDatabase, $AirportsTable, Airport>),
      Airport,
      PrefetchHooks Function()
    >;
typedef $$RunwaysTableCreateCompanionBuilder = RunwaysCompanion Function({
  Value<int> id,
  required int airportId,
  Value<int?> lengthFt,
  Value<int?> widthFt,
  Value<String?> surface,
  required bool lighted,
  required bool closed,
  Value<String?> leIdent,
  Value<double?> leHeadingTrue,
  Value<int?> leElevationFt,
  Value<double?> leLatitude,
  Value<double?> leLongitude,
  Value<String?> heIdent,
  Value<double?> heHeadingTrue,
  Value<int?> heElevationFt,
  Value<double?> heLatitude,
  Value<double?> heLongitude,
});
typedef $$RunwaysTableUpdateCompanionBuilder = RunwaysCompanion Function({
  Value<int> id,
  Value<int> airportId,
  Value<int?> lengthFt,
  Value<int?> widthFt,
  Value<String?> surface,
  Value<bool> lighted,
  Value<bool> closed,
  Value<String?> leIdent,
  Value<double?> leHeadingTrue,
  Value<int?> leElevationFt,
  Value<double?> leLatitude,
  Value<double?> leLongitude,
  Value<String?> heIdent,
  Value<double?> heHeadingTrue,
  Value<int?> heElevationFt,
  Value<double?> heLatitude,
  Value<double?> heLongitude,
});

class $$RunwaysTableFilterComposer
    extends Composer<_$AppDatabase, $RunwaysTable> {
  $$RunwaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get airportId => $composableBuilder(
    column: $table.airportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lengthFt => $composableBuilder(
    column: $table.lengthFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get widthFt => $composableBuilder(
    column: $table.widthFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surface => $composableBuilder(
    column: $table.surface,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lighted => $composableBuilder(
    column: $table.lighted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get closed => $composableBuilder(
    column: $table.closed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leIdent => $composableBuilder(
    column: $table.leIdent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leHeadingTrue => $composableBuilder(
    column: $table.leHeadingTrue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leElevationFt => $composableBuilder(
    column: $table.leElevationFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leLatitude => $composableBuilder(
    column: $table.leLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leLongitude => $composableBuilder(
    column: $table.leLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get heIdent => $composableBuilder(
    column: $table.heIdent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heHeadingTrue => $composableBuilder(
    column: $table.heHeadingTrue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heElevationFt => $composableBuilder(
    column: $table.heElevationFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heLatitude => $composableBuilder(
    column: $table.heLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heLongitude => $composableBuilder(
    column: $table.heLongitude,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RunwaysTableOrderingComposer
    extends Composer<_$AppDatabase, $RunwaysTable> {
  $$RunwaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get airportId => $composableBuilder(
    column: $table.airportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lengthFt => $composableBuilder(
    column: $table.lengthFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get widthFt => $composableBuilder(
    column: $table.widthFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surface => $composableBuilder(
    column: $table.surface,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lighted => $composableBuilder(
    column: $table.lighted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get closed => $composableBuilder(
    column: $table.closed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leIdent => $composableBuilder(
    column: $table.leIdent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leHeadingTrue => $composableBuilder(
    column: $table.leHeadingTrue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leElevationFt => $composableBuilder(
    column: $table.leElevationFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leLatitude => $composableBuilder(
    column: $table.leLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leLongitude => $composableBuilder(
    column: $table.leLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heIdent => $composableBuilder(
    column: $table.heIdent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heHeadingTrue => $composableBuilder(
    column: $table.heHeadingTrue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heElevationFt => $composableBuilder(
    column: $table.heElevationFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heLatitude => $composableBuilder(
    column: $table.heLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heLongitude => $composableBuilder(
    column: $table.heLongitude,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RunwaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $RunwaysTable> {
  $$RunwaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get airportId =>
      $composableBuilder(column: $table.airportId, builder: (column) => column);

  GeneratedColumn<int> get lengthFt =>
      $composableBuilder(column: $table.lengthFt, builder: (column) => column);

  GeneratedColumn<int> get widthFt =>
      $composableBuilder(column: $table.widthFt, builder: (column) => column);

  GeneratedColumn<String> get surface =>
      $composableBuilder(column: $table.surface, builder: (column) => column);

  GeneratedColumn<bool> get lighted =>
      $composableBuilder(column: $table.lighted, builder: (column) => column);

  GeneratedColumn<bool> get closed =>
      $composableBuilder(column: $table.closed, builder: (column) => column);

  GeneratedColumn<String> get leIdent =>
      $composableBuilder(column: $table.leIdent, builder: (column) => column);

  GeneratedColumn<double> get leHeadingTrue => $composableBuilder(
    column: $table.leHeadingTrue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leElevationFt => $composableBuilder(
    column: $table.leElevationFt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get leLatitude => $composableBuilder(
    column: $table.leLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get leLongitude => $composableBuilder(
    column: $table.leLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get heIdent =>
      $composableBuilder(column: $table.heIdent, builder: (column) => column);

  GeneratedColumn<double> get heHeadingTrue => $composableBuilder(
    column: $table.heHeadingTrue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get heElevationFt => $composableBuilder(
    column: $table.heElevationFt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heLatitude => $composableBuilder(
    column: $table.heLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heLongitude => $composableBuilder(
    column: $table.heLongitude,
    builder: (column) => column,
  );
}

class $$RunwaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RunwaysTable,
          Runway,
          $$RunwaysTableFilterComposer,
          $$RunwaysTableOrderingComposer,
          $$RunwaysTableAnnotationComposer,
          $$RunwaysTableCreateCompanionBuilder,
          $$RunwaysTableUpdateCompanionBuilder,
          (Runway, BaseReferences<_$AppDatabase, $RunwaysTable, Runway>),
          Runway,
          PrefetchHooks Function()
        > {
  $$RunwaysTableTableManager(_$AppDatabase db, $RunwaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RunwaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RunwaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RunwaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> airportId = const Value.absent(),
                Value<int?> lengthFt = const Value.absent(),
                Value<int?> widthFt = const Value.absent(),
                Value<String?> surface = const Value.absent(),
                Value<bool> lighted = const Value.absent(),
                Value<bool> closed = const Value.absent(),
                Value<String?> leIdent = const Value.absent(),
                Value<double?> leHeadingTrue = const Value.absent(),
                Value<int?> leElevationFt = const Value.absent(),
                Value<double?> leLatitude = const Value.absent(),
                Value<double?> leLongitude = const Value.absent(),
                Value<String?> heIdent = const Value.absent(),
                Value<double?> heHeadingTrue = const Value.absent(),
                Value<int?> heElevationFt = const Value.absent(),
                Value<double?> heLatitude = const Value.absent(),
                Value<double?> heLongitude = const Value.absent(),
              }) => RunwaysCompanion(
                id: id,
                airportId: airportId,
                lengthFt: lengthFt,
                widthFt: widthFt,
                surface: surface,
                lighted: lighted,
                closed: closed,
                leIdent: leIdent,
                leHeadingTrue: leHeadingTrue,
                leElevationFt: leElevationFt,
                leLatitude: leLatitude,
                leLongitude: leLongitude,
                heIdent: heIdent,
                heHeadingTrue: heHeadingTrue,
                heElevationFt: heElevationFt,
                heLatitude: heLatitude,
                heLongitude: heLongitude,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int airportId,
                Value<int?> lengthFt = const Value.absent(),
                Value<int?> widthFt = const Value.absent(),
                Value<String?> surface = const Value.absent(),
                required bool lighted,
                required bool closed,
                Value<String?> leIdent = const Value.absent(),
                Value<double?> leHeadingTrue = const Value.absent(),
                Value<int?> leElevationFt = const Value.absent(),
                Value<double?> leLatitude = const Value.absent(),
                Value<double?> leLongitude = const Value.absent(),
                Value<String?> heIdent = const Value.absent(),
                Value<double?> heHeadingTrue = const Value.absent(),
                Value<int?> heElevationFt = const Value.absent(),
                Value<double?> heLatitude = const Value.absent(),
                Value<double?> heLongitude = const Value.absent(),
              }) => RunwaysCompanion.insert(
                id: id,
                airportId: airportId,
                lengthFt: lengthFt,
                widthFt: widthFt,
                surface: surface,
                lighted: lighted,
                closed: closed,
                leIdent: leIdent,
                leHeadingTrue: leHeadingTrue,
                leElevationFt: leElevationFt,
                leLatitude: leLatitude,
                leLongitude: leLongitude,
                heIdent: heIdent,
                heHeadingTrue: heHeadingTrue,
                heElevationFt: heElevationFt,
                heLatitude: heLatitude,
                heLongitude: heLongitude,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RunwaysTable, Runway>(table),
                  BaseReferences<_$AppDatabase, $RunwaysTable, Runway>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RunwaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RunwaysTable,
      Runway,
      $$RunwaysTableFilterComposer,
      $$RunwaysTableOrderingComposer,
      $$RunwaysTableAnnotationComposer,
      $$RunwaysTableCreateCompanionBuilder,
      $$RunwaysTableUpdateCompanionBuilder,
      (Runway, BaseReferences<_$AppDatabase, $RunwaysTable, Runway>),
      Runway,
      PrefetchHooks Function()
    >;
typedef $$AirportFrequenciesTableCreateCompanionBuilder =
    AirportFrequenciesCompanion Function({
      Value<int> id,
      required int airportId,
      required String type,
      Value<String?> description,
      required double frequencyMhz,
    });
typedef $$AirportFrequenciesTableUpdateCompanionBuilder =
    AirportFrequenciesCompanion Function({
      Value<int> id,
      Value<int> airportId,
      Value<String> type,
      Value<String?> description,
      Value<double> frequencyMhz,
    });

class $$AirportFrequenciesTableFilterComposer
    extends Composer<_$AppDatabase, $AirportFrequenciesTable> {
  $$AirportFrequenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get airportId => $composableBuilder(
    column: $table.airportId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get frequencyMhz => $composableBuilder(
    column: $table.frequencyMhz,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AirportFrequenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $AirportFrequenciesTable> {
  $$AirportFrequenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get airportId => $composableBuilder(
    column: $table.airportId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get frequencyMhz => $composableBuilder(
    column: $table.frequencyMhz,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AirportFrequenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AirportFrequenciesTable> {
  $$AirportFrequenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get airportId =>
      $composableBuilder(column: $table.airportId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get frequencyMhz => $composableBuilder(
    column: $table.frequencyMhz,
    builder: (column) => column,
  );
}

class $$AirportFrequenciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AirportFrequenciesTable,
          AirportFrequency,
          $$AirportFrequenciesTableFilterComposer,
          $$AirportFrequenciesTableOrderingComposer,
          $$AirportFrequenciesTableAnnotationComposer,
          $$AirportFrequenciesTableCreateCompanionBuilder,
          $$AirportFrequenciesTableUpdateCompanionBuilder,
          (
            AirportFrequency,
            BaseReferences<
              _$AppDatabase,
              $AirportFrequenciesTable,
              AirportFrequency
            >,
          ),
          AirportFrequency,
          PrefetchHooks Function()
        > {
  $$AirportFrequenciesTableTableManager(
    _$AppDatabase db,
    $AirportFrequenciesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AirportFrequenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AirportFrequenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AirportFrequenciesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> airportId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> frequencyMhz = const Value.absent(),
              }) => AirportFrequenciesCompanion(
                id: id,
                airportId: airportId,
                type: type,
                description: description,
                frequencyMhz: frequencyMhz,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int airportId,
                required String type,
                Value<String?> description = const Value.absent(),
                required double frequencyMhz,
              }) => AirportFrequenciesCompanion.insert(
                id: id,
                airportId: airportId,
                type: type,
                description: description,
                frequencyMhz: frequencyMhz,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AirportFrequenciesTable, AirportFrequency>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $AirportFrequenciesTable,
                    AirportFrequency
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AirportFrequenciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AirportFrequenciesTable,
      AirportFrequency,
      $$AirportFrequenciesTableFilterComposer,
      $$AirportFrequenciesTableOrderingComposer,
      $$AirportFrequenciesTableAnnotationComposer,
      $$AirportFrequenciesTableCreateCompanionBuilder,
      $$AirportFrequenciesTableUpdateCompanionBuilder,
      (
        AirportFrequency,
        BaseReferences<
          _$AppDatabase,
          $AirportFrequenciesTable,
          AirportFrequency
        >,
      ),
      AirportFrequency,
      PrefetchHooks Function()
    >;
typedef $$NavaidsTableCreateCompanionBuilder = NavaidsCompanion Function({
  Value<int> id,
  required String ident,
  required String name,
  required String type,
  Value<int?> frequencyKhz,
  required double latitude,
  required double longitude,
  Value<int?> elevationFt,
  required String isoCountry,
  Value<double?> magneticVariation,
  Value<String?> associatedAirport,
});
typedef $$NavaidsTableUpdateCompanionBuilder = NavaidsCompanion Function({
  Value<int> id,
  Value<String> ident,
  Value<String> name,
  Value<String> type,
  Value<int?> frequencyKhz,
  Value<double> latitude,
  Value<double> longitude,
  Value<int?> elevationFt,
  Value<String> isoCountry,
  Value<double?> magneticVariation,
  Value<String?> associatedAirport,
});

class $$NavaidsTableFilterComposer
    extends Composer<_$AppDatabase, $NavaidsTable> {
  $$NavaidsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ident => $composableBuilder(
    column: $table.ident,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequencyKhz => $composableBuilder(
    column: $table.frequencyKhz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elevationFt => $composableBuilder(
    column: $table.elevationFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isoCountry => $composableBuilder(
    column: $table.isoCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get magneticVariation => $composableBuilder(
    column: $table.magneticVariation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get associatedAirport => $composableBuilder(
    column: $table.associatedAirport,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NavaidsTableOrderingComposer
    extends Composer<_$AppDatabase, $NavaidsTable> {
  $$NavaidsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ident => $composableBuilder(
    column: $table.ident,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencyKhz => $composableBuilder(
    column: $table.frequencyKhz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elevationFt => $composableBuilder(
    column: $table.elevationFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isoCountry => $composableBuilder(
    column: $table.isoCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get magneticVariation => $composableBuilder(
    column: $table.magneticVariation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get associatedAirport => $composableBuilder(
    column: $table.associatedAirport,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NavaidsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NavaidsTable> {
  $$NavaidsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ident =>
      $composableBuilder(column: $table.ident, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get frequencyKhz => $composableBuilder(
    column: $table.frequencyKhz,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get elevationFt => $composableBuilder(
    column: $table.elevationFt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get isoCountry => $composableBuilder(
    column: $table.isoCountry,
    builder: (column) => column,
  );

  GeneratedColumn<double> get magneticVariation => $composableBuilder(
    column: $table.magneticVariation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get associatedAirport => $composableBuilder(
    column: $table.associatedAirport,
    builder: (column) => column,
  );
}

class $$NavaidsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NavaidsTable,
          Navaid,
          $$NavaidsTableFilterComposer,
          $$NavaidsTableOrderingComposer,
          $$NavaidsTableAnnotationComposer,
          $$NavaidsTableCreateCompanionBuilder,
          $$NavaidsTableUpdateCompanionBuilder,
          (Navaid, BaseReferences<_$AppDatabase, $NavaidsTable, Navaid>),
          Navaid,
          PrefetchHooks Function()
        > {
  $$NavaidsTableTableManager(_$AppDatabase db, $NavaidsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NavaidsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NavaidsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NavaidsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> ident = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> frequencyKhz = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<int?> elevationFt = const Value.absent(),
                Value<String> isoCountry = const Value.absent(),
                Value<double?> magneticVariation = const Value.absent(),
                Value<String?> associatedAirport = const Value.absent(),
              }) => NavaidsCompanion(
                id: id,
                ident: ident,
                name: name,
                type: type,
                frequencyKhz: frequencyKhz,
                latitude: latitude,
                longitude: longitude,
                elevationFt: elevationFt,
                isoCountry: isoCountry,
                magneticVariation: magneticVariation,
                associatedAirport: associatedAirport,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String ident,
                required String name,
                required String type,
                Value<int?> frequencyKhz = const Value.absent(),
                required double latitude,
                required double longitude,
                Value<int?> elevationFt = const Value.absent(),
                required String isoCountry,
                Value<double?> magneticVariation = const Value.absent(),
                Value<String?> associatedAirport = const Value.absent(),
              }) => NavaidsCompanion.insert(
                id: id,
                ident: ident,
                name: name,
                type: type,
                frequencyKhz: frequencyKhz,
                latitude: latitude,
                longitude: longitude,
                elevationFt: elevationFt,
                isoCountry: isoCountry,
                magneticVariation: magneticVariation,
                associatedAirport: associatedAirport,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NavaidsTable, Navaid>(table),
                  BaseReferences<_$AppDatabase, $NavaidsTable, Navaid>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NavaidsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NavaidsTable,
      Navaid,
      $$NavaidsTableFilterComposer,
      $$NavaidsTableOrderingComposer,
      $$NavaidsTableAnnotationComposer,
      $$NavaidsTableCreateCompanionBuilder,
      $$NavaidsTableUpdateCompanionBuilder,
      (Navaid, BaseReferences<_$AppDatabase, $NavaidsTable, Navaid>),
      Navaid,
      PrefetchHooks Function()
    >;
typedef $$AircraftProfilesTableCreateCompanionBuilder =
    AircraftProfilesCompanion Function({
      Value<int> id,
      required String name,
      required String icaoType,
      Value<String> registration,
      required int cruiseTas,
      Value<int?> climbTas,
      Value<int?> climbRateFpm,
      Value<int?> descentRateFpm,
      required double fuelBurnLph,
      required double usableFuelL,
      Value<String> fuelType,
      Value<double?> emptyWeightKg,
      Value<double?> maxTakeoffWeightKg,
      Value<int?> maxCrosswindKt,
      Value<String> notes,
    });
typedef $$AircraftProfilesTableUpdateCompanionBuilder =
    AircraftProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icaoType,
      Value<String> registration,
      Value<int> cruiseTas,
      Value<int?> climbTas,
      Value<int?> climbRateFpm,
      Value<int?> descentRateFpm,
      Value<double> fuelBurnLph,
      Value<double> usableFuelL,
      Value<String> fuelType,
      Value<double?> emptyWeightKg,
      Value<double?> maxTakeoffWeightKg,
      Value<int?> maxCrosswindKt,
      Value<String> notes,
    });

final class $$AircraftProfilesTableReferences
    extends
        BaseReferences<_$AppDatabase, $AircraftProfilesTable, AircraftProfile> {
  $$AircraftProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$FlightsTable, List<Flight>> _flightsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.flights,
    aliasName: 'aircraft_profiles__id__flights__aircraft_id',
  );

  $$FlightsTableProcessedTableManager get flightsRefs {
    final manager = $$FlightsTableTableManager(
      $_db,
      $_db.flights,
    ).filter((f) => f.aircraftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_flightsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AircraftProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $AircraftProfilesTable> {
  $$AircraftProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icaoType => $composableBuilder(
    column: $table.icaoType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registration => $composableBuilder(
    column: $table.registration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cruiseTas => $composableBuilder(
    column: $table.cruiseTas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get climbTas => $composableBuilder(
    column: $table.climbTas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get climbRateFpm => $composableBuilder(
    column: $table.climbRateFpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get descentRateFpm => $composableBuilder(
    column: $table.descentRateFpm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fuelBurnLph => $composableBuilder(
    column: $table.fuelBurnLph,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usableFuelL => $composableBuilder(
    column: $table.usableFuelL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get emptyWeightKg => $composableBuilder(
    column: $table.emptyWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxTakeoffWeightKg => $composableBuilder(
    column: $table.maxTakeoffWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxCrosswindKt => $composableBuilder(
    column: $table.maxCrosswindKt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> flightsRefs(
    Expression<bool> Function($$FlightsTableFilterComposer f) f,
  ) {
    final $$FlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.aircraftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableFilterComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AircraftProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $AircraftProfilesTable> {
  $$AircraftProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icaoType => $composableBuilder(
    column: $table.icaoType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registration => $composableBuilder(
    column: $table.registration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cruiseTas => $composableBuilder(
    column: $table.cruiseTas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get climbTas => $composableBuilder(
    column: $table.climbTas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get climbRateFpm => $composableBuilder(
    column: $table.climbRateFpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get descentRateFpm => $composableBuilder(
    column: $table.descentRateFpm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fuelBurnLph => $composableBuilder(
    column: $table.fuelBurnLph,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usableFuelL => $composableBuilder(
    column: $table.usableFuelL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get emptyWeightKg => $composableBuilder(
    column: $table.emptyWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxTakeoffWeightKg => $composableBuilder(
    column: $table.maxTakeoffWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxCrosswindKt => $composableBuilder(
    column: $table.maxCrosswindKt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AircraftProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AircraftProfilesTable> {
  $$AircraftProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icaoType =>
      $composableBuilder(column: $table.icaoType, builder: (column) => column);

  GeneratedColumn<String> get registration => $composableBuilder(
    column: $table.registration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cruiseTas =>
      $composableBuilder(column: $table.cruiseTas, builder: (column) => column);

  GeneratedColumn<int> get climbTas =>
      $composableBuilder(column: $table.climbTas, builder: (column) => column);

  GeneratedColumn<int> get climbRateFpm => $composableBuilder(
    column: $table.climbRateFpm,
    builder: (column) => column,
  );

  GeneratedColumn<int> get descentRateFpm => $composableBuilder(
    column: $table.descentRateFpm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fuelBurnLph => $composableBuilder(
    column: $table.fuelBurnLph,
    builder: (column) => column,
  );

  GeneratedColumn<double> get usableFuelL => $composableBuilder(
    column: $table.usableFuelL,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<double> get emptyWeightKg => $composableBuilder(
    column: $table.emptyWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxTakeoffWeightKg => $composableBuilder(
    column: $table.maxTakeoffWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxCrosswindKt => $composableBuilder(
    column: $table.maxCrosswindKt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> flightsRefs<T extends Object>(
    Expression<T> Function($$FlightsTableAnnotationComposer a) f,
  ) {
    final $$FlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.aircraftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AircraftProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AircraftProfilesTable,
          AircraftProfile,
          $$AircraftProfilesTableFilterComposer,
          $$AircraftProfilesTableOrderingComposer,
          $$AircraftProfilesTableAnnotationComposer,
          $$AircraftProfilesTableCreateCompanionBuilder,
          $$AircraftProfilesTableUpdateCompanionBuilder,
          (AircraftProfile, $$AircraftProfilesTableReferences),
          AircraftProfile,
          PrefetchHooks Function({bool flightsRefs})
        > {
  $$AircraftProfilesTableTableManager(
    _$AppDatabase db,
    $AircraftProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AircraftProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AircraftProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AircraftProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icaoType = const Value.absent(),
                Value<String> registration = const Value.absent(),
                Value<int> cruiseTas = const Value.absent(),
                Value<int?> climbTas = const Value.absent(),
                Value<int?> climbRateFpm = const Value.absent(),
                Value<int?> descentRateFpm = const Value.absent(),
                Value<double> fuelBurnLph = const Value.absent(),
                Value<double> usableFuelL = const Value.absent(),
                Value<String> fuelType = const Value.absent(),
                Value<double?> emptyWeightKg = const Value.absent(),
                Value<double?> maxTakeoffWeightKg = const Value.absent(),
                Value<int?> maxCrosswindKt = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => AircraftProfilesCompanion(
                id: id,
                name: name,
                icaoType: icaoType,
                registration: registration,
                cruiseTas: cruiseTas,
                climbTas: climbTas,
                climbRateFpm: climbRateFpm,
                descentRateFpm: descentRateFpm,
                fuelBurnLph: fuelBurnLph,
                usableFuelL: usableFuelL,
                fuelType: fuelType,
                emptyWeightKg: emptyWeightKg,
                maxTakeoffWeightKg: maxTakeoffWeightKg,
                maxCrosswindKt: maxCrosswindKt,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icaoType,
                Value<String> registration = const Value.absent(),
                required int cruiseTas,
                Value<int?> climbTas = const Value.absent(),
                Value<int?> climbRateFpm = const Value.absent(),
                Value<int?> descentRateFpm = const Value.absent(),
                required double fuelBurnLph,
                required double usableFuelL,
                Value<String> fuelType = const Value.absent(),
                Value<double?> emptyWeightKg = const Value.absent(),
                Value<double?> maxTakeoffWeightKg = const Value.absent(),
                Value<int?> maxCrosswindKt = const Value.absent(),
                Value<String> notes = const Value.absent(),
              }) => AircraftProfilesCompanion.insert(
                id: id,
                name: name,
                icaoType: icaoType,
                registration: registration,
                cruiseTas: cruiseTas,
                climbTas: climbTas,
                climbRateFpm: climbRateFpm,
                descentRateFpm: descentRateFpm,
                fuelBurnLph: fuelBurnLph,
                usableFuelL: usableFuelL,
                fuelType: fuelType,
                emptyWeightKg: emptyWeightKg,
                maxTakeoffWeightKg: maxTakeoffWeightKg,
                maxCrosswindKt: maxCrosswindKt,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AircraftProfilesTable, AircraftProfile>(table),
                  $$AircraftProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flightsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (flightsRefs) db.flights],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (flightsRefs)
                    await $_getPrefetchedDataByColumns<
                      AircraftProfile,
                      $AircraftProfilesTable,
                      Flight,
                      $FlightsTable
                    >(
                      currentTable: table,
                      referencedTable: $$AircraftProfilesTableReferences
                          ._flightsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AircraftProfilesTableReferences(
                            db,
                            table,
                            p0,
                          ).flightsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'aircraft_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AircraftProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AircraftProfilesTable,
      AircraftProfile,
      $$AircraftProfilesTableFilterComposer,
      $$AircraftProfilesTableOrderingComposer,
      $$AircraftProfilesTableAnnotationComposer,
      $$AircraftProfilesTableCreateCompanionBuilder,
      $$AircraftProfilesTableUpdateCompanionBuilder,
      (AircraftProfile, $$AircraftProfilesTableReferences),
      AircraftProfile,
      PrefetchHooks Function({bool flightsRefs})
    >;
typedef $$FlightsTableCreateCompanionBuilder = FlightsCompanion Function({
  Value<int> id,
  required String title,
  required FlightRules rules,
  Value<FlightStatus> status,
  Value<int?> aircraftId,
  required String departureIdent,
  required String destinationIdent,
  Value<String?> alternateIdent,
  Value<String?> departureRunway,
  Value<String?> arrivalRunway,
  Value<int?> cruiseAltitudeFt,
  Value<DateTime?> plannedDeparture,
  Value<int?> windDirection,
  Value<int?> windSpeedKt,
  Value<String> notes,
  Value<DateTime?> blockOffAt,
  Value<DateTime?> takeoffAt,
  Value<DateTime?> landingAt,
  Value<DateTime?> blockOnAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$FlightsTableUpdateCompanionBuilder = FlightsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<FlightRules> rules,
  Value<FlightStatus> status,
  Value<int?> aircraftId,
  Value<String> departureIdent,
  Value<String> destinationIdent,
  Value<String?> alternateIdent,
  Value<String?> departureRunway,
  Value<String?> arrivalRunway,
  Value<int?> cruiseAltitudeFt,
  Value<DateTime?> plannedDeparture,
  Value<int?> windDirection,
  Value<int?> windSpeedKt,
  Value<String> notes,
  Value<DateTime?> blockOffAt,
  Value<DateTime?> takeoffAt,
  Value<DateTime?> landingAt,
  Value<DateTime?> blockOnAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$FlightsTableReferences
    extends BaseReferences<_$AppDatabase, $FlightsTable, Flight> {
  $$FlightsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AircraftProfilesTable _aircraftIdTable(_$AppDatabase db) => db
      .aircraftProfiles
      .createAlias('flights__aircraft_id__aircraft_profiles__id');

  $$AircraftProfilesTableProcessedTableManager? get aircraftId {
    final $_column = $_itemColumn<int>('aircraft_id');
    if ($_column == null) return null;
    final manager = $$AircraftProfilesTableTableManager(
      $_db,
      $_db.aircraftProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_aircraftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FlightWaypointsTable, List<FlightWaypoint>>
  _flightWaypointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flightWaypoints,
    aliasName: 'flights__id__flight_waypoints__flight_id',
  );

  $$FlightWaypointsTableProcessedTableManager get flightWaypointsRefs {
    final manager = $$FlightWaypointsTableTableManager(
      $_db,
      $_db.flightWaypoints,
    ).filter((f) => f.flightId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _flightWaypointsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScratchPagesTable, List<ScratchPage>>
  _scratchPagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scratchPages,
    aliasName: 'flights__id__scratch_pages__flight_id',
  );

  $$ScratchPagesTableProcessedTableManager get scratchPagesRefs {
    final manager = $$ScratchPagesTableTableManager(
      $_db,
      $_db.scratchPages,
    ).filter((f) => f.flightId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_scratchPagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FlightsTableFilterComposer
    extends Composer<_$AppDatabase, $FlightsTable> {
  $$FlightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FlightRules, FlightRules, String> get rules =>
      $composableBuilder(
        column: $table.rules,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<FlightStatus, FlightStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get departureIdent => $composableBuilder(
    column: $table.departureIdent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationIdent => $composableBuilder(
    column: $table.destinationIdent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alternateIdent => $composableBuilder(
    column: $table.alternateIdent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departureRunway => $composableBuilder(
    column: $table.departureRunway,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arrivalRunway => $composableBuilder(
    column: $table.arrivalRunway,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cruiseAltitudeFt => $composableBuilder(
    column: $table.cruiseAltitudeFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedDeparture => $composableBuilder(
    column: $table.plannedDeparture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windSpeedKt => $composableBuilder(
    column: $table.windSpeedKt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get blockOffAt => $composableBuilder(
    column: $table.blockOffAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takeoffAt => $composableBuilder(
    column: $table.takeoffAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get landingAt => $composableBuilder(
    column: $table.landingAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get blockOnAt => $composableBuilder(
    column: $table.blockOnAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AircraftProfilesTableFilterComposer get aircraftId {
    final $$AircraftProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aircraftId,
      referencedTable: $db.aircraftProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AircraftProfilesTableFilterComposer(
            $db: $db,
            $table: $db.aircraftProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> flightWaypointsRefs(
    Expression<bool> Function($$FlightWaypointsTableFilterComposer f) f,
  ) {
    final $$FlightWaypointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flightWaypoints,
      getReferencedColumn: (t) => t.flightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightWaypointsTableFilterComposer(
            $db: $db,
            $table: $db.flightWaypoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scratchPagesRefs(
    Expression<bool> Function($$ScratchPagesTableFilterComposer f) f,
  ) {
    final $$ScratchPagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scratchPages,
      getReferencedColumn: (t) => t.flightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScratchPagesTableFilterComposer(
            $db: $db,
            $table: $db.scratchPages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlightsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlightsTable> {
  $$FlightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rules => $composableBuilder(
    column: $table.rules,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departureIdent => $composableBuilder(
    column: $table.departureIdent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationIdent => $composableBuilder(
    column: $table.destinationIdent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alternateIdent => $composableBuilder(
    column: $table.alternateIdent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departureRunway => $composableBuilder(
    column: $table.departureRunway,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arrivalRunway => $composableBuilder(
    column: $table.arrivalRunway,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cruiseAltitudeFt => $composableBuilder(
    column: $table.cruiseAltitudeFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedDeparture => $composableBuilder(
    column: $table.plannedDeparture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windSpeedKt => $composableBuilder(
    column: $table.windSpeedKt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get blockOffAt => $composableBuilder(
    column: $table.blockOffAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takeoffAt => $composableBuilder(
    column: $table.takeoffAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get landingAt => $composableBuilder(
    column: $table.landingAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get blockOnAt => $composableBuilder(
    column: $table.blockOnAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AircraftProfilesTableOrderingComposer get aircraftId {
    final $$AircraftProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aircraftId,
      referencedTable: $db.aircraftProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AircraftProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.aircraftProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlightsTable> {
  $$FlightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FlightRules, String> get rules =>
      $composableBuilder(column: $table.rules, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FlightStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get departureIdent => $composableBuilder(
    column: $table.departureIdent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destinationIdent => $composableBuilder(
    column: $table.destinationIdent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alternateIdent => $composableBuilder(
    column: $table.alternateIdent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get departureRunway => $composableBuilder(
    column: $table.departureRunway,
    builder: (column) => column,
  );

  GeneratedColumn<String> get arrivalRunway => $composableBuilder(
    column: $table.arrivalRunway,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cruiseAltitudeFt => $composableBuilder(
    column: $table.cruiseAltitudeFt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get plannedDeparture => $composableBuilder(
    column: $table.plannedDeparture,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windSpeedKt => $composableBuilder(
    column: $table.windSpeedKt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get blockOffAt => $composableBuilder(
    column: $table.blockOffAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get takeoffAt =>
      $composableBuilder(column: $table.takeoffAt, builder: (column) => column);

  GeneratedColumn<DateTime> get landingAt =>
      $composableBuilder(column: $table.landingAt, builder: (column) => column);

  GeneratedColumn<DateTime> get blockOnAt =>
      $composableBuilder(column: $table.blockOnAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AircraftProfilesTableAnnotationComposer get aircraftId {
    final $$AircraftProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.aircraftId,
      referencedTable: $db.aircraftProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AircraftProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.aircraftProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> flightWaypointsRefs<T extends Object>(
    Expression<T> Function($$FlightWaypointsTableAnnotationComposer a) f,
  ) {
    final $$FlightWaypointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flightWaypoints,
      getReferencedColumn: (t) => t.flightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightWaypointsTableAnnotationComposer(
            $db: $db,
            $table: $db.flightWaypoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scratchPagesRefs<T extends Object>(
    Expression<T> Function($$ScratchPagesTableAnnotationComposer a) f,
  ) {
    final $$ScratchPagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scratchPages,
      getReferencedColumn: (t) => t.flightId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScratchPagesTableAnnotationComposer(
            $db: $db,
            $table: $db.scratchPages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FlightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlightsTable,
          Flight,
          $$FlightsTableFilterComposer,
          $$FlightsTableOrderingComposer,
          $$FlightsTableAnnotationComposer,
          $$FlightsTableCreateCompanionBuilder,
          $$FlightsTableUpdateCompanionBuilder,
          (Flight, $$FlightsTableReferences),
          Flight,
          PrefetchHooks Function({
            bool aircraftId,
            bool flightWaypointsRefs,
            bool scratchPagesRefs,
          })
        > {
  $$FlightsTableTableManager(_$AppDatabase db, $FlightsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlightsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<FlightRules> rules = const Value.absent(),
                Value<FlightStatus> status = const Value.absent(),
                Value<int?> aircraftId = const Value.absent(),
                Value<String> departureIdent = const Value.absent(),
                Value<String> destinationIdent = const Value.absent(),
                Value<String?> alternateIdent = const Value.absent(),
                Value<String?> departureRunway = const Value.absent(),
                Value<String?> arrivalRunway = const Value.absent(),
                Value<int?> cruiseAltitudeFt = const Value.absent(),
                Value<DateTime?> plannedDeparture = const Value.absent(),
                Value<int?> windDirection = const Value.absent(),
                Value<int?> windSpeedKt = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> blockOffAt = const Value.absent(),
                Value<DateTime?> takeoffAt = const Value.absent(),
                Value<DateTime?> landingAt = const Value.absent(),
                Value<DateTime?> blockOnAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FlightsCompanion(
                id: id,
                title: title,
                rules: rules,
                status: status,
                aircraftId: aircraftId,
                departureIdent: departureIdent,
                destinationIdent: destinationIdent,
                alternateIdent: alternateIdent,
                departureRunway: departureRunway,
                arrivalRunway: arrivalRunway,
                cruiseAltitudeFt: cruiseAltitudeFt,
                plannedDeparture: plannedDeparture,
                windDirection: windDirection,
                windSpeedKt: windSpeedKt,
                notes: notes,
                blockOffAt: blockOffAt,
                takeoffAt: takeoffAt,
                landingAt: landingAt,
                blockOnAt: blockOnAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required FlightRules rules,
                Value<FlightStatus> status = const Value.absent(),
                Value<int?> aircraftId = const Value.absent(),
                required String departureIdent,
                required String destinationIdent,
                Value<String?> alternateIdent = const Value.absent(),
                Value<String?> departureRunway = const Value.absent(),
                Value<String?> arrivalRunway = const Value.absent(),
                Value<int?> cruiseAltitudeFt = const Value.absent(),
                Value<DateTime?> plannedDeparture = const Value.absent(),
                Value<int?> windDirection = const Value.absent(),
                Value<int?> windSpeedKt = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> blockOffAt = const Value.absent(),
                Value<DateTime?> takeoffAt = const Value.absent(),
                Value<DateTime?> landingAt = const Value.absent(),
                Value<DateTime?> blockOnAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FlightsCompanion.insert(
                id: id,
                title: title,
                rules: rules,
                status: status,
                aircraftId: aircraftId,
                departureIdent: departureIdent,
                destinationIdent: destinationIdent,
                alternateIdent: alternateIdent,
                departureRunway: departureRunway,
                arrivalRunway: arrivalRunway,
                cruiseAltitudeFt: cruiseAltitudeFt,
                plannedDeparture: plannedDeparture,
                windDirection: windDirection,
                windSpeedKt: windSpeedKt,
                notes: notes,
                blockOffAt: blockOffAt,
                takeoffAt: takeoffAt,
                landingAt: landingAt,
                blockOnAt: blockOnAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FlightsTable, Flight>(table),
                  $$FlightsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                aircraftId = false,
                flightWaypointsRefs = false,
                scratchPagesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (flightWaypointsRefs) db.flightWaypoints,
                    if (scratchPagesRefs) db.scratchPages,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (aircraftId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.aircraftId,
                            referencedTable: $$FlightsTableReferences
                                ._aircraftIdTable(db),
                            referencedColumn: $$FlightsTableReferences
                                ._aircraftIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (flightWaypointsRefs)
                        await $_getPrefetchedDataByColumns<
                          Flight,
                          $FlightsTable,
                          FlightWaypoint,
                          $FlightWaypointsTable
                        >(
                          currentTable: table,
                          referencedTable: $$FlightsTableReferences
                              ._flightWaypointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FlightsTableReferences(
                                db,
                                table,
                                p0,
                              ).flightWaypointsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'flight_id',
                          typedResults: items,
                        ),
                      if (scratchPagesRefs)
                        await $_getPrefetchedDataByColumns<
                          Flight,
                          $FlightsTable,
                          ScratchPage,
                          $ScratchPagesTable
                        >(
                          currentTable: table,
                          referencedTable: $$FlightsTableReferences
                              ._scratchPagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FlightsTableReferences(
                                db,
                                table,
                                p0,
                              ).scratchPagesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'flight_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FlightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlightsTable,
      Flight,
      $$FlightsTableFilterComposer,
      $$FlightsTableOrderingComposer,
      $$FlightsTableAnnotationComposer,
      $$FlightsTableCreateCompanionBuilder,
      $$FlightsTableUpdateCompanionBuilder,
      (Flight, $$FlightsTableReferences),
      Flight,
      PrefetchHooks Function({
        bool aircraftId,
        bool flightWaypointsRefs,
        bool scratchPagesRefs,
      })
    >;
typedef $$FlightWaypointsTableCreateCompanionBuilder =
    FlightWaypointsCompanion Function({
      Value<int> id,
      required int flightId,
      required int sequence,
      required WaypointKind kind,
      Value<int?> refId,
      required String ident,
      Value<String> name,
      required double latitude,
      required double longitude,
      Value<int?> altitudeFt,
      Value<int?> windDirection,
      Value<int?> windSpeedKt,
      Value<String> notes,
      Value<DateTime?> actualTimeOver,
    });
typedef $$FlightWaypointsTableUpdateCompanionBuilder =
    FlightWaypointsCompanion Function({
      Value<int> id,
      Value<int> flightId,
      Value<int> sequence,
      Value<WaypointKind> kind,
      Value<int?> refId,
      Value<String> ident,
      Value<String> name,
      Value<double> latitude,
      Value<double> longitude,
      Value<int?> altitudeFt,
      Value<int?> windDirection,
      Value<int?> windSpeedKt,
      Value<String> notes,
      Value<DateTime?> actualTimeOver,
    });

final class $$FlightWaypointsTableReferences
    extends
        BaseReferences<_$AppDatabase, $FlightWaypointsTable, FlightWaypoint> {
  $$FlightWaypointsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FlightsTable _flightIdTable(_$AppDatabase db) =>
      db.flights.createAlias('flight_waypoints__flight_id__flights__id');

  $$FlightsTableProcessedTableManager get flightId {
    final $_column = $_itemColumn<int>('flight_id')!;

    final manager = $$FlightsTableTableManager(
      $_db,
      $_db.flights,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flightIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FlightWaypointsTableFilterComposer
    extends Composer<_$AppDatabase, $FlightWaypointsTable> {
  $$FlightWaypointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WaypointKind, WaypointKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ident => $composableBuilder(
    column: $table.ident,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get altitudeFt => $composableBuilder(
    column: $table.altitudeFt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windSpeedKt => $composableBuilder(
    column: $table.windSpeedKt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualTimeOver => $composableBuilder(
    column: $table.actualTimeOver,
    builder: (column) => ColumnFilters(column),
  );

  $$FlightsTableFilterComposer get flightId {
    final $$FlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableFilterComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightWaypointsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlightWaypointsTable> {
  $$FlightWaypointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ident => $composableBuilder(
    column: $table.ident,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get altitudeFt => $composableBuilder(
    column: $table.altitudeFt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windSpeedKt => $composableBuilder(
    column: $table.windSpeedKt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualTimeOver => $composableBuilder(
    column: $table.actualTimeOver,
    builder: (column) => ColumnOrderings(column),
  );

  $$FlightsTableOrderingComposer get flightId {
    final $$FlightsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableOrderingComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightWaypointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlightWaypointsTable> {
  $$FlightWaypointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WaypointKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<String> get ident =>
      $composableBuilder(column: $table.ident, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get altitudeFt => $composableBuilder(
    column: $table.altitudeFt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windDirection => $composableBuilder(
    column: $table.windDirection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windSpeedKt => $composableBuilder(
    column: $table.windSpeedKt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get actualTimeOver => $composableBuilder(
    column: $table.actualTimeOver,
    builder: (column) => column,
  );

  $$FlightsTableAnnotationComposer get flightId {
    final $$FlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FlightWaypointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlightWaypointsTable,
          FlightWaypoint,
          $$FlightWaypointsTableFilterComposer,
          $$FlightWaypointsTableOrderingComposer,
          $$FlightWaypointsTableAnnotationComposer,
          $$FlightWaypointsTableCreateCompanionBuilder,
          $$FlightWaypointsTableUpdateCompanionBuilder,
          (FlightWaypoint, $$FlightWaypointsTableReferences),
          FlightWaypoint,
          PrefetchHooks Function({bool flightId})
        > {
  $$FlightWaypointsTableTableManager(
    _$AppDatabase db,
    $FlightWaypointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlightWaypointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlightWaypointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlightWaypointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> flightId = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<WaypointKind> kind = const Value.absent(),
                Value<int?> refId = const Value.absent(),
                Value<String> ident = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<int?> altitudeFt = const Value.absent(),
                Value<int?> windDirection = const Value.absent(),
                Value<int?> windSpeedKt = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> actualTimeOver = const Value.absent(),
              }) => FlightWaypointsCompanion(
                id: id,
                flightId: flightId,
                sequence: sequence,
                kind: kind,
                refId: refId,
                ident: ident,
                name: name,
                latitude: latitude,
                longitude: longitude,
                altitudeFt: altitudeFt,
                windDirection: windDirection,
                windSpeedKt: windSpeedKt,
                notes: notes,
                actualTimeOver: actualTimeOver,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int flightId,
                required int sequence,
                required WaypointKind kind,
                Value<int?> refId = const Value.absent(),
                required String ident,
                Value<String> name = const Value.absent(),
                required double latitude,
                required double longitude,
                Value<int?> altitudeFt = const Value.absent(),
                Value<int?> windDirection = const Value.absent(),
                Value<int?> windSpeedKt = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> actualTimeOver = const Value.absent(),
              }) => FlightWaypointsCompanion.insert(
                id: id,
                flightId: flightId,
                sequence: sequence,
                kind: kind,
                refId: refId,
                ident: ident,
                name: name,
                latitude: latitude,
                longitude: longitude,
                altitudeFt: altitudeFt,
                windDirection: windDirection,
                windSpeedKt: windSpeedKt,
                notes: notes,
                actualTimeOver: actualTimeOver,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FlightWaypointsTable, FlightWaypoint>(table),
                  $$FlightWaypointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flightId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (flightId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.flightId,
                        referencedTable: $$FlightWaypointsTableReferences
                            ._flightIdTable(db),
                        referencedColumn: $$FlightWaypointsTableReferences
                            ._flightIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FlightWaypointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlightWaypointsTable,
      FlightWaypoint,
      $$FlightWaypointsTableFilterComposer,
      $$FlightWaypointsTableOrderingComposer,
      $$FlightWaypointsTableAnnotationComposer,
      $$FlightWaypointsTableCreateCompanionBuilder,
      $$FlightWaypointsTableUpdateCompanionBuilder,
      (FlightWaypoint, $$FlightWaypointsTableReferences),
      FlightWaypoint,
      PrefetchHooks Function({bool flightId})
    >;
typedef $$ScratchPagesTableCreateCompanionBuilder =
    ScratchPagesCompanion Function({
      Value<int> id,
      Value<int?> flightId,
      required int sequence,
      Value<PageBackground> background,
      Value<String> strokes,
      Value<DateTime> updatedAt,
    });
typedef $$ScratchPagesTableUpdateCompanionBuilder =
    ScratchPagesCompanion Function({
      Value<int> id,
      Value<int?> flightId,
      Value<int> sequence,
      Value<PageBackground> background,
      Value<String> strokes,
      Value<DateTime> updatedAt,
    });

final class $$ScratchPagesTableReferences
    extends BaseReferences<_$AppDatabase, $ScratchPagesTable, ScratchPage> {
  $$ScratchPagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FlightsTable _flightIdTable(_$AppDatabase db) =>
      db.flights.createAlias('scratch_pages__flight_id__flights__id');

  $$FlightsTableProcessedTableManager? get flightId {
    final $_column = $_itemColumn<int>('flight_id');
    if ($_column == null) return null;
    final manager = $$FlightsTableTableManager(
      $_db,
      $_db.flights,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flightIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScratchPagesTableFilterComposer
    extends Composer<_$AppDatabase, $ScratchPagesTable> {
  $$ScratchPagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PageBackground, PageBackground, String>
  get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get strokes => $composableBuilder(
    column: $table.strokes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FlightsTableFilterComposer get flightId {
    final $$FlightsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableFilterComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScratchPagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScratchPagesTable> {
  $$ScratchPagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sequence => $composableBuilder(
    column: $table.sequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strokes => $composableBuilder(
    column: $table.strokes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FlightsTableOrderingComposer get flightId {
    final $$FlightsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableOrderingComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScratchPagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScratchPagesTable> {
  $$ScratchPagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PageBackground, String> get background =>
      $composableBuilder(
        column: $table.background,
        builder: (column) => column,
      );

  GeneratedColumn<String> get strokes =>
      $composableBuilder(column: $table.strokes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$FlightsTableAnnotationComposer get flightId {
    final $$FlightsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flightId,
      referencedTable: $db.flights,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FlightsTableAnnotationComposer(
            $db: $db,
            $table: $db.flights,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScratchPagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScratchPagesTable,
          ScratchPage,
          $$ScratchPagesTableFilterComposer,
          $$ScratchPagesTableOrderingComposer,
          $$ScratchPagesTableAnnotationComposer,
          $$ScratchPagesTableCreateCompanionBuilder,
          $$ScratchPagesTableUpdateCompanionBuilder,
          (ScratchPage, $$ScratchPagesTableReferences),
          ScratchPage,
          PrefetchHooks Function({bool flightId})
        > {
  $$ScratchPagesTableTableManager(_$AppDatabase db, $ScratchPagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScratchPagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScratchPagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScratchPagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> flightId = const Value.absent(),
                Value<int> sequence = const Value.absent(),
                Value<PageBackground> background = const Value.absent(),
                Value<String> strokes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ScratchPagesCompanion(
                id: id,
                flightId: flightId,
                sequence: sequence,
                background: background,
                strokes: strokes,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> flightId = const Value.absent(),
                required int sequence,
                Value<PageBackground> background = const Value.absent(),
                Value<String> strokes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ScratchPagesCompanion.insert(
                id: id,
                flightId: flightId,
                sequence: sequence,
                background: background,
                strokes: strokes,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScratchPagesTable, ScratchPage>(table),
                  $$ScratchPagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flightId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (flightId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.flightId,
                        referencedTable: $$ScratchPagesTableReferences
                            ._flightIdTable(db),
                        referencedColumn: $$ScratchPagesTableReferences
                            ._flightIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScratchPagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScratchPagesTable,
      ScratchPage,
      $$ScratchPagesTableFilterComposer,
      $$ScratchPagesTableOrderingComposer,
      $$ScratchPagesTableAnnotationComposer,
      $$ScratchPagesTableCreateCompanionBuilder,
      $$ScratchPagesTableUpdateCompanionBuilder,
      (ScratchPage, $$ScratchPagesTableReferences),
      ScratchPage,
      PrefetchHooks Function({bool flightId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AirportsTableTableManager get airports =>
      $$AirportsTableTableManager(_db, _db.airports);
  $$RunwaysTableTableManager get runways =>
      $$RunwaysTableTableManager(_db, _db.runways);
  $$AirportFrequenciesTableTableManager get airportFrequencies =>
      $$AirportFrequenciesTableTableManager(_db, _db.airportFrequencies);
  $$NavaidsTableTableManager get navaids =>
      $$NavaidsTableTableManager(_db, _db.navaids);
  $$AircraftProfilesTableTableManager get aircraftProfiles =>
      $$AircraftProfilesTableTableManager(_db, _db.aircraftProfiles);
  $$FlightsTableTableManager get flights =>
      $$FlightsTableTableManager(_db, _db.flights);
  $$FlightWaypointsTableTableManager get flightWaypoints =>
      $$FlightWaypointsTableTableManager(_db, _db.flightWaypoints);
  $$ScratchPagesTableTableManager get scratchPages =>
      $$ScratchPagesTableTableManager(_db, _db.scratchPages);
}
