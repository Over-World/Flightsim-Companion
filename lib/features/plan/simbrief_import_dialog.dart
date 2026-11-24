import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/navlog.dart';
import '../../core/settings.dart';
import '../../core/units.dart';
import '../../data/repositories/flight_repository.dart';
import '../../data/simbrief/simbrief_client.dart';
import '../../data/simbrief/simbrief_ofp.dart';
import '../../l10n/app_localizations.dart';

/// Fetches the latest SimBrief OFP, shows it and imports it as a new flight,
/// then opens that flight.
Future<void> importFromSimbrief(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final user = context.read<SettingsController>().simbriefUsername;
  if (user.isEmpty) {
    final toSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.cloud_download_outlined),
        title: Text(l10n.simbriefImport),
        content: Text(l10n.simbriefNoUser),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.navSettings),
          ),
        ],
      ),
    );
    if ((toSettings ?? false) && context.mounted) context.go('/settings');
    return;
  }
  final id = await showDialog<int>(
    context: context,
    builder: (context) => SimbriefImportDialog(user: user),
  );
  if (id != null && context.mounted) context.go('/plan/flights/$id');
}

class SimbriefImportDialog extends StatefulWidget {
  const SimbriefImportDialog({super.key, required this.user});

  final String user;

  @override
  State<SimbriefImportDialog> createState() => _SimbriefImportDialogState();
}

class _SimbriefImportDialogState extends State<SimbriefImportDialog> {
  SimbriefOfp? _ofp;
  int? _existingId;

  /// [SimbriefException] or [SimbriefOfflineException].
  Object? _error;
  bool _busy = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final ofp = await context.read<SimbriefClient>().latestOfp(widget.user);
      if (!mounted) return;
      final existing = await context.read<FlightRepository>().flightForOfp(
        ofp.requestId,
      );
      if (!mounted) return;
      setState(() {
        _ofp = ofp;
        _existingId = existing;
      });
    } on SimbriefException catch (e) {
      if (mounted) setState(() => _error = e);
    } on SimbriefOfflineException catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    setState(() => _busy = true);
    final id = await context.read<FlightRepository>().importOfp(_ofp!);
    if (mounted) Navigator.pop(context, id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ofp = _ofp;
    final Widget content;
    if (ofp != null) {
      content = _OfpPreview(ofp, alreadyImported: _existingId != null);
    } else if (_error case final e?) {
      content = Text(
        e is SimbriefException
            ? l10n.simbriefError(e.message)
            : l10n.simbriefOffline,
      );
    } else {
      content = const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return AlertDialog(
      icon: const Icon(Icons.cloud_download_outlined),
      title: Text(l10n.simbriefImport),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(child: content),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        if (_error != null)
          FilledButton(onPressed: _fetch, child: Text(l10n.retry)),
        if (ofp != null && _existingId != null)
          TextButton(
            onPressed: () => Navigator.pop(context, _existingId),
            child: Text(l10n.simbriefOpenExisting),
          ),
        if (ofp != null)
          FilledButton(
            onPressed: _busy ? null : _import,
            child: Text(
              _existingId != null
                  ? l10n.simbriefImportAgain
                  : l10n.simbriefImportAction,
            ),
          ),
      ],
    );
  }
}

class _OfpPreview extends StatelessWidget {
  const _OfpPreview(this.ofp, {required this.alreadyImported});

  final SimbriefOfp ofp;
  final bool alreadyImported;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final weight = context.watch<SettingsController>().weightUnit;
    String mass(double? kg) => kg == null
        ? '–'
        : '${NumberFormat.decimalPattern(locale).format(weight.fromKg(kg).round())} ${weight.symbol}';
    String airport(OfpAirport a) =>
        a.runway == null ? a.icao : '${a.icao} (${a.runway})';
    final alt = ofp.cruiseAltitudeFt;
    final rows = <(String, String)>[
      (l10n.simbriefAircraft, '${ofp.aircraftIcao} ${ofp.registration}'.trim()),
      if (ofp.alternate != null) (l10n.flightAlternate, ofp.alternate!),
      if (alt != null)
        (
          l10n.flightCruiseAltitude,
          alt >= 10000 ? 'FL${(alt / 100).round()}' : '$alt ft',
        ),
      if (ofp.enrouteTime != null)
        (l10n.simbriefEnrouteTime, formatDuration(ofp.enrouteTime!)),
      (l10n.simbriefBlockFuel, mass(ofp.fuel.ramp)),
      if (ofp.generatedAt != null)
        (
          l10n.simbriefGenerated,
          '${DateFormat.yMMMd(locale).add_Hm().format(ofp.generatedAt!.toUtc())} UTC',
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (ofp.callsign.isNotEmpty)
          Text(ofp.callsign, style: theme.textTheme.labelLarge),
        Text(
          '${airport(ofp.origin)} → ${airport(ofp.destination)}',
          style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'monospace'),
        ),
        const SizedBox(height: 12),
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(label, style: theme.textTheme.bodySmall),
                ),
                Expanded(child: Text(value)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Text(l10n.simbriefRoute, style: theme.textTheme.bodySmall),
        SelectableText(
          ofp.route,
          style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.simbriefImportHint(ofp.fixes.length),
          style: theme.textTheme.bodySmall,
        ),
        if (alreadyImported) ...[
          const SizedBox(height: 8),
          Text(
            l10n.simbriefAlreadyImported,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
          ),
        ],
      ],
    );
  }
}
