import 'dart:convert';

import 'package:drift/drift.dart';

import '../../core/e6b.dart';
import '../../core/fuel_plan.dart';
import '../../core/nav_math.dart';
import '../../core/navlog.dart';
import '../../core/weight_balance.dart';
import '../db/database.dart';
import '../simbrief/simbrief_ofp.dart';

class FlightWithRoute {
  FlightWithRoute(
    this.flight,
    this.waypoints,
    this.aircraft, {
    this.alternateAirport,
  });

  final Flight flight;
  final List<FlightWaypoint> waypoints;
  final AircraftProfile? aircraft;
  final Airport? alternateAirport;

  FuelKind get fuelKind => fuelKindOf(aircraft?.fuelType ?? 'avgas');

  /// Imported OFP, `null` for flights planned in the app.
  late final OfpSummary? ofp = OfpSummary.decode(flight.ofp);

  /// Fuel from destination to alternate: from the OFP if there is one, else
  /// at cruise TAS with the flight wind.
  double? get alternateFuelL {
    if (ofp?.alternateKg case final kg?) return kg / fuelKind.density;
    final a = aircraft;
    final altn = alternateAirport;
    if (a == null || altn == null || waypoints.isEmpty) return null;
    final dest = waypoints.last;
    final dist = distanceNm(
      dest.latitude,
      dest.longitude,
      altn.latitude,
      altn.longitude,
    );
    final s = solveWind(
      trueCourse: initialCourse(
        dest.latitude,
        dest.longitude,
        altn.latitude,
        altn.longitude,
      ),
      trueAirspeed: a.cruiseTas.toDouble(),
      windFrom: (flight.windDirection ?? 0).toDouble(),
      windSpeed: (flight.windSpeedKt ?? 0).toDouble(),
    );
    return s == null ? null : dist / s.groundSpeed * a.fuelBurnLph;
  }

  FuelPlan? get fuelPlan {
    final a = aircraft;
    final log = navlog;
    if (a == null || log == null) return null;
    return FuelPlan.compute(
      ifr: flight.rules == FlightRules.ifr,
      night: flight.night,
      trip: log.totalFuelL,
      burnLph: a.fuelBurnLph,
      usable: a.usableFuelL,
      taxi: flight.taxiFuelL ?? a.taxiFuelL,
      contingencyPercent: flight.contingencyPercent,
      finalReserveMinutes: flight.finalReserveMinutes,
      alternate: alternateFuelL ?? 0,
      extra: flight.extraFuelL,
      onBoard: flight.fuelOnBoardL,
    );
  }

  List<WbStation> get stations =>
      aircraft == null ? const [] : WbStation.decodeAll(aircraft!.stations);

  Map<int, double> get loadsKg {
    final json = jsonDecode(flight.loads);
    return json is Map
        ? {
            for (final e in json.entries)
              if (int.tryParse('${e.key}') != null && e.value is num)
                int.parse('${e.key}'): (e.value as num).toDouble(),
          }
        : {};
  }

  /// `null` without empty weight/CG in the aircraft profile.
  WbResult? get weightBalance {
    final a = aircraft;
    if (a == null || a.emptyWeightKg == null || a.emptyArm == null) {
      return null;
    }
    final plan = fuelPlan;
    final density = fuelKind.density;
    return WbResult.compute(
      emptyKg: a.emptyWeightKg!,
      emptyArm: a.emptyArm!,
      stations: stations,
      envelope: EnvelopePoint.decodeAll(a.envelope),
      loadsKg: loadsKg,
      takeoffFuelKg: plan == null ? 0 : plan.atTakeoff * density,
      landingFuelKg: plan == null || !plan.valid ? 0 : plan.atLanding * density,
      maxTakeoffKg: a.maxTakeoffWeightKg,
    );
  }

  List<NavlogPoint> get navlogPoints => [
    for (final w in waypoints)
      NavlogPoint(
        ident: w.ident,
        name: w.name,
        latitude: w.latitude,
        longitude: w.longitude,
        altitudeFt: w.altitudeFt,
        windDirection: w.windDirection,
        windSpeedKt: w.windSpeedKt,
        actualTimeOver: w.actualTimeOver,
        via: w.via,
        tasKt: w.tasKt,
        fuelFlowLph: w.fuelFlowLph,
      ),
  ];

  /// `null` without an aircraft profile (no TAS, no fuel burn).
  Navlog? get navlog {
    final a = aircraft;
    if (a == null) return null;
    return Navlog.compute(
      points: navlogPoints,
      trueAirspeed: a.cruiseTas.toDouble(),
      fuelBurnLph: a.fuelBurnLph,
      defaultWindDirection: flight.windDirection,
      defaultWindSpeedKt: flight.windSpeedKt,
    );
  }
}

class FlightRepository {
  FlightRepository(this._db);

  final AppDatabase _db;

  Stream<List<Flight>> watchFlights() => (_db.select(
    _db.flights,
  )..orderBy([(f) => OrderingTerm.desc(f.updatedAt)])).watch();

  Stream<FlightWithRoute?> watchFlight(int id) {
    final query = _db.select(_db.flights).join([
      leftOuterJoin(
        _db.aircraftProfiles,
        _db.aircraftProfiles.id.equalsExp(_db.flights.aircraftId),
      ),
    ])..where(_db.flights.id.equals(id));
    final waypoints = _db.select(_db.flightWaypoints)
      ..where((w) => w.flightId.equals(id))
      ..orderBy([(w) => OrderingTerm.asc(w.sequence)]);

    // Re-emit whenever the flight, its aircraft or its waypoints change.
    return _db
        .tableUpdates(
          TableUpdateQuery.onAllTables([
            _db.flights,
            _db.flightWaypoints,
            _db.aircraftProfiles,
          ]),
        )
        .map<void>((_) {})
        .startWith(null)
        .asyncMap((_) async {
          final row = await query.getSingleOrNull();
          if (row == null) return null;
          final flight = row.readTable(_db.flights);
          final altn = flight.alternateIdent;
          return FlightWithRoute(
            flight,
            await waypoints.get(),
            row.readTableOrNull(_db.aircraftProfiles),
            alternateAirport: altn == null
                ? null
                : await (_db.select(_db.airports)
                        ..where((a) => a.ident.equals(altn))
                        ..limit(1))
                      .getSingleOrNull(),
          );
        });
  }

  Future<FlightWithRoute?> loadFlight(int id) => watchFlight(id).first;

  /// Creates a flight with departure and destination as first and last
  /// waypoint and returns its id.
  Future<int> createFlight({
    required FlightRules rules,
    required Airport departure,
    required Airport destination,
    Airport? alternate,
    int? aircraftId,
    int? cruiseAltitudeFt,
    int? windDirection,
    int? windSpeedKt,
  }) {
    return _db.transaction(() async {
      final id = await _db
          .into(_db.flights)
          .insert(
            FlightsCompanion.insert(
              title: '${departure.ident} – ${destination.ident}',
              rules: rules,
              departureIdent: departure.ident,
              destinationIdent: destination.ident,
              alternateIdent: Value(alternate?.ident),
              aircraftId: Value(aircraftId),
              cruiseAltitudeFt: Value(cruiseAltitudeFt),
              windDirection: Value(windDirection),
              windSpeedKt: Value(windSpeedKt),
            ),
          );
      await _db.batch(
        (b) => b.insertAll(_db.flightWaypoints, [
          _airportWaypoint(id, 0, departure),
          _airportWaypoint(id, 1, destination, altitudeFt: cruiseAltitudeFt),
        ]),
      );
      return id;
    });
  }

  FlightWaypointsCompanion _airportWaypoint(
    int flightId,
    int sequence,
    Airport a, {
    int? altitudeFt,
  }) => FlightWaypointsCompanion.insert(
    flightId: flightId,
    sequence: sequence,
    kind: WaypointKind.airport,
    refId: Value(a.id),
    ident: a.ident,
    name: Value(a.name),
    latitude: a.latitude,
    longitude: a.longitude,
    altitudeFt: Value(altitudeFt),
  );

  /// The flight imported from the OFP with [requestId], if any.
  Future<int?> flightForOfp(String requestId) async {
    if (requestId.isEmpty) return null;
    final rows = await (_db.select(
      _db.flights,
    )..where((f) => f.ofp.isNotNull())).get();
    for (final f in rows) {
      if (OfpSummary.decode(f.ofp)?.requestId == requestId) return f.id;
    }
    return null;
  }

  /// Creates an IFR flight from a SimBrief OFP: route with airways, altitudes,
  /// winds, TAS and fuel flow per leg, runways and the fuel plan. Uses the
  /// aircraft profile of the same type (or registration) or creates one.
  Future<int> importOfp(SimbriefOfp ofp) {
    return _db.transaction(() async {
      final profile = await _profileForOfp(ofp);
      final density = fuelKindOf(profile.fuelType).density;
      double? litres(double? kg) => kg == null ? null : kg / density;
      final fuel = ofp.fuel;
      final trip = fuel.trip;
      final flow = fuel.averageFlowKgph;
      final o = ofp.origin.icao;
      final d = ofp.destination.icao;
      final id = await _db
          .into(_db.flights)
          .insert(
            FlightsCompanion.insert(
              title: ofp.callsign.isEmpty
                  ? '$o – $d'
                  : '${ofp.callsign} · $o – $d',
              rules: FlightRules.ifr,
              departureIdent: o,
              destinationIdent: d,
              alternateIdent: Value(ofp.alternate),
              departureRunway: Value(ofp.origin.runway),
              arrivalRunway: Value(ofp.destination.runway),
              aircraftId: Value(profile.id),
              cruiseAltitudeFt: Value(ofp.cruiseAltitudeFt),
              plannedDeparture: Value(ofp.scheduledOut),
              taxiFuelL: Value(litres(fuel.taxi)),
              contingencyPercent: Value(
                trip != null && trip > 0 && fuel.contingency != null
                    ? (fuel.contingency! / trip * 1000).round() / 10
                    : null,
              ),
              finalReserveMinutes: Value(
                flow != null && flow > 0 && fuel.finalReserve != null
                    ? (fuel.finalReserve! / flow * 60).round()
                    : null,
              ),
              extraFuelL: Value(litres(fuel.extra)),
              fuelOnBoardL: Value(litres(fuel.ramp)),
              ofp: Value(OfpSummary.of(ofp).encode()),
            ),
          );

      final waypoints = <FlightWaypointsCompanion>[
        await _ofpAirport(id, 0, ofp.origin),
      ];
      for (final f in ofp.fixes) {
        if (waypoints.length == 1 && f.isAirport && f.ident == o) continue;
        final seq = waypoints.length;
        final leg = (
          altitudeFt: Value(f.altitudeFt),
          windDirection: Value(f.windDirection),
          windSpeedKt: Value(f.windSpeedKt),
          via: Value(f.via.isEmpty ? null : f.via),
          tasKt: Value(f.trueAirspeedKt),
          fuelFlowLph: Value(litres(f.fuelFlowKgph)),
        );
        final FlightWaypointsCompanion base;
        if (f.isAirport && f.ident == d) {
          base = await _ofpAirport(id, seq, ofp.destination);
        } else {
          final navaid = f.isNavaid ? await _navaidNear(f) : null;
          base = FlightWaypointsCompanion.insert(
            flightId: id,
            sequence: seq,
            kind: navaid != null ? WaypointKind.navaid : WaypointKind.fix,
            refId: Value(navaid?.id),
            ident: f.ident,
            name: Value(navaid?.name ?? f.name),
            latitude: f.latitude,
            longitude: f.longitude,
          );
        }
        waypoints.add(
          base.copyWith(
            altitudeFt: leg.altitudeFt,
            windDirection: leg.windDirection,
            windSpeedKt: leg.windSpeedKt,
            via: leg.via,
            tasKt: leg.tasKt,
            fuelFlowLph: leg.fuelFlowLph,
          ),
        );
      }
      if (waypoints.last.ident.value != d) {
        waypoints.add(await _ofpAirport(id, waypoints.length, ofp.destination));
      }
      await _db.batch((b) => b.insertAll(_db.flightWaypoints, waypoints));
      return id;
    });
  }

  Future<FlightWaypointsCompanion> _ofpAirport(
    int flightId,
    int sequence,
    OfpAirport a,
  ) async {
    final row =
        await (_db.select(_db.airports)
              ..where((x) => x.ident.equals(a.icao))
              ..limit(1))
            .getSingleOrNull();
    if (row != null) return _airportWaypoint(flightId, sequence, row);
    // Without navdata the OFP's own position is good enough.
    return FlightWaypointsCompanion.insert(
      flightId: flightId,
      sequence: sequence,
      kind: WaypointKind.airport,
      ident: a.icao,
      name: Value(a.name),
      latitude: a.latitude,
      longitude: a.longitude,
    );
  }

  /// The navaid with the fix's ident within 5 NM (idents repeat worldwide).
  Future<Navaid?> _navaidNear(OfpFix f) async {
    final candidates = await (_db.select(
      _db.navaids,
    )..where((n) => n.ident.equals(f.ident))).get();
    Navaid? best;
    var bestDist = 5.0;
    for (final n in candidates) {
      final dist = distanceNm(f.latitude, f.longitude, n.latitude, n.longitude);
      if (dist <= bestDist) {
        best = n;
        bestDist = dist;
      }
    }
    return best;
  }

  Future<AircraftProfile> _profileForOfp(SimbriefOfp ofp) async {
    final sameType = await (_db.select(
      _db.aircraftProfiles,
    )..where((a) => a.icaoType.upper().equals(ofp.aircraftIcao))).get();
    final reg = ofp.registration.toUpperCase();
    for (final a in sameType) {
      if (reg.isNotEmpty && a.registration.toUpperCase() == reg) return a;
    }
    if (sameType.isNotEmpty) return sameType.first;

    // SimBrief mostly plans turbine aircraft; the user can change it.
    const density = 0.8;
    double? litres(double? kg) => kg == null ? null : kg / density;
    final fuel = ofp.fuel;
    final id = await _db
        .into(_db.aircraftProfiles)
        .insert(
          AircraftProfilesCompanion.insert(
            name: ofp.aircraftName.isEmpty
                ? ofp.aircraftIcao
                : ofp.aircraftName,
            icaoType: ofp.aircraftIcao,
            registration: Value(ofp.registration),
            cruiseTas: ofp.cruiseTasKt ?? 450,
            fuelBurnLph: litres(fuel.averageFlowKgph) ?? 0,
            usableFuelL: litres(fuel.maxTanks) ?? litres(fuel.ramp) ?? 0,
            fuelType: const Value('jeta'),
            emptyWeightKg: Value(ofp.emptyWeightKg),
            maxTakeoffWeightKg: Value(ofp.maxTakeoffWeightKg),
            taxiFuelL: Value(litres(fuel.taxi)),
          ),
        );
    return (_db.select(
      _db.aircraftProfiles,
    )..where((a) => a.id.equals(id))).getSingle();
  }

  Future<void> updateFlight(int id, FlightsCompanion changes) =>
      (_db.update(_db.flights)..where((f) => f.id.equals(id))).write(
        changes.copyWith(updatedAt: Value(DateTime.now())),
      );

  Future<void> deleteFlight(int id) =>
      (_db.delete(_db.flights)..where((f) => f.id.equals(id))).go();

  /// Inserts a waypoint before position [index] (defaults to before the
  /// destination) and renumbers the route.
  Future<void> insertWaypoint(
    int flightId,
    FlightWaypointsCompanion waypoint, {
    int? index,
  }) {
    return _db.transaction(() async {
      final route = await _route(flightId);
      final at = (index ?? route.length - 1).clamp(0, route.length);
      // The leg to the new point inherits the altitude of the leg it splits.
      final inherited = at < route.length ? route[at].altitudeFt : null;
      final id = await _db
          .into(_db.flightWaypoints)
          .insert(
            waypoint.copyWith(
              flightId: Value(flightId),
              sequence: Value(at),
              altitudeFt: waypoint.altitudeFt.present
                  ? waypoint.altitudeFt
                  : Value(inherited),
            ),
          );
      final ids = [for (final w in route) w.id]..insert(at, id);
      await _renumber(ids);
      await _touch(flightId);
    });
  }

  Future<void> moveWaypoint(int flightId, int from, int to) {
    return _db.transaction(() async {
      final ids = [for (final w in await _route(flightId)) w.id];
      final id = ids.removeAt(from);
      ids.insert(to.clamp(0, ids.length), id);
      await _renumber(ids);
      await _touch(flightId);
    });
  }

  Future<void> deleteWaypoint(int flightId, int waypointId) {
    return _db.transaction(() async {
      await (_db.delete(
        _db.flightWaypoints,
      )..where((w) => w.id.equals(waypointId))).go();
      await _renumber([for (final w in await _route(flightId)) w.id]);
      await _touch(flightId);
    });
  }

  Future<void> updateWaypoint(
    int flightId,
    int waypointId,
    FlightWaypointsCompanion changes,
  ) async {
    await (_db.update(
      _db.flightWaypoints,
    )..where((w) => w.id.equals(waypointId))).write(changes);
    await _touch(flightId);
  }

  /// Clears all actual times so the flight can be flown again.
  Future<void> resetFlightTimes(int flightId) {
    return _db.transaction(() async {
      await (_db.update(_db.flightWaypoints)
            ..where((w) => w.flightId.equals(flightId)))
          .write(const FlightWaypointsCompanion(actualTimeOver: Value(null)));
      await updateFlight(
        flightId,
        const FlightsCompanion(
          blockOffAt: Value(null),
          takeoffAt: Value(null),
          landingAt: Value(null),
          blockOnAt: Value(null),
          touchdownFpm: Value(null),
          touchdownG: Value(null),
          track: Value('[]'),
        ),
      );
    });
  }

  Future<List<FlightWaypoint>> _route(int flightId) =>
      (_db.select(_db.flightWaypoints)
            ..where((w) => w.flightId.equals(flightId))
            ..orderBy([(w) => OrderingTerm.asc(w.sequence)]))
          .get();

  Future<void> _renumber(List<int> ids) async {
    for (var i = 0; i < ids.length; i++) {
      await (_db.update(_db.flightWaypoints)..where((w) => w.id.equals(ids[i])))
          .write(FlightWaypointsCompanion(sequence: Value(i)));
    }
  }

  Future<void> _touch(int flightId) =>
      (_db.update(_db.flights)..where((f) => f.id.equals(flightId))).write(
        FlightsCompanion(updatedAt: Value(DateTime.now())),
      );
}

extension<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
