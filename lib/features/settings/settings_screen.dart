import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../l10n/app_localizations.dart';
import '../navdata/navdata_card.dart';
import 'preference_controls.dart';
import 'xplane_connection_form.dart';
import '../notes/notes_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navSettings),
        actions: const [NotesButton()],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Section(
                title: l10n.settingsGeneral,
                children: const [
                  LanguageSelector(),
                  HomeAirportField(),
                  SizedBox(height: 16),
                  DefaultAircraftField(),
                ],
              ),
              const _AppearanceSection(),
              _Section(
                title: l10n.settingsUnits,
                children: const [UnitSelectors()],
              ),
              _Section(
                title: l10n.settingsSimulator,
                children: [
                  _Hint(l10n.settingsXplaneHint),
                  const SizedBox(height: 16),
                  const XPlaneConnectionForm(),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.simLive),
                    subtitle: Text(l10n.simLiveHint),
                    value: settings.simLive,
                    onChanged: settings.setSimLive,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.simAutomation),
                    subtitle: Text(l10n.simAutomationHint),
                    value: settings.simAutomation,
                    onChanged: settings.setSimAutomation,
                  ),
                ],
              ),
              _Section(
                title: l10n.settingsAccounts,
                children: const [SimbriefField()],
              ),
              _Section(
                title: l10n.settingsNotes,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.settingsFingerDrawing),
                    subtitle: Text(l10n.settingsFingerDrawingHint),
                    value: settings.fingerDrawing,
                    onChanged: settings.setFingerDrawing,
                  ),
                ],
              ),
              _Section(
                title: l10n.settingsNavdata,
                children: const [NavdataCard()],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/welcome'),
                  icon: const Icon(Icons.restart_alt),
                  label: Text(l10n.settingsRestartOnboarding),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
  );
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<SettingsController>();
    return _Section(
      title: l10n.settingsAppearance,
      children: [
        LabeledControl(
          label: l10n.settingsTheme,
          child: SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.brightness_auto),
                label: Text(l10n.themeSystem),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode),
                label: Text(l10n.themeLight),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode),
                label: Text(l10n.themeDark),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (s) => settings.setThemeMode(s.single),
          ),
        ),
        LabeledControl(
          label: l10n.settingsAccent,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final accent in AccentColor.values)
                _AccentSwatch(
                  accent: accent,
                  selected: accent == settings.accent,
                  onTap: () => settings.setAccent(accent),
                ),
            ],
          ),
        ),
        LabeledControl(
          label: l10n.settingsScreenAwake,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<ScreenAwake>(
                segments: [
                  ButtonSegment(
                    value: ScreenAwake.never,
                    label: Text(l10n.screenAwakeNever),
                  ),
                  ButtonSegment(
                    value: ScreenAwake.flight,
                    label: Text(l10n.screenAwakeFlight),
                  ),
                  ButtonSegment(
                    value: ScreenAwake.always,
                    label: Text(l10n.screenAwakeAlways),
                  ),
                ],
                selected: {settings.screenAwake},
                onSelectionChanged: (s) => settings.setScreenAwake(s.single),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.settingsScreenAwakeHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  final AccentColor accent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = accent.scheme.colors(theme.brightness).primary;
    final checkColor =
        ThemeData.estimateBrightnessForColor(primary) == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Semantics(
      button: true,
      selected: selected,
      label: accent.name,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? theme.colorScheme.outline : Colors.transparent,
              width: 3,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: selected ? Icon(Icons.check, color: checkColor) : null,
        ),
      ),
    );
  }
}
