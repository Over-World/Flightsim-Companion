import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/navlog.dart';
import '../../data/db/database.dart';
import '../../data/repositories/flight_repository.dart';
import '../../data/repositories/navdata_repository.dart';

enum FlightPhase { preflight, taxiOut, enroute, arrived, landed, parked }

class FrequencyEntry {
  const FrequencyEntry({
    required this.label,
    required this.frequency,
    this.morse,
  });

  final String label;
  final String frequency;

  /// Ident to show as morse code (navaids).
  final String? morse;
}

class FrequencyGroup {
  const FrequencyGroup({
    required this.ident,
    required this.role,
    required this.entries,
  });

  final String ident;

  /// dep, dest, altn or navaid.
  final String role;
  final List<FrequencyEntry> entries;
}

/// State of the flight on the kneeboard. Lives above the router so timers
/// and the current leg survive tab switches, rotation and app restarts.
class KneeboardController extends ChangeNotifier {
  KneeboardController({
    required this._prefs,
    required this._flights,
    required this._navdata,
  }) {
    final id = _prefs.getInt(_prefsKey);
    if (id != null) _subscribe(id);
  }

  static const _prefsKey = 'activeFlightId';

  final SharedPreferences _prefs;
  final FlightRepository _flights;
  final NavdataRepository _navdata;
  StreamSubscription<FlightWithRoute?>? _subscription;

  int? flightId;
  FlightWithRoute? data;
  Navlog? navlog;
  List<FrequencyGroup> frequencies = const [];
  String? _frequencyKey;

  // General-purpose stopwatch, independent of the flight.
  DateTime? _stopwatchStartedAt;
  Duration _stopwatchAccumulated = Duration.zero;

  bool get isOpen => flightId != null;
  Flight? get flight => data?.flight;
  List<FlightWaypoint> get waypoints => data?.waypoints ?? const [];

  Future<void> open(int id) async {
    await _prefs.setInt(_prefsKey, id);
    final f = (await _flights.loadFlight(id))?.flight;
    if (f != null && f.status == FlightStatus.planned) {
      await _flights.updateFlight(
        id,
        const FlightsCompanion(status: Value(FlightStatus.active)),
      );
    }
    _subscribe(id);
  }

  Future<void> close() async {
    final f = flight;
    await _prefs.remove(_prefsKey);
    await _subscription?.cancel();
    _subscription = null;
    flightId = null;
    data = null;
    navlog = null;
    frequencies = const [];
    _frequencyKey = null;
    notifyListeners();
    if (f != null && f.status == FlightStatus.active) {
      await _flights.updateFlight(
        f.id,
        const FlightsCompanion(status: Value(FlightStatus.planned)),
      );
    }
  }

  void _subscribe(int id) {
    _subscription?.cancel();
    flightId = id;
    _subscription = _flights.watchFlight(id).listen((d) {
      if (d == null) {
        close();
        return;
      }
      data = d;
      navlog = d.navlog;
      notifyListeners();
      _loadFrequencies(d);
    });
  }

  Future<void> _loadFrequencies(FlightWithRoute d) async {
    final f = d.flight;
    final navaidIds = [
      for (final w in d.waypoints)
        if (w.kind == WaypointKind.navaid && w.refId != null) w.refId!,
    ];
    final key = [
      f.departureIdent,
      f.destinationIdent,
      f.alternateIdent,
      ...navaidIds,
    ].join(',');
    if (key == _frequencyKey) return;
    _frequencyKey = key;

    Future<FrequencyGroup?> airport(String? ident, String role) async {
      if (ident == null) return null;
      final a = await _navdata.airportByIdent(ident);
      if (a == null) return null;
      final list = await _navdata.frequencies(a.id);
      return FrequencyGroup(
        ident: ident,
        role: role,
        entries: [
          for (final fr in list)
            FrequencyEntry(
              label: fr.type,
              frequency: fr.frequencyMhz.toStringAsFixed(3),
            ),
        ],
      );
    }

    final groups = <FrequencyGroup?>[
      await airport(f.departureIdent, 'dep'),
      for (final id in navaidIds)
        switch (await _navdata.navaidById(id)) {
          final n? when n.frequencyKhz != null => FrequencyGroup(
            ident: n.ident,
            role: 'navaid',
            entries: [
              FrequencyEntry(
                label: n.type,
                frequency: n.frequencyKhz! >= 108000
                    ? (n.frequencyKhz! / 1000).toStringAsFixed(2)
                    : '${n.frequencyKhz}',
                morse: n.ident,
              ),
            ],
          ),
          _ => null,
        },
      if (f.destinationIdent != f.departureIdent)
        await airport(f.destinationIdent, 'dest'),
      await airport(f.alternateIdent, 'altn'),
    ];
    if (key != _frequencyKey) return;
    frequencies = groups.nonNulls.toList();
    notifyListeners();
  }

  // -------------------------------------------------------------------------
  // Flight progress
  // -------------------------------------------------------------------------

  FlightPhase get phase {
    final f = flight;
    if (f == null || f.blockOffAt == null && f.takeoffAt == null) {
      return FlightPhase.preflight;
    }
    if (f.blockOnAt != null) return FlightPhase.parked;
    if (f.landingAt != null) return FlightPhase.landed;
    if (f.takeoffAt == null) return FlightPhase.taxiOut;
    return currentLeg == null ? FlightPhase.arrived : FlightPhase.enroute;
  }

  /// Index of the leg being flown (leg i ends at waypoint i + 1).
  int? get currentLeg {
    if (flight?.takeoffAt == null) return null;
    for (var i = 1; i < waypoints.length; i++) {
      if (waypoints[i].actualTimeOver == null) return i - 1;
    }
    return null;
  }

  NavlogLeg? get currentNavlogLeg {
    final i = currentLeg;
    final legs = navlog?.legs;
    return i == null || legs == null || i >= legs.length ? null : legs[i];
  }

  /// When the current leg started (time over its start point).
  DateTime? get legStartedAt {
    final i = currentLeg;
    return i == null ? null : waypoints[i].actualTimeOver;
  }

  /// Estimated time over each leg end, from the last known time over
  /// onwards. Before takeoff the planned departure is used.
  List<DateTime?> get etas {
    final legs = navlog?.legs ?? const <NavlogLeg>[];
    final result = <DateTime?>[];
    DateTime? base =
        waypoints.firstOrNull?.actualTimeOver ?? flight?.plannedDeparture;
    for (var i = 0; i < legs.length; i++) {
      final ato = waypoints[i + 1].actualTimeOver;
      final ete = legs[i].ete;
      final eta = ato ?? (base == null || ete == null ? null : base.add(ete));
      result.add(eta);
      base = ato ?? eta;
    }
    return result;
  }

  Future<void> _setFlight(FlightsCompanion changes) =>
      _flights.updateFlight(flightId!, changes);

  Future<void> _setAto(int index, DateTime? time) => _flights.updateWaypoint(
    flightId!,
    waypoints[index].id,
    FlightWaypointsCompanion(actualTimeOver: Value(time)),
  );

  Future<void> blockOff() =>
      _setFlight(FlightsCompanion(blockOffAt: Value(DateTime.now())));

  Future<void> takeoff() async {
    final now = DateTime.now();
    await _setFlight(
      FlightsCompanion(
        takeoffAt: Value(now),
        blockOffAt: Value(flight?.blockOffAt ?? now),
      ),
    );
    await _setAto(0, now);
  }

  /// Marks the end point of the current leg as passed.
  Future<void> passWaypoint() async {
    final i = currentLeg;
    if (i != null) await _setAto(i + 1, DateTime.now());
  }

  Future<void> landing() async {
    final now = DateTime.now();
    // Overhead the destination counts as reached when landing.
    if (waypoints.isNotEmpty && waypoints.last.actualTimeOver == null) {
      await _setAto(waypoints.length - 1, now);
    }
    await _setFlight(FlightsCompanion(landingAt: Value(now)));
  }

  Future<void> blockOn() => _setFlight(
    FlightsCompanion(
      blockOnAt: Value(DateTime.now()),
      status: const Value(FlightStatus.completed),
    ),
  );

  /// Reverts the most recent recorded time.
  Future<void> undo() async {
    final f = flight;
    if (f == null) return;
    if (f.blockOnAt != null) {
      return _setFlight(
        const FlightsCompanion(
          blockOnAt: Value(null),
          status: Value(FlightStatus.active),
        ),
      );
    }
    if (f.landingAt != null) {
      return _setFlight(const FlightsCompanion(landingAt: Value(null)));
    }
    for (var i = waypoints.length - 1; i >= 1; i--) {
      if (waypoints[i].actualTimeOver != null) return _setAto(i, null);
    }
    if (f.takeoffAt != null) {
      await _setAto(0, null);
      return _setFlight(const FlightsCompanion(takeoffAt: Value(null)));
    }
    if (f.blockOffAt != null) {
      return _setFlight(const FlightsCompanion(blockOffAt: Value(null)));
    }
  }

  Future<void> resetTimes() => _flights.resetFlightTimes(flightId!);

  // -------------------------------------------------------------------------
  // Stopwatch
  // -------------------------------------------------------------------------

  bool get stopwatchRunning => _stopwatchStartedAt != null;

  Duration stopwatchElapsed([DateTime? now]) =>
      _stopwatchAccumulated +
      (_stopwatchStartedAt == null
          ? Duration.zero
          : (now ?? DateTime.now()).difference(_stopwatchStartedAt!));

  void toggleStopwatch() {
    if (_stopwatchStartedAt == null) {
      _stopwatchStartedAt = DateTime.now();
    } else {
      _stopwatchAccumulated = stopwatchElapsed();
      _stopwatchStartedAt = null;
    }
    notifyListeners();
  }

  void resetStopwatch() {
    _stopwatchStartedAt = stopwatchRunning ? DateTime.now() : null;
    _stopwatchAccumulated = Duration.zero;
    notifyListeners();
  }

  bool _disposed = false;

  /// Loads finish asynchronously and may outlive the controller.
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}
