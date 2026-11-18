import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../data/db/database.dart';
import '../../data/repositories/aircraft_repository.dart';
import '../../data/repositories/navdata_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/airport_picker.dart';

/// Controls shared by the settings screen and the onboarding.

class LabeledControl extends StatelessWidget {
  const LabeledControl({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();
    return LabeledControl(
      label: l10n.settingsLanguage,
      child: SegmentedButton<AppLanguage>(
        segments: [
          ButtonSegment(
            value: AppLanguage.system,
            label: Text(l10n.languageSystem),
          ),
          const ButtonSegment(value: AppLanguage.de, label: Text('Deutsch')),
          const ButtonSegment(value: AppLanguage.en, label: Text('English')),
        ],
        selected: {settings.language},
        onSelectionChanged: (s) => settings.setLanguage(s.single),
      ),
    );
  }
}

class UnitSelectors extends StatelessWidget {
  const UnitSelectors({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledControl(
          label: l10n.settingsFuelUnit,
          child: SegmentedButton<FuelUnit>(
            segments: [
              ButtonSegment(
                value: FuelUnit.liters,
                label: Text(l10n.unitLiters),
              ),
              ButtonSegment(
                value: FuelUnit.usGallons,
                label: Text(l10n.unitUsGallons),
              ),
            ],
            selected: {settings.fuelUnit},
            onSelectionChanged: (s) => settings.setFuelUnit(s.single),
          ),
        ),
        LabeledControl(
          label: l10n.settingsWeightUnit,
          child: SegmentedButton<WeightUnit>(
            segments: [
              ButtonSegment(
                value: WeightUnit.kilograms,
                label: Text(l10n.unitKilograms),
              ),
              ButtonSegment(
                value: WeightUnit.pounds,
                label: Text(l10n.unitPounds),
              ),
            ],
            selected: {settings.weightUnit},
            onSelectionChanged: (s) => settings.setWeightUnit(s.single),
          ),
        ),
      ],
    );
  }
}

class HomeAirportField extends StatelessWidget {
  const HomeAirportField({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();
    final ident = settings.homeAirportIdent;
    return FutureBuilder<Airport?>(
      key: ValueKey(ident),
      future: ident == null
          ? Future.value()
          : context.read<NavdataRepository>().airportByIdent(ident),
      builder: (context, snapshot) => AirportField(
        label: l10n.settingsHomeAirport,
        ident: ident,
        name: snapshot.data?.name,
        optional: true,
        onChanged: (a) => settings.setHomeAirportIdent(a?.ident),
      ),
    );
  }
}

class AircraftDropdown extends StatelessWidget {
  const AircraftDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AircraftProfile>>(
      stream: context.read<AircraftRepository>().watchAll(),
      builder: (context, snapshot) {
        final aircraft = snapshot.data ?? const [];
        final known = aircraft.any((a) => a.id == value);
        return DropdownButtonFormField<int>(
          key: ValueKey('${known ? value : null}-${aircraft.length}'),
          initialValue: known ? value : null,
          isExpanded: true,
          decoration: InputDecoration(labelText: label),
          items: [
            for (final a in aircraft)
              DropdownMenuItem(
                value: a.id,
                child: Text(
                  a.registration.isEmpty
                      ? a.name
                      : '${a.name} · ${a.registration}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: onChanged,
        );
      },
    );
  }
}

class DefaultAircraftField extends StatelessWidget {
  const DefaultAircraftField({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    return AircraftDropdown(
      label: AppLocalizations.of(context).settingsDefaultAircraft,
      value: settings.defaultAircraftId,
      onChanged: settings.setDefaultAircraftId,
    );
  }
}

class SimbriefField extends StatefulWidget {
  const SimbriefField({super.key});

  @override
  State<SimbriefField> createState() => _SimbriefFieldState();
}

class _SimbriefFieldState extends State<SimbriefField> {
  late final SettingsController _settings = context.read<SettingsController>();
  late final _controller = TextEditingController(
    text: _settings.simbriefUsername,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Focus(
      onFocusChange: (f) =>
          f ? null : _settings.setSimbriefUsername(_controller.text),
      child: TextField(
        controller: _controller,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: l10n.settingsSimbriefUser,
          helperText: l10n.settingsSimbriefHint,
          prefixIcon: const Icon(Icons.person_outline),
        ),
        onSubmitted: _settings.setSimbriefUsername,
      ),
    );
  }
}
