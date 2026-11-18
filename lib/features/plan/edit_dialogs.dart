import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/db/database.dart';
import '../../data/repositories/flight_repository.dart';
import '../../data/repositories/navdata_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/airport_picker.dart';
import '../settings/preference_controls.dart';

int? _int(TextEditingController c) => int.tryParse(c.text.trim());

String _text(int? v) => v?.toString() ?? '';

final _digits = [FilteringTextInputFormatter.digitsOnly];

class _WindFields extends StatelessWidget {
  const _WindFields({required this.direction, required this.speed});

  final TextEditingController direction;
  final TextEditingController speed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: direction,
            keyboardType: TextInputType.number,
            inputFormatters: [..._digits, LengthLimitingTextInputFormatter(3)],
            decoration: InputDecoration(
              labelText: l10n.windDirection,
              suffixText: '°T',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: speed,
            keyboardType: TextInputType.number,
            inputFormatters: _digits,
            decoration: InputDecoration(
              labelText: l10n.windSpeed,
              suffixText: 'kt',
            ),
          ),
        ),
      ],
    );
  }
}

/// Altitude, wind and notes of the leg ending at [waypoint].
Future<void> showEditWaypointDialog(
  BuildContext context,
  FlightWaypoint waypoint,
) => showDialog<void>(
  context: context,
  builder: (context) => _EditWaypointDialog(waypoint),
);

class _EditWaypointDialog extends StatefulWidget {
  const _EditWaypointDialog(this.waypoint);

  final FlightWaypoint waypoint;

  @override
  State<_EditWaypointDialog> createState() => _EditWaypointDialogState();
}

class _EditWaypointDialogState extends State<_EditWaypointDialog> {
  late final _altitude = TextEditingController(
    text: _text(widget.waypoint.altitudeFt),
  );
  late final _windDir = TextEditingController(
    text: _text(widget.waypoint.windDirection),
  );
  late final _windSpeed = TextEditingController(
    text: _text(widget.waypoint.windSpeedKt),
  );
  late final _notes = TextEditingController(text: widget.waypoint.notes);

  @override
  void dispose() {
    for (final c in [_altitude, _windDir, _windSpeed, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final dir = _int(_windDir);
    final speed = _int(_windSpeed);
    final hasWind = dir != null && speed != null;
    await context.read<FlightRepository>().updateWaypoint(
      widget.waypoint.flightId,
      widget.waypoint.id,
      FlightWaypointsCompanion(
        altitudeFt: Value(_int(_altitude)),
        windDirection: Value(hasWind ? dir % 360 : null),
        windSpeedKt: Value(hasWind ? speed : null),
        notes: Value(_notes.text.trim()),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.legTo(widget.waypoint.ident)),
      scrollable: true,
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.waypoint.name.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(widget.waypoint.name),
              ),
            TextField(
              controller: _altitude,
              keyboardType: TextInputType.number,
              inputFormatters: _digits,
              decoration: InputDecoration(
                labelText: l10n.legAltitude,
                suffixText: 'ft',
              ),
            ),
            const SizedBox(height: 16),
            _WindFields(direction: _windDir, speed: _windSpeed),
            const SizedBox(height: 4),
            Text(
              l10n.legWindHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(labelText: l10n.legNotes),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}

/// Title, aircraft, altitude, default wind, alternate and departure time.
Future<void> showEditFlightDialog(BuildContext context, Flight flight) =>
    showDialog<void>(
      context: context,
      builder: (context) => _EditFlightDialog(flight),
    );

class _EditFlightDialog extends StatefulWidget {
  const _EditFlightDialog(this.flight);

  final Flight flight;

  @override
  State<_EditFlightDialog> createState() => _EditFlightDialogState();
}

class _EditFlightDialogState extends State<_EditFlightDialog> {
  late final _title = TextEditingController(text: widget.flight.title);
  late final _altitude = TextEditingController(
    text: _text(widget.flight.cruiseAltitudeFt),
  );
  late final _windDir = TextEditingController(
    text: _text(widget.flight.windDirection),
  );
  late final _windSpeed = TextEditingController(
    text: _text(widget.flight.windSpeedKt),
  );
  late int? _aircraftId = widget.flight.aircraftId;
  late String? _alternate = widget.flight.alternateIdent;
  String? _alternateName;
  late DateTime? _departure = widget.flight.plannedDeparture;

  @override
  void initState() {
    super.initState();
    if (_alternate != null) {
      context.read<NavdataRepository>().airportByIdent(_alternate!).then((a) {
        if (mounted) setState(() => _alternateName = a?.name);
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_title, _altitude, _windDir, _windSpeed]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDeparture() async {
    final now = DateTime.now();
    final initial = _departure ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    setState(
      () => _departure = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _save() async {
    final dir = _int(_windDir);
    final speed = _int(_windSpeed);
    final hasWind = dir != null && speed != null;
    await context.read<FlightRepository>().updateFlight(
      widget.flight.id,
      FlightsCompanion(
        title: Value(
          _title.text.trim().isEmpty ? widget.flight.title : _title.text.trim(),
        ),
        aircraftId: Value(_aircraftId),
        cruiseAltitudeFt: Value(_int(_altitude)),
        windDirection: Value(hasWind ? dir % 360 : null),
        windSpeedKt: Value(hasWind ? speed : null),
        alternateIdent: Value(_alternate),
        plannedDeparture: Value(_departure),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.flightEdit),
      scrollable: true,
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(labelText: l10n.flightTitle),
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
              inputFormatters: _digits,
              decoration: InputDecoration(
                labelText: l10n.flightCruiseAltitude,
                suffixText: 'ft',
              ),
            ),
            const SizedBox(height: 16),
            _WindFields(direction: _windDir, speed: _windSpeed),
            const SizedBox(height: 4),
            Text(
              l10n.flightWindHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            AirportField(
              label: l10n.flightAlternate,
              ident: _alternate,
              name: _alternateName,
              optional: true,
              onChanged: (a) => setState(() {
                _alternate = a?.ident;
                _alternateName = a?.name;
              }),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDeparture,
              child: InputDecorator(
                isEmpty: _departure == null,
                decoration: InputDecoration(
                  labelText: l10n.flightPlannedDeparture,
                  suffixIcon: _departure == null
                      ? const Icon(Icons.schedule)
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _departure = null),
                        ),
                ),
                child: _departure == null
                    ? null
                    : Text(
                        '${loc.formatMediumDate(_departure!)}  '
                        '${loc.formatTimeOfDay(TimeOfDay.fromDateTime(_departure!), alwaysUse24HourFormat: true)}',
                      ),
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
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}
