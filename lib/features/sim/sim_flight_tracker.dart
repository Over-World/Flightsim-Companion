import 'dart:async';
import 'dart:convert';

import '../../core/flight_tracking.dart';
import '../../core/settings.dart';
import '../../data/sim/sim_snapshot.dart';
import '../kneeboard/kneeboard_controller.dart';
import 'sim_controller.dart';

/// Lets the simulator fly the kneeboard: records block and flight times,
/// passes waypoints, measures the touchdown and records the track. Runs
/// only with an open flight and "automatic times" switched on; pressing
/// the buttons by hand still works and the tracker follows along.
class SimFlightTracker {
  SimFlightTracker({
    required SimController sim,
    required KneeboardController kneeboard,
    required this._settings,
    DateTime Function()? clock,
  }) : _kb = kneeboard,
       _clock = clock ?? DateTime.now {
    _subscription = sim.snapshots.listen(_onSnapshot);
  }

  final KneeboardController _kb;
  final SettingsController _settings;
  final DateTime Function() _clock;
  late final StreamSubscription<SimSnapshot> _subscription;

  static const trackInterval = Duration(seconds: 15);
  static const _saveEvery = 4;

  final _detector = FlightEventDetector();
  int? _flightId;
  List<List<num>> _track = [];
  DateTime? _lastTrackPoint;
  int _unsaved = 0;

  // An action is on its way to the database; wait until the kneeboard
  // shows its result before acting again.
  TrackedPhase? _waitingToLeave;
  int? _waitingForLeg;
  DateTime? _waitUntil;
  bool _busy = false;

  TrackedPhase _phase() => switch (_kb.phase) {
    FlightPhase.preflight => TrackedPhase.preflight,
    FlightPhase.taxiOut => TrackedPhase.taxiOut,
    FlightPhase.enroute || FlightPhase.arrived => TrackedPhase.airborne,
    FlightPhase.landed => TrackedPhase.landed,
    FlightPhase.parked => TrackedPhase.parked,
  };

  void _onSnapshot(SimSnapshot s) {
    final flight = _kb.flight;
    if (!_settings.simAutomation || flight == null) return;
    final now = _clock();
    if (flight.id != _flightId) {
      _flightId = flight.id;
      _detector.reset();
      _track = _decodeTrack(flight.track);
      _lastTrackPoint = null;
      _unsaved = 0;
      _waitingToLeave = null;
      _waitingForLeg = null;
    }
    final phase = _phase();
    if (phase == TrackedPhase.preflight &&
        _track.isNotEmpty &&
        flight.track == '[]') {
      // Times were reset on the kneeboard.
      _track = [];
      _detector.reset();
    }
    if (_waitingToLeave != null || _waitingForLeg != null) {
      final timedOut = _waitUntil != null && now.isAfter(_waitUntil!);
      if (_waitingToLeave == phase && !timedOut) return;
      if (_waitingForLeg != null &&
          _kb.currentLeg == _waitingForLeg &&
          !timedOut) {
        return;
      }
      _waitingToLeave = null;
      _waitingForLeg = null;
    }
    if (_busy) return;

    _recordTrack(s, phase, now);

    final event = _detector.update(s, phase, now);
    if (event != null) {
      _run(phase, now, () async {
        switch (event) {
          case FlightEvent.blockOff:
            await _kb.blockOff();
          case FlightEvent.takeoff:
            await _kb.takeoff();
          case FlightEvent.landing:
            final t = _detector.touchdown;
            if (t != null) {
              await _kb.recordTouchdown(t.verticalSpeedFpm, t.gLoad);
            }
            await _saveTrack();
            await _kb.landing();
          case FlightEvent.blockOn:
            await _saveTrack();
            await _kb.blockOn();
        }
      });
      return;
    }

    // Waypoints en route; the destination is reached by landing.
    final leg = _kb.currentLeg;
    final wps = _kb.waypoints;
    if (phase == TrackedPhase.airborne &&
        leg != null &&
        leg + 1 < wps.length - 1 &&
        s.hasPosition) {
      final from = wps[leg];
      final to = wps[leg + 1];
      if (hasPassedWaypoint(
        from: (from.latitude, from.longitude),
        to: (to.latitude, to.longitude),
        lat: s.latitude!,
        lon: s.longitude!,
      )) {
        _waitingForLeg = leg;
        _waitUntil = now.add(const Duration(seconds: 5));
        _busy = true;
        _kb.passWaypoint().whenComplete(() => _busy = false);
      }
    }
  }

  void _run(TrackedPhase phase, DateTime now, Future<void> Function() action) {
    _waitingToLeave = phase;
    _waitUntil = now.add(const Duration(seconds: 5));
    _busy = true;
    action().whenComplete(() => _busy = false);
  }

  void _recordTrack(SimSnapshot s, TrackedPhase phase, DateTime now) {
    if (!s.hasPosition ||
        phase == TrackedPhase.preflight ||
        phase == TrackedPhase.parked) {
      return;
    }
    final last = _lastTrackPoint;
    if (last != null && now.difference(last) < trackInterval) return;
    _lastTrackPoint = now;
    _track.add([
      (s.latitude! * 1e5).round() / 1e5,
      (s.longitude! * 1e5).round() / 1e5,
      (s.altitudeFt ?? 0).round(),
      now.millisecondsSinceEpoch ~/ 1000,
    ]);
    if (++_unsaved >= _saveEvery) _saveTrack();
  }

  Future<void> _saveTrack() async {
    if (_unsaved == 0 || _kb.flight?.id != _flightId) return;
    _unsaved = 0;
    await _kb.saveTrack(jsonEncode(_track));
  }

  static List<List<num>> _decodeTrack(String json) {
    final list = jsonDecode(json);
    return [
      if (list is List)
        for (final p in list)
          if (p is List) [for (final v in p) v as num],
    ];
  }

  void dispose() => _subscription.cancel();
}
