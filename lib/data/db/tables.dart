import 'package:drift/drift.dart';

// ---------------------------------------------------------------------------
// Navdata (imported from OurAirports, replaced wholesale on every import)
// ---------------------------------------------------------------------------

@TableIndex(name: 'airports_ident', columns: {#ident})
@TableIndex(name: 'airports_position', columns: {#latitude, #longitude})
class Airports extends Table {
  /// OurAirports id.
  IntColumn get id => integer()();
  TextColumn get ident => text()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get elevationFt => integer().nullable()();
  TextColumn get isoCountry => text()();
  TextColumn get isoRegion => text()();
  TextColumn get municipality => text().nullable()();
  TextColumn get icaoCode => text().nullable()();
  TextColumn get iataCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'runways_airport', columns: {#airportId})
class Runways extends Table {
  IntColumn get id => integer()();
  IntColumn get airportId => integer()();
  IntColumn get lengthFt => integer().nullable()();
  IntColumn get widthFt => integer().nullable()();
  TextColumn get surface => text().nullable()();
  BoolColumn get lighted => boolean()();
  BoolColumn get closed => boolean()();
  TextColumn get leIdent => text().nullable()();
  RealColumn get leHeadingTrue => real().nullable()();
  IntColumn get leElevationFt => integer().nullable()();
  RealColumn get leLatitude => real().nullable()();
  RealColumn get leLongitude => real().nullable()();
  TextColumn get heIdent => text().nullable()();
  RealColumn get heHeadingTrue => real().nullable()();
  IntColumn get heElevationFt => integer().nullable()();
  RealColumn get heLatitude => real().nullable()();
  RealColumn get heLongitude => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'frequencies_airport', columns: {#airportId})
class AirportFrequencies extends Table {
  IntColumn get id => integer()();
  IntColumn get airportId => integer()();

  /// e.g. ATIS, TWR, GND, APP, INFO, CTAF, UNIC.
  TextColumn get type => text()();
  TextColumn get description => text().nullable()();
  RealColumn get frequencyMhz => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'navaids_ident', columns: {#ident})
@TableIndex(name: 'navaids_position', columns: {#latitude, #longitude})
class Navaids extends Table {
  IntColumn get id => integer()();
  TextColumn get ident => text()();
  TextColumn get name => text()();

  /// VOR, VOR-DME, VORTAC, DME, NDB, NDB-DME, TACAN.
  TextColumn get type => text()();

  /// VORs are stored in kHz too (e.g. 114300), as in the source data.
  IntColumn get frequencyKhz => integer().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get elevationFt => integer().nullable()();
  TextColumn get isoCountry => text()();
  RealColumn get magneticVariation => real().nullable()();
  TextColumn get associatedAirport => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---------------------------------------------------------------------------
// User data
// ---------------------------------------------------------------------------

/// Internal units: knots, feet, litres, kilograms.
class AircraftProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icaoType => text()();
  TextColumn get registration => text().withDefault(const Constant(''))();
  IntColumn get cruiseTas => integer()();
  IntColumn get climbTas => integer().nullable()();
  IntColumn get climbRateFpm => integer().nullable()();
  IntColumn get descentRateFpm => integer().nullable()();
  RealColumn get fuelBurnLph => real()();
  RealColumn get usableFuelL => real()();

  /// Drives the fuel unit shown for this aircraft (avgas/jet-a).
  TextColumn get fuelType => text().withDefault(const Constant('avgas'))();
  RealColumn get emptyWeightKg => real().nullable()();
  RealColumn get maxTakeoffWeightKg => real().nullable()();

  /// Maximum demonstrated crosswind component.
  IntColumn get maxCrosswindKt => integer().nullable()();

  /// Typical taxi fuel.
  RealColumn get taxiFuelL => real().nullable()();

  /// Weight & balance: arm unit as in the POH (`in`, `m`, `mm`), empty CG
  /// arm, loading stations and CG envelope as JSON (see
  /// `core/weight_balance.dart`).
  TextColumn get armUnit => text().withDefault(const Constant('in'))();
  RealColumn get emptyArm => real().nullable()();
  TextColumn get stations => text().withDefault(const Constant('[]'))();
  TextColumn get envelope => text().withDefault(const Constant('[]'))();
  TextColumn get notes => text().withDefault(const Constant(''))();
}

enum FlightRules { vfr, ifr }

enum FlightStatus { planned, active, completed }

class Flights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get rules => textEnum<FlightRules>()();
  TextColumn get status =>
      textEnum<FlightStatus>().withDefault(const Constant('planned'))();
  IntColumn get aircraftId =>
      integer().nullable().references(AircraftProfiles, #id)();
  TextColumn get departureIdent => text()();
  TextColumn get destinationIdent => text()();
  TextColumn get alternateIdent => text().nullable()();

  /// Expected runway ends, e.g. `26` or `08R`.
  TextColumn get departureRunway => text().nullable()();
  TextColumn get arrivalRunway => text().nullable()();
  IntColumn get cruiseAltitudeFt => integer().nullable()();
  DateTimeColumn get plannedDeparture => dateTime().nullable()();

  // Fuel plan; null = defaults from rules and aircraft.
  RealColumn get taxiFuelL => real().nullable()();
  RealColumn get contingencyPercent => real().nullable()();
  IntColumn get finalReserveMinutes => integer().nullable()();
  RealColumn get extraFuelL => real().nullable()();
  RealColumn get fuelOnBoardL => real().nullable()();
  BoolColumn get night => boolean().withDefault(const Constant(false))();

  /// Loads per W&B station in kg, JSON `{"<station index>": kg}`.
  TextColumn get loads => text().withDefault(const Constant('{}'))();

  /// Wind used for every leg without its own wind (true direction, from).
  IntColumn get windDirection => integer().nullable()();
  IntColumn get windSpeedKt => integer().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  // Times recorded on the kneeboard.
  DateTimeColumn get blockOffAt => dateTime().nullable()();
  DateTimeColumn get takeoffAt => dateTime().nullable()();
  DateTimeColumn get landingAt => dateTime().nullable()();
  DateTimeColumn get blockOnAt => dateTime().nullable()();

  // Recorded from the simulator.
  RealColumn get touchdownFpm => real().nullable()();
  RealColumn get touchdownG => real().nullable()();

  /// Flown track, JSON `[[lat, lon, altFt, epochSeconds], ...]`.
  TextColumn get track => text().withDefault(const Constant('[]'))();

  /// Imported operational flight plan, `OfpSummary.encode`.
  TextColumn get ofp => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// [fix]: an IFR waypoint from an OFP (no navdata row), incl. TOC/TOD.
enum WaypointKind { airport, navaid, reportingPoint, user, fix }

@TableIndex(name: 'waypoints_flight', columns: {#flightId, #sequence})
class FlightWaypoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get flightId =>
      integer().references(Flights, #id, onDelete: KeyAction.cascade)();
  IntColumn get sequence => integer()();
  TextColumn get kind => textEnum<WaypointKind>()();

  /// Airport or navaid id for [WaypointKind.airport] / [WaypointKind.navaid].
  IntColumn get refId => integer().nullable()();
  TextColumn get ident => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();

  /// Planned altitude for the leg that ends at this waypoint.
  IntColumn get altitudeFt => integer().nullable()();
  IntColumn get windDirection => integer().nullable()();
  IntColumn get windSpeedKt => integer().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// Airway, SID/STAR or `DCT` on the leg to this waypoint (IFR).
  TextColumn get via => text().nullable()();

  /// Own TAS and fuel flow for the leg to this waypoint, e.g. climb and
  /// descent from an OFP; `null` = the aircraft's cruise values.
  IntColumn get tasKt => integer().nullable()();
  RealColumn get fuelFlowLph => real().nullable()();

  /// Actual time over, filled in during the flight.
  DateTimeColumn get actualTimeOver => dateTime().nullable()();
}

enum PageBackground { blank, grid, lined, atis, craft }

/// A page of the handwritten notepad, per flight or general (no flight).
@TableIndex(name: 'scratch_pages_flight', columns: {#flightId, #sequence})
class ScratchPages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get flightId => integer().nullable().references(
    Flights,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get sequence => integer()();
  TextColumn get background =>
      textEnum<PageBackground>().withDefault(const Constant('blank'))();

  /// JSON-encoded strokes, see `Stroke.toJson`.
  TextColumn get strokes => text().withDefault(const Constant('[]'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Last METAR/TAF per airport for offline use (`WeatherReport.encode`).
class WeatherCache extends Table {
  TextColumn get airportIdent => text()();
  TextColumn get payload => text()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {airportIdent};
}

enum ChartCategory { airport, ground, departure, arrival, approach, vfr, other }

enum ChartFileType { pdf, image }

/// An airport chart. Local charts are imported files in the app's charts
/// directory; `source` leaves room for ChartFox charts later.
@TableIndex(name: 'charts_airport', columns: {#airportIdent})
class Charts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get airportIdent => text()();
  TextColumn get name => text()();
  TextColumn get category => textEnum<ChartCategory>()();
  TextColumn get source => text().withDefault(const Constant('local'))();
  TextColumn get fileType => textEnum<ChartFileType>()();

  /// File name inside the charts directory.
  TextColumn get fileName => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Ink on one chart page, per flight or general (`flightId == null`).
/// Coordinates are page units, 1000 wide (see `Stroke`).
@TableIndex(name: 'chart_annotations_chart', columns: {#chartId, #flightId})
class ChartAnnotations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chartId =>
      integer().references(Charts, #id, onDelete: KeyAction.cascade)();
  IntColumn get flightId => integer().nullable().references(
    Flights,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get page => integer()();
  TextColumn get strokes => text().withDefault(const Constant('[]'))();
}

/// A logbook line, written when a flight is blocked on. It is a copy, so
/// it stays when the flight is edited or deleted.
@TableIndex(name: 'logbook_date', columns: {#blockOffAt})
class LogbookEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get flightId => integer().nullable().references(
    Flights,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get rules => textEnum<FlightRules>()();
  TextColumn get departureIdent => text()();
  TextColumn get destinationIdent => text()();
  TextColumn get aircraftName => text().nullable()();
  TextColumn get aircraftType => text().nullable()();
  DateTimeColumn get blockOffAt => dateTime()();
  DateTimeColumn get takeoffAt => dateTime().nullable()();
  DateTimeColumn get landingAt => dateTime().nullable()();
  DateTimeColumn get blockOnAt => dateTime()();
  IntColumn get landings => integer().withDefault(const Constant(1))();
  RealColumn get distanceNm => real().nullable()();
  RealColumn get touchdownFpm => real().nullable()();
  RealColumn get touchdownG => real().nullable()();
  TextColumn get track => text().withDefault(const Constant('[]'))();
  TextColumn get remarks => text().withDefault(const Constant(''))();
}
