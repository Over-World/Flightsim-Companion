import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/flight_tracking.dart';
import '../../core/settings.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/sim/sim_snapshot.dart';
import '../../l10n/app_localizations.dart';
import 'sim_controller.dart';

/// `119.150`, `114.20` or `386` depending on the band.
String formatKhz(int khz) => switch (khz) {
  >= 118000 => (khz / 1000).toStringAsFixed(3),
  >= 108000 => (khz / 1000).toStringAsFixed(2),
  _ => '$khz',
};

String simStatusLabel(AppLocalizations l10n, SimStatus s) => switch (s) {
  SimStatus.off => l10n.simStatusOff,
  SimStatus.connecting => l10n.simStatusConnecting,
  SimStatus.waitingForFlight => l10n.simStatusWaitingForFlight,
  SimStatus.connected => l10n.simStatusConnected,
  SimStatus.unreachable => l10n.simStatusUnreachable,
};

/// App bar button showing the X-Plane connection; opens its details.
class SimStatusButton extends StatelessWidget {
  const SimStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sim = context.watch<SimController>();
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = switch (sim.status) {
      SimStatus.connected => (Icons.link, scheme.primary),
      SimStatus.off => (Icons.link_off, scheme.onSurfaceVariant),
      SimStatus.unreachable => (Icons.link_off, scheme.error),
      _ => (Icons.sync, scheme.onSurfaceVariant),
    };
    return IconButton(
      tooltip: 'X-Plane: ${simStatusLabel(l10n, sim.status)}',
      icon: Icon(icon, color: color),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => const _SimSheet(),
      ),
    );
  }
}

class _SimSheet extends StatelessWidget {
  const _SimSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sim = context.watch<SimController>();
    final settings = context.watch<SettingsController>();
    final theme = Theme.of(context);
    final host = settings.simHost;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('X-Plane', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              [
                simStatusLabel(l10n, sim.status),
                if (host.isNotEmpty) '$host:${settings.simPort}',
                if (sim.version != null) 'X-Plane ${sim.version}',
              ].join(' · '),
            ),
            if (sim.status == SimStatus.unreachable) ...[
              const SizedBox(height: 8),
              Text(l10n.simUnreachableHint, style: theme.textTheme.bodySmall),
            ],
            if (sim.status == SimStatus.off && host.isEmpty) ...[
              const SizedBox(height: 8),
              Text(l10n.simNoHostHint, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.simLive),
              value: settings.simLive,
              onChanged: host.isEmpty ? null : settings.setSimLive,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.simAutomation),
              subtitle: Text(l10n.simAutomationHint),
              value: settings.simAutomation,
              onChanged: settings.setSimAutomation,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                if (sim.status == SimStatus.unreachable ||
                    sim.status == SimStatus.waitingForFlight)
                  FilledButton.tonal(
                    onPressed: sim.reconnect,
                    child: Text(l10n.simRetry),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/settings');
                  },
                  child: Text(l10n.simOpenSettings),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Live COM/NAV/ADF frequencies with a swap button each.
class RadioPanel extends StatelessWidget {
  const RadioPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sim = context.watch<SimController>();
    final radios = sim.snapshot?.radios ?? const {};
    final theme = Theme.of(context);
    final mono = monoStyle(context, base: theme.textTheme.titleMedium);
    Widget frequency(int? khz, {Color? color}) => Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          khz == null ? '–' : formatKhz(khz),
          style: mono.copyWith(color: color),
        ),
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: 24,
        runSpacing: 4,
        children: [
          for (final r in SimRadio.all)
            if (radios[r]?.active != null)
              SizedBox(
                width: constraints.maxWidth.clamp(0, 280).toDouble(),
                child: Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(r.label, style: theme.textTheme.labelLarge),
                    ),
                    frequency(radios[r]!.active),
                    IconButton(
                      tooltip: l10n.simSwap(r.label),
                      onPressed: () => sim.swap(r),
                      icon: const Icon(Icons.swap_horiz),
                    ),
                    frequency(
                      radios[r]!.standby,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class TunableFrequency extends StatelessWidget {
  const TunableFrequency({
    super.key,
    required this.khz,
    required this.text,
    this.style,
  });

  final int khz;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final sim = context.watch<SimController>();
    final radios = SimRadio.forFrequency(khz);
    final label = Text(text, style: style);
    if (!sim.isConnected || radios.isEmpty) return label;
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return PopupMenuButton<(SimRadio, bool)>(
      tooltip: l10n.simTuneTooltip(text),
      onSelected: (choice) {
        final (radio, standby) = choice;
        sim.tune(radio, khz, standby: standby);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              standby
                  ? l10n.simTunedStandby(radio.label, text)
                  : l10n.simTunedActive(radio.label, text),
            ),
          ),
        );
      },
      itemBuilder: (context) => [
        for (final r in radios) ...[
          PopupMenuItem(
            value: (r, true),
            child: Text(l10n.simStandby(r.label)),
          ),
          PopupMenuItem(
            value: (r, false),
            child: Text(l10n.simActive(r.label)),
          ),
        ],
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          text,
          style: (style ?? const TextStyle()).copyWith(
            color: scheme.primary,
            decoration: TextDecoration.underline,
            decorationColor: scheme.primary.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

/// Live values for the leg being flown: ground speed, distance and time
/// to go, and the offset from the planned course.
class LiveLegValues extends StatelessWidget {
  const LiveLegValues({super.key, required this.from, required this.to});

  final FlightWaypoint from;
  final FlightWaypoint to;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final s = context.watch<SimController>().snapshot;
    if (s == null || !s.hasPosition) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final p = legProgress(
      from: (from.latitude, from.longitude),
      to: (to.latitude, to.longitude),
      lat: s.latitude!,
      lon: s.longitude!,
    );
    final ttg = p.timeToGo(s.groundSpeedKt);
    final xt = p.crossTrackNm;
    final side = xt.abs() < 0.05
        ? ''
        : xt > 0
        ? ' ${l10n.simRight}'
        : ' ${l10n.simLeft}';
    final style = monoStyle(context, base: theme.textTheme.titleLarge);
    Widget value(String label, String v, {Color? color}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        Text(v, style: style.copyWith(color: color)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sensors, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                l10n.simLive,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 32,
            runSpacing: 12,
            children: [
              value('GS', '${(s.groundSpeedKt ?? 0).round()}'),
              value('DTG', p.distanceToGoNm.toStringAsFixed(1)),
              value(
                'ETA',
                ttg == null
                    ? '–'
                    : DateFormat.Hm().format(DateTime.now().add(ttg)),
              ),
              value(
                'XTK',
                '${xt.abs().toStringAsFixed(1)}$side',
                color: xt.abs() > 2 ? theme.colorScheme.error : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
