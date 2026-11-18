import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../data/db/database.dart';
import '../../data/repositories/flight_repository.dart';
import '../../data/repositories/navdata_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/airport_picker.dart';
import '../settings/preference_controls.dart';

/// Returns the id of the created flight.
Future<int?> showNewFlightDialog(BuildContext context) => showDialog<int>(
  context: context,
  builder: (context) => const _NewFlightDialog(),
);

class _NewFlightDialog extends StatefulWidget {
  const _NewFlightDialog();

  @override
  State<_NewFlightDialog> createState() => _NewFlightDialogState();
}

class _NewFlightDialogState extends State<_NewFlightDialog> {
  FlightRules _rules = FlightRules.vfr;
  Airport? _departure;
  Airport? _destination;
  Airport? _alternate;
  late int? _aircraftId = context.read<SettingsController>().defaultAircraftId;
  final _altitude = TextEditingController(text: '3500');
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final home = context.read<SettingsController>().homeAirportIdent;
    if (home != null) {
      context.read<NavdataRepository>().airportByIdent(home).then((a) {
        if (mounted && _departure == null) setState(() => _departure = a);
      });
    }
  }

  @override
  void dispose() {
    _altitude.dispose();
    super.dispose();
  }

  void _setRules(FlightRules rules) {
    setState(() {
      // Swap the typical default altitude if the user didn't change it.
      if (_altitude.text == '3500' && rules == FlightRules.ifr) {
        _altitude.text = '10000';
      } else if (_altitude.text == '10000' && rules == FlightRules.vfr) {
        _altitude.text = '3500';
      }
      _rules = rules;
    });
  }

  Future<void> _create() async {
    setState(() => _submitted = true);
    if (_departure == null || _destination == null) return;
    final id = await context.read<FlightRepository>().createFlight(
      rules: _rules,
      departure: _departure!,
      destination: _destination!,
      alternate: _alternate,
      aircraftId: _aircraftId,
      cruiseAltitudeFt: int.tryParse(_altitude.text),
    );
    if (mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.flightNew),
      scrollable: true,
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<FlightRules>(
              segments: const [
                ButtonSegment(value: FlightRules.vfr, label: Text('VFR')),
                ButtonSegment(value: FlightRules.ifr, label: Text('IFR')),
              ],
              selected: {_rules},
              onSelectionChanged: (s) => _setRules(s.single),
            ),
            const SizedBox(height: 16),
            AirportField(
              label: l10n.flightDeparture,
              ident: _departure?.ident,
              name: _departure?.name,
              errorText: _submitted && _departure == null
                  ? l10n.fieldRequired
                  : null,
              onChanged: (a) => setState(() => _departure = a),
            ),
            const SizedBox(height: 16),
            AirportField(
              label: l10n.flightDestination,
              ident: _destination?.ident,
              name: _destination?.name,
              errorText: _submitted && _destination == null
                  ? l10n.fieldRequired
                  : null,
              onChanged: (a) => setState(() => _destination = a),
            ),
            const SizedBox(height: 16),
            AirportField(
              label: l10n.flightAlternate,
              ident: _alternate?.ident,
              name: _alternate?.name,
              optional: true,
              onChanged: (a) => setState(() => _alternate = a),
            ),
            const SizedBox(height: 16),
            AircraftDropdown(
              label: l10n.flightAircraft,
              value: _aircraftId,
              onChanged: (id) => setState(() => _aircraftId = id),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _altitude,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.flightCruiseAltitude,
                suffixText: 'ft',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _create, child: Text(l10n.flightCreate)),
      ],
    );
  }
}
