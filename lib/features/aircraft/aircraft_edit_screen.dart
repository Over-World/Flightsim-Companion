import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../core/units.dart';
import '../../core/weight_balance.dart';
import '../../data/db/database.dart';
import '../../data/repositories/aircraft_repository.dart';
import '../../l10n/app_localizations.dart';

class AircraftEditScreen extends StatefulWidget {
  const AircraftEditScreen({super.key, this.aircraftId});

  /// `null` creates a new profile.
  final int? aircraftId;

  @override
  State<AircraftEditScreen> createState() => _AircraftEditScreenState();
}

class _AircraftEditScreenState extends State<AircraftEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _icaoType = TextEditingController();
  final _registration = TextEditingController();
  final _cruiseTas = TextEditingController();
  final _climbTas = TextEditingController();
  final _climbRate = TextEditingController();
  final _descentRate = TextEditingController();
  final _maxCrosswind = TextEditingController();
  final _fuelBurn = TextEditingController();
  final _usableFuel = TextEditingController();
  final _emptyWeight = TextEditingController();
  final _mtow = TextEditingController();
  final _notes = TextEditingController();
  final _taxiFuel = TextEditingController();
  final _emptyArm = TextEditingController();
  String _armUnit = 'in';
  final List<_StationRow> _stations = [];
  final List<_EnvelopeRow> _envelope = [];
  String _fuelType = 'avgas';
  bool _loading = true;

  late final FuelUnit _fuelUnit = context.read<SettingsController>().fuelUnit;
  late final WeightUnit _weightUnit = context
      .read<SettingsController>()
      .weightUnit;

  List<TextEditingController> get _controllers => [
    _name,
    _icaoType,
    _registration,
    _cruiseTas,
    _climbTas,
    _climbRate,
    _descentRate,
    _maxCrosswind,
    _fuelBurn,
    _usableFuel,
    _emptyWeight,
    _mtow,
    _notes,
    _taxiFuel,
    _emptyArm,
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.aircraftId;
    final a = id == null
        ? null
        : await context.read<AircraftRepository>().byId(id);
    if (!mounted) return;
    if (a != null) {
      String fmt(double? v) => v == null ? '' : _trim(v);
      _name.text = a.name;
      _icaoType.text = a.icaoType;
      _registration.text = a.registration;
      _cruiseTas.text = '${a.cruiseTas}';
      _climbTas.text = a.climbTas?.toString() ?? '';
      _climbRate.text = a.climbRateFpm?.toString() ?? '';
      _descentRate.text = a.descentRateFpm?.toString() ?? '';
      _maxCrosswind.text = a.maxCrosswindKt?.toString() ?? '';
      _fuelBurn.text = fmt(_fuelUnit.fromLiters(a.fuelBurnLph));
      _usableFuel.text = fmt(_fuelUnit.fromLiters(a.usableFuelL));
      _emptyWeight.text = fmt(
        a.emptyWeightKg == null ? null : _weightUnit.fromKg(a.emptyWeightKg!),
      );
      _mtow.text = fmt(
        a.maxTakeoffWeightKg == null
            ? null
            : _weightUnit.fromKg(a.maxTakeoffWeightKg!),
      );
      _notes.text = a.notes;
      _fuelType = a.fuelType;
      _taxiFuel.text = fmt(
        a.taxiFuelL == null ? null : _fuelUnit.fromLiters(a.taxiFuelL!),
      );
      _armUnit = a.armUnit;
      _emptyArm.text = a.emptyArm == null ? '' : _plain(a.emptyArm!);
      for (final st in WbStation.decodeAll(a.stations)) {
        _stations.add(
          _StationRow(
            name: st.name,
            arm: _plain(st.arm),
            max: st.maxKg == null
                ? ''
                : _weightUnit.fromKg(st.maxKg!).round().toString(),
            kind: st.kind,
          ),
        );
      }
      for (final p in EnvelopePoint.decodeAll(a.envelope)) {
        _envelope.add(
          _EnvelopeRow(
            arm: _plain(p.arm),
            weight: _weightUnit.fromKg(p.weightKg).round().toString(),
          ),
        );
      }
    }
    setState(() => _loading = false);
  }

  /// Arms keep their POH precision.
  static String _plain(double v) {
    final s = v.toStringAsFixed(3);
    return s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final r in _stations) {
      r.dispose();
    }
    for (final r in _envelope) {
      r.dispose();
    }
    super.dispose();
  }

  int? _int(TextEditingController c) => int.tryParse(c.text.trim());
  double? _double(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.'));

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final emptyWeight = _double(_emptyWeight);
    final mtow = _double(_mtow);
    final taxi = _double(_taxiFuel);
    final stations = [
      for (final r in _stations)
        if (_double(r.arm) case final arm?)
          WbStation(
            name: r.name.text.trim(),
            arm: arm,
            kind: r.kind,
            maxKg: switch (_double(r.max)) {
              final m? => _weightUnit.toKg(m),
              _ => null,
            },
          ),
    ];
    final envelope = [
      for (final r in _envelope)
        if ((_double(r.arm), _double(r.weight)) case (final arm?, final w?))
          EnvelopePoint(arm, _weightUnit.toKg(w)),
    ];
    final profile = AircraftProfilesCompanion(
      id: widget.aircraftId == null
          ? const Value.absent()
          : Value(widget.aircraftId!),
      name: Value(_name.text.trim()),
      icaoType: Value(_icaoType.text.trim().toUpperCase()),
      registration: Value(_registration.text.trim().toUpperCase()),
      cruiseTas: Value(_int(_cruiseTas)!),
      climbTas: Value(_int(_climbTas)),
      climbRateFpm: Value(_int(_climbRate)),
      descentRateFpm: Value(_int(_descentRate)),
      maxCrosswindKt: Value(_int(_maxCrosswind)),
      fuelBurnLph: Value(_fuelUnit.toLiters(_double(_fuelBurn)!)),
      usableFuelL: Value(_fuelUnit.toLiters(_double(_usableFuel)!)),
      fuelType: Value(_fuelType),
      emptyWeightKg: Value(
        emptyWeight == null ? null : _weightUnit.toKg(emptyWeight),
      ),
      maxTakeoffWeightKg: Value(mtow == null ? null : _weightUnit.toKg(mtow)),
      notes: Value(_notes.text.trim()),
      taxiFuelL: Value(taxi == null ? null : _fuelUnit.toLiters(taxi)),
      armUnit: Value(_armUnit),
      emptyArm: Value(_double(_emptyArm)),
      stations: Value(WbStation.encodeAll(stations)),
      envelope: Value(EnvelopePoint.encodeAll(envelope)),
    );
    await context.read<AircraftRepository>().save(profile);
    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.aircraftDeleteTitle),
        content: Text(l10n.aircraftDeleteMessage(_name.text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await context.read<AircraftRepository>().delete(widget.aircraftId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isNew = widget.aircraftId == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? l10n.aircraftAdd : l10n.aircraftEdit),
        actions: [
          if (!isNew)
            IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          const SizedBox(width: 8),
          FilledButton(onPressed: _save, child: Text(l10n.save)),
          const SizedBox(width: 16),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(key: _formKey, child: _buildForm(l10n)),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null;
    String? requiredNumber(String? v) {
      if (required(v) case final error?) return error;
      final n = double.tryParse(v!.trim().replaceAll(',', '.'));
      return (n == null || n <= 0) ? l10n.fieldInvalidNumber : null;
    }

    final fuel = _fuelUnit.symbol;
    final weight = _weightUnit.symbol;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Section(l10n.aircraftSectionGeneral),
            _Fields([
              _text(_name, l10n.aircraftName, validator: required),
              _text(
                _icaoType,
                l10n.aircraftIcaoType,
                validator: required,
                caps: true,
              ),
              _text(_registration, l10n.aircraftRegistration, caps: true),
            ]),
            _Section(l10n.aircraftSectionPerformance),
            _Fields([
              _number(
                _cruiseTas,
                l10n.aircraftCruiseTas,
                'kt',
                validator: requiredNumber,
                decimal: false,
              ),
              _number(_climbTas, l10n.aircraftClimbTas, 'kt', decimal: false),
              _number(
                _climbRate,
                l10n.aircraftClimbRate,
                'ft/min',
                decimal: false,
              ),
              _number(
                _descentRate,
                l10n.aircraftDescentRate,
                'ft/min',
                decimal: false,
              ),
              _number(
                _maxCrosswind,
                l10n.aircraftMaxCrosswind,
                'kt',
                decimal: false,
              ),
            ]),
            _Section(l10n.aircraftSectionFuel),
            _Fields([
              _number(
                _fuelBurn,
                l10n.aircraftFuelBurn,
                '$fuel/h',
                validator: requiredNumber,
              ),
              _number(
                _usableFuel,
                l10n.aircraftUsableFuel,
                fuel,
                validator: requiredNumber,
              ),
              DropdownButtonFormField<String>(
                initialValue: _fuelType,
                decoration: InputDecoration(labelText: l10n.aircraftFuelType),
                items: const [
                  DropdownMenuItem(value: 'avgas', child: Text('AVGAS 100LL')),
                  DropdownMenuItem(value: 'mogas', child: Text('MOGAS')),
                  DropdownMenuItem(value: 'jeta', child: Text('Jet A-1')),
                ],
                onChanged: (v) => setState(() => _fuelType = v!),
              ),
              _number(_taxiFuel, l10n.fuelTaxi, fuel),
            ]),
            _Section(l10n.aircraftSectionWeights),
            _Fields([
              _number(_emptyWeight, l10n.aircraftEmptyWeight, weight),
              _number(_mtow, l10n.aircraftMtow, weight),
            ]),
            _Section(l10n.wbTitle),
            _Fields([
              DropdownButtonFormField<String>(
                initialValue: _armUnit,
                decoration: InputDecoration(labelText: l10n.wbArmUnit),
                items: [
                  DropdownMenuItem(value: 'in', child: Text(l10n.wbArmInches)),
                  DropdownMenuItem(value: 'm', child: Text(l10n.wbArmMeters)),
                  DropdownMenuItem(
                    value: 'mm',
                    child: Text(l10n.wbArmMillimeters),
                  ),
                ],
                onChanged: (v) => setState(() => _armUnit = v!),
              ),
              _number(_emptyArm, l10n.wbEmptyArm, _armUnit),
            ]),
            const SizedBox(height: 16),
            Text(
              l10n.wbStations,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            for (final r in _stations)
              _StationEditor(
                key: ObjectKey(r),
                row: r,
                armUnit: _armUnit,
                weightUnit: weight,
                onRemove: () => setState(() {
                  _stations.remove(r);
                  r.dispose();
                }),
                onChanged: () => setState(() {}),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _stations.add(_StationRow())),
                icon: const Icon(Icons.add),
                label: Text(l10n.wbAddStation),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.wbEnvelope,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              l10n.wbEnvelopeHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            for (final r in _envelope)
              Padding(
                key: ObjectKey(r),
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(child: _number(r.arm, l10n.wbArm, _armUnit)),
                    const SizedBox(width: 8),
                    Expanded(child: _number(r.weight, l10n.wbWeight, weight)),
                    IconButton(
                      tooltip: l10n.delete,
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => setState(() {
                        _envelope.remove(r);
                        r.dispose();
                      }),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _envelope.add(_EnvelopeRow())),
                icon: const Icon(Icons.add),
                label: Text(l10n.wbAddEnvelopePoint),
              ),
            ),
            _Section(l10n.aircraftNotes),
            TextFormField(
              controller: _notes,
              minLines: 3,
              maxLines: 8,
              decoration: InputDecoration(hintText: l10n.aircraftNotesHint),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(
    TextEditingController c,
    String label, {
    FormFieldValidator<String>? validator,
    bool caps = false,
  }) => TextFormField(
    controller: c,
    validator: validator,
    textCapitalization: caps
        ? TextCapitalization.characters
        : TextCapitalization.sentences,
    decoration: InputDecoration(labelText: label),
  );

  Widget _number(
    TextEditingController c,
    String label,
    String suffix, {
    FormFieldValidator<String>? validator,
    bool decimal = true,
  }) => TextFormField(
    controller: c,
    validator: validator,
    keyboardType: TextInputType.numberWithOptions(decimal: decimal),
    inputFormatters: [
      FilteringTextInputFormatter.allow(
        RegExp(decimal ? r'[0-9.,]' : r'[0-9]'),
      ),
    ],
    decoration: InputDecoration(labelText: label, suffixText: suffix),
  );
}

class _StationRow {
  _StationRow({
    String name = '',
    String arm = '',
    String max = '',
    this.kind = StationKind.seat,
  }) : name = TextEditingController(text: name),
       arm = TextEditingController(text: arm),
       max = TextEditingController(text: max);

  final TextEditingController name;
  final TextEditingController arm;
  final TextEditingController max;
  StationKind kind;

  void dispose() {
    name.dispose();
    arm.dispose();
    max.dispose();
  }
}

class _EnvelopeRow {
  _EnvelopeRow({String arm = '', String weight = ''})
    : arm = TextEditingController(text: arm),
      weight = TextEditingController(text: weight);

  final TextEditingController arm;
  final TextEditingController weight;

  void dispose() {
    arm.dispose();
    weight.dispose();
  }
}

class _StationEditor extends StatelessWidget {
  const _StationEditor({
    super.key,
    required this.row,
    required this.armUnit,
    required this.weightUnit,
    required this.onRemove,
    required this.onChanged,
  });

  final _StationRow row;
  final String armUnit;
  final String weightUnit;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    InputDecoration deco(String label, [String? suffix]) =>
        InputDecoration(labelText: label, suffixText: suffix, isDense: true);
    final number = TextInputType.numberWithOptions(decimal: true);
    final digits = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: 220,
                    child: TextField(
                      controller: row.name,
                      decoration: deco(l10n.wbStationName),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: TextField(
                      controller: row.arm,
                      keyboardType: number,
                      inputFormatters: digits,
                      decoration: deco(l10n.wbArm, armUnit),
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: TextField(
                      controller: row.max,
                      keyboardType: number,
                      inputFormatters: digits,
                      decoration: deco(l10n.wbMaxLoad, weightUnit),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<StationKind>(
                      initialValue: row.kind,
                      isDense: true,
                      decoration: deco(l10n.wbStationKind),
                      items: [
                        for (final k in StationKind.values)
                          DropdownMenuItem(
                            value: k,
                            child: Text(switch (k) {
                              StationKind.seat => l10n.wbKindSeat,
                              StationKind.baggage => l10n.wbKindBaggage,
                              StationKind.fuel => l10n.wbKindFuel,
                              StationKind.other => l10n.wbKindOther,
                            }),
                          ),
                      ],
                      onChanged: (k) {
                        row.kind = k!;
                        onChanged();
                      },
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 24, 4, 12),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(color: Theme.of(context).colorScheme.primary),
    ),
  );
}

/// Two fields per row on wide screens, one on phones.
class _Fields extends StatelessWidget {
  const _Fields(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 520 ? 2 : 1;
        final width = (constraints.maxWidth - 16 * (columns - 1)) / columns;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final c in children) SizedBox(width: width, child: c),
          ],
        );
      },
    );
  }
}
