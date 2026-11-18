import 'package:drift/drift.dart' show Value;
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../core/units.dart';
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
    }
    setState(() => _loading = false);
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
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
            ]),
            _Section(l10n.aircraftSectionWeights),
            _Fields([
              _number(_emptyWeight, l10n.aircraftEmptyWeight, weight),
              _number(_mtow, l10n.aircraftMtow, weight),
            ]),
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
