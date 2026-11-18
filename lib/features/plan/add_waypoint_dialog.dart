import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/nav_math.dart';
import '../../core/navlog.dart';
import '../../core/theme.dart';
import '../../core/units.dart';
import '../../core/wmm/wmm.dart';
import '../../data/db/database.dart';
import '../../data/repositories/navdata_repository.dart';
import '../../l10n/app_localizations.dart';
import '../airports/airport_type.dart';

/// Returns a waypoint (without flight id / sequence) to insert.
Future<FlightWaypointsCompanion?> showAddWaypointDialog(BuildContext context) {
  final fullscreen = MediaQuery.sizeOf(context).width < 600;
  const child = _AddWaypointDialog();
  return showDialog<FlightWaypointsCompanion>(
    context: context,
    builder: (context) => fullscreen
        ? const Dialog.fullscreen(child: child)
        // Tab views need a bounded height, so the dialog gets a fixed size.
        : Dialog(
            child: SizedBox(
              width: 600,
              height: (MediaQuery.sizeOf(context).height * 0.85).clamp(
                360,
                680,
              ),
              child: child,
            ),
          ),
  );
}

FlightWaypointsCompanion _waypoint({
  required WaypointKind kind,
  required String ident,
  required String name,
  required double latitude,
  required double longitude,
  int? refId,
}) => FlightWaypointsCompanion.insert(
  flightId: 0,
  sequence: 0,
  kind: kind,
  refId: Value(refId),
  ident: ident,
  name: Value(name),
  latitude: latitude,
  longitude: longitude,
);

class _AddWaypointDialog extends StatelessWidget {
  const _AddWaypointDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      // Scaffold gives the AppBar with its TabBar a bounded height.
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const CloseButton(),
          title: Text(l10n.waypointAdd),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.waypointTabSearch),
              Tab(text: l10n.waypointTabRadial),
              Tab(text: l10n.waypointTabCoordinates),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_SearchTab(), _RadialTab(), _CoordinatesTab()],
        ),
      ),
    );
  }
}

class _SearchTab extends StatefulWidget {
  const _SearchTab();

  @override
  State<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<_SearchTab> {
  Timer? _debounce;
  List<Navaid> _navaids = const [];
  List<Airport> _airports = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final repo = context.read<NavdataRepository>();
      final navaids = await repo.searchNavaids(q, limit: 15);
      final airports = await repo.searchAirports(q, limit: 15);
      if (!mounted) return;
      setState(() {
        _navaids = navaids;
        _airports = airports;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.waypointSearchHint,
            ),
            onChanged: _search,
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (final n in _navaids)
                ListTile(
                  leading: const Icon(Icons.settings_input_antenna),
                  title: Text('${n.name} · ${n.type}'),
                  subtitle: Text(
                    [
                      n.isoCountry,
                      if (n.frequencyKhz != null)
                        formatNavaidFrequency(n.frequencyKhz!),
                    ].join(' · '),
                  ),
                  trailing: Text(n.ident, style: monoStyle(context)),
                  onTap: () => Navigator.pop(
                    context,
                    _waypoint(
                      kind: WaypointKind.navaid,
                      refId: n.id,
                      ident: n.ident,
                      name: '${n.name} ${n.type}',
                      latitude: n.latitude,
                      longitude: n.longitude,
                    ),
                  ),
                ),
              for (final a in _airports)
                ListTile(
                  leading: Icon(airportTypeIcon(a.type)),
                  title: Text(a.name),
                  subtitle: Text(
                    [a.municipality, a.isoCountry].nonNulls.join(', '),
                  ),
                  trailing: Text(a.ident, style: monoStyle(context)),
                  onTap: () => Navigator.pop(
                    context,
                    _waypoint(
                      kind: WaypointKind.airport,
                      refId: a.id,
                      ident: a.ident,
                      name: a.name,
                      latitude: a.latitude,
                      longitude: a.longitude,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Fix defined by radial and distance from a navaid, e.g. FFM R120 15 NM.
class _RadialTab extends StatefulWidget {
  const _RadialTab();

  @override
  State<_RadialTab> createState() => _RadialTabState();
}

class _RadialTabState extends State<_RadialTab> {
  final _ident = TextEditingController();
  final _radial = TextEditingController();
  final _distance = TextEditingController();
  List<Navaid> _matches = const [];
  Navaid? _navaid;

  @override
  void dispose() {
    _ident.dispose();
    _radial.dispose();
    _distance.dispose();
    super.dispose();
  }

  Future<void> _lookup(String ident) async {
    final matches = await context.read<NavdataRepository>().navaidsByIdent(
      ident,
    );
    if (!mounted) return;
    setState(() {
      _matches = matches;
      _navaid = matches.length == 1 ? matches.single : null;
    });
  }

  FlightWaypointsCompanion? get _result {
    final n = _navaid;
    final radial = int.tryParse(_radial.text);
    final distance = double.tryParse(_distance.text.replaceAll(',', '.'));
    if (n == null || radial == null || distance == null || radial > 360) {
      return null;
    }
    final variation = magneticVariation(n.latitude, n.longitude);
    final p = destinationPoint(
      n.latitude,
      n.longitude,
      normalizeDegrees(radial + variation),
      distance,
    );
    final r = formatCourse(radial.toDouble());
    return _waypoint(
      kind: WaypointKind.user,
      ident: '${n.ident}$r${distance.round().toString().padLeft(3, '0')}',
      name: '${n.ident} R$r ${_distance.text} NM',
      latitude: p.latitude,
      longitude: p.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = _result;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _ident,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(labelText: l10n.waypointNavaidIdent),
          onChanged: _lookup,
        ),
        if (_matches.length > 1)
          RadioGroup<int>(
            groupValue: _navaid?.id,
            onChanged: (id) => setState(
              () => _navaid = _matches.firstWhere((n) => n.id == id),
            ),
            child: Column(
              children: [
                for (final n in _matches)
                  RadioListTile<int>(
                    value: n.id,
                    title: Text('${n.name} · ${n.type}'),
                    subtitle: Text(n.isoCountry),
                  ),
              ],
            ),
          ),
        if (_navaid != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${_navaid!.name} · ${_navaid!.type} · ${_navaid!.isoCountry}',
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _radial,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  labelText: l10n.waypointRadial,
                  suffixText: '°M',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _distance,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l10n.waypointDistance,
                  suffixText: 'NM',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: result == null
                ? null
                : () => Navigator.pop(context, result),
            child: Text(l10n.waypointAdd),
          ),
        ),
      ],
    );
  }
}

class _CoordinatesTab extends StatefulWidget {
  const _CoordinatesTab();

  @override
  State<_CoordinatesTab> createState() => _CoordinatesTabState();
}

class _CoordinatesTabState extends State<_CoordinatesTab> {
  final _name = TextEditingController();
  final _lat = TextEditingController();
  final _lon = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _lat.dispose();
    _lon.dispose();
    super.dispose();
  }

  double? _parse(TextEditingController c, double limit) {
    final v = double.tryParse(c.text.trim().replaceAll(',', '.'));
    return v == null || v.abs() > limit ? null : v;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lat = _parse(_lat, 90);
    final lon = _parse(_lon, 180);
    final name = _name.text.trim();
    final valid = lat != null && lon != null && name.isNotEmpty;
    const decimal = TextInputType.numberWithOptions(
      decimal: true,
      signed: true,
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _name,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: l10n.waypointName,
            hintText: l10n.waypointNameHint,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _lat,
                keyboardType: decimal,
                decoration: InputDecoration(
                  labelText: l10n.waypointLatitude,
                  hintText: '49.9600',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _lon,
                keyboardType: decimal,
                decoration: InputDecoration(
                  labelText: l10n.waypointLongitude,
                  hintText: '8.6458',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.waypointCoordinatesHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: !valid
                ? null
                : () => Navigator.pop(
                    context,
                    _waypoint(
                      kind: WaypointKind.user,
                      ident: name.toUpperCase(),
                      name: name,
                      latitude: lat,
                      longitude: lon,
                    ),
                  ),
            child: Text(l10n.waypointAdd),
          ),
        ),
      ],
    );
  }
}
