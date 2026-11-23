import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/settings.dart';
import 'kneeboard_controller.dart';

Future<void> _wakelock(bool on) => WakelockPlus.toggle(enable: on);

/// Keeps the display on according to [SettingsController.screenAwake]:
/// never, while a flight is open on the kneeboard and not yet parked, or
/// always.
class ScreenAwakeKeeper {
  ScreenAwakeKeeper({
    required this._settings,
    required this._kneeboard,
    this._setAwake = _wakelock,
  }) {
    _settings.addListener(_update);
    _kneeboard.addListener(_update);
    _update();
  }

  final SettingsController _settings;
  final KneeboardController _kneeboard;
  final Future<void> Function(bool on) _setAwake;
  bool? _awake;

  bool get awake => _awake ?? false;

  void _update() {
    final want = switch (_settings.screenAwake) {
      ScreenAwake.never => false,
      ScreenAwake.always => true,
      ScreenAwake.flight =>
        _kneeboard.isOpen && _kneeboard.phase != FlightPhase.parked,
    };
    if (want == _awake) return;
    _awake = want;
    // Not being able to keep the screen on must never break the app.
    _setAwake(want).catchError((Object _) {});
  }

  void dispose() {
    _settings.removeListener(_update);
    _kneeboard.removeListener(_update);
    if (_awake ?? false) _setAwake(false).catchError((Object _) {});
  }
}
