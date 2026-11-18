import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../l10n/app_localizations.dart';
import '../navdata/navdata_card.dart';
import '../navdata/navdata_controller.dart';
import '../settings/preference_controls.dart';
import '../settings/xplane_connection_form.dart';

/// First-start setup. Every step except the welcome can be skipped and
/// changed later in the settings.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _stepCount = 5;
  int _step = 0;

  Future<void> _finish() async {
    await context.read<SettingsController>().setOnboardingCompleted(true);
    if (mounted) context.go('/plan');
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (_step == _stepCount - 1) {
      _finish();
    } else {
      setState(() => _step++);
    }
  }

  void _back() => setState(() => _step--);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLast = _step == _stepCount - 1;
    final step = switch (_step) {
      0 => const _WelcomeStep(),
      1 => const _NavdataStep(),
      2 => const _SimulatorStep(),
      3 => const _AccountsStep(),
      _ => const _HomeStep(),
    };

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / _stepCount),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: KeyedSubtree(key: ValueKey(_step), child: step),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  if (_step > 0)
                    TextButton(onPressed: _back, child: Text(l10n.back)),
                  const Spacer(),
                  Text(
                    l10n.onboardingStep(_step + 1, _stepCount),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _next,
                    child: Text(isLast ? l10n.onboardingFinish : l10n.next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.flight,
          title: l10n.onboardingWelcomeTitle,
          text: l10n.onboardingWelcomeText,
        ),
        const LanguageSelector(),
        const UnitSelectors(),
      ],
    );
  }
}

class _NavdataStep extends StatelessWidget {
  const _NavdataStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.cloud_download_outlined,
          title: l10n.onboardingNavdataTitle,
          text: l10n.onboardingNavdataText,
        ),
        const NavdataCard(),
      ],
    );
  }
}

class _SimulatorStep extends StatelessWidget {
  const _SimulatorStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.computer,
          title: l10n.onboardingSimTitle,
          text: l10n.onboardingSimText,
        ),
        const XPlaneConnectionForm(),
      ],
    );
  }
}

class _AccountsStep extends StatelessWidget {
  const _AccountsStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.account_circle_outlined,
          title: l10n.onboardingAccountsTitle,
          text: l10n.onboardingAccountsText,
        ),
        const SimbriefField(),
      ],
    );
  }
}

class _HomeStep extends StatelessWidget {
  const _HomeStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasNavdata = context.watch<NavdataController>().hasData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.home_outlined,
          title: l10n.onboardingHomeTitle,
          text: l10n.onboardingHomeText,
        ),
        if (hasNavdata)
          const HomeAirportField()
        else
          Text(l10n.onboardingHomeNeedsNavdata),
        const SizedBox(height: 16),
        const DefaultAircraftField(),
      ],
    );
  }
}
