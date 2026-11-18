import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../data/sim/xplane_client.dart';
import '../../l10n/app_localizations.dart';

/// Host/port of the X-Plane PC with a connection test. Saves on test and
/// when the fields lose focus.
class XPlaneConnectionForm extends StatefulWidget {
  const XPlaneConnectionForm({super.key});

  @override
  State<XPlaneConnectionForm> createState() => _XPlaneConnectionFormState();
}

enum _TestState { idle, running, success, failure }

class _XPlaneConnectionFormState extends State<XPlaneConnectionForm> {
  late final SettingsController _settings = context.read<SettingsController>();
  late final _host = TextEditingController(text: _settings.simHost);
  late final _port = TextEditingController(text: '${_settings.simPort}');
  _TestState _state = _TestState.idle;
  String _message = '';

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    super.dispose();
  }

  int get _portValue =>
      int.tryParse(_port.text) ?? SettingsController.defaultSimPort;

  Future<void> _save() => _settings.setSimConnection(_host.text, _portValue);

  Future<void> _test() async {
    final l10n = AppLocalizations.of(context);
    FocusScope.of(context).unfocus();
    await _save();
    if (_host.text.trim().isEmpty) return;
    setState(() => _state = _TestState.running);
    try {
      final info = await XPlaneClient(
        host: _host.text.trim(),
        port: _portValue,
      ).capabilities();
      if (!mounted) return;
      setState(() {
        _state = _TestState.success;
        _message = l10n.xplaneConnected(info.version ?? '12');
      });
    } on Exception catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _TestState.failure;
        _message = l10n.xplaneConnectionFailed('$e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Focus(
                onFocusChange: (f) => f ? null : _save(),
                child: TextField(
                  controller: _host,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: l10n.settingsSimHost,
                    hintText: '192.168.1.20',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Focus(
                onFocusChange: (f) => f ? null : _save(),
                child: TextField(
                  controller: _port,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: l10n.settingsSimPort),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: switch (_state) {
                _TestState.idle => const SizedBox.shrink(),
                _TestState.running => Text(l10n.xplaneTesting),
                _TestState.success => Row(
                  children: [
                    Icon(Icons.check_circle, color: scheme.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_message)),
                  ],
                ),
                _TestState.failure => Row(
                  children: [
                    Icon(Icons.error_outline, color: scheme.error),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_message)),
                  ],
                ),
              },
            ),
            const SizedBox(width: 12),
            FilledButton.tonalIcon(
              onPressed: _state == _TestState.running ? null : _test,
              icon: const Icon(Icons.wifi_find),
              label: Text(l10n.xplaneTest),
            ),
          ],
        ),
      ],
    );
  }
}
