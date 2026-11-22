import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/navlog.dart';
import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/repositories/logbook_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';

enum TouchdownRating { butter, smooth, firm, hard, inspect }

/// A light-hearted verdict on the descent rate at touchdown (fpm).
TouchdownRating rateTouchdown(double fpm) => switch (fpm.abs()) {
  <= 120 => TouchdownRating.butter,
  <= 240 => TouchdownRating.smooth,
  <= 400 => TouchdownRating.firm,
  <= 600 => TouchdownRating.hard,
  _ => TouchdownRating.inspect,
};

String touchdownLabel(AppLocalizations l10n, TouchdownRating r) => switch (r) {
  TouchdownRating.butter => l10n.touchdownButter,
  TouchdownRating.smooth => l10n.touchdownSmooth,
  TouchdownRating.firm => l10n.touchdownFirm,
  TouchdownRating.hard => l10n.touchdownHard,
  TouchdownRating.inspect => l10n.touchdownInspect,
};

class LogbookScreen extends StatelessWidget {
  const LogbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navLogbook)),
      body: StreamBuilder(
        stream: context.read<LogbookRepository>().watchAll(),
        builder: (context, snapshot) {
          final entries = snapshot.data;
          if (entries == null) return const SizedBox.shrink();
          if (entries.isEmpty) {
            return EmptyState(
              icon: Icons.menu_book_outlined,
              title: l10n.logbookEmptyTitle,
              message: l10n.logbookEmptyMessage,
            );
          }
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                children: [
                  _Totals(LogbookTotals.of(entries)),
                  const SizedBox(height: 8),
                  for (final e in entries) _EntryTile(e),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals(this.totals);

  final LogbookTotals totals;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget stat(String label, String value) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        Text(
          value,
          style: monoStyle(context, base: theme.textTheme.headlineSmall),
        ),
      ],
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 32,
          runSpacing: 12,
          children: [
            stat(l10n.logbookFlights, '${totals.flights}'),
            stat(l10n.timeBlock, formatDuration(totals.block)),
            stat(l10n.timeFlight, formatDuration(totals.air)),
            stat(l10n.logbookLandings, '${totals.landings}'),
          ],
        ),
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile(this.entry);

  final LogbookEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final e = entry;
    final block = e.blockOnAt.difference(e.blockOffAt);
    final fpm = e.touchdownFpm;
    return Card(
      child: ListTile(
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => _EntrySheet(e),
        ),
        title: Text('${e.departureIdent} → ${e.destinationIdent}'),
        subtitle: Text(
          [
            DateFormat.yMMMd(l10n.localeName).format(e.blockOffAt),
            ?e.aircraftName,
            l10n.logbookBlockShort(formatDuration(block)),
          ].join(' · '),
        ),
        trailing: fpm == null
            ? null
            : _RatingChip(rateTouchdown(fpm), fpm, compact: true),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip(this.rating, this.fpm, {this.compact = false});

  final TouchdownRating rating;
  final double fpm;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (rating) {
      TouchdownRating.butter || TouchdownRating.smooth => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      TouchdownRating.firm => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      _ => (scheme.errorContainer, scheme.onErrorContainer),
    };
    final text = compact
        ? '${fpm.abs().round()} fpm'
        : '${touchdownLabel(l10n, rating)} · ${fpm.abs().round()} fpm';
    return Chip(
      label: Text(text, style: TextStyle(color: fg)),
      backgroundColor: bg,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _EntrySheet extends StatefulWidget {
  const _EntrySheet(this.entry);

  final LogbookEntry entry;

  @override
  State<_EntrySheet> createState() => _EntrySheetState();
}

class _EntrySheetState extends State<_EntrySheet> {
  late final _remarks = TextEditingController(text: widget.entry.remarks);
  late final LogbookRepository _repo = context.read<LogbookRepository>();

  @override
  void dispose() {
    if (_remarks.text.trim() != widget.entry.remarks) {
      _repo.setRemarks(widget.entry.id, _remarks.text);
    }
    _remarks.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logbookDeleteTitle),
        content: Text(l10n.logbookDeleteMessage),
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
    if (ok != true || !mounted) return;
    _remarks.text = widget.entry.remarks;
    await _repo.delete(widget.entry.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final e = widget.entry;
    final hm = DateFormat.Hm();
    String time(DateTime? t) => t == null ? '–' : hm.format(t);
    final air = e.takeoffAt != null && e.landingAt != null
        ? formatDuration(e.landingAt!.difference(e.takeoffAt!))
        : '–';
    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(value, style: monoStyle(context)),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${e.departureIdent} → ${e.destinationIdent}',
              style: theme.textTheme.headlineSmall,
            ),
            Text(
              [
                DateFormat.yMMMMd(l10n.localeName).format(e.blockOffAt),
                e.rules.name.toUpperCase(),
                ?e.aircraftName,
              ].join(' · '),
            ),
            if (e.touchdownFpm != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: _RatingChip(
                  rateTouchdown(e.touchdownFpm!),
                  e.touchdownFpm!,
                ),
              ),
            ],
            const SizedBox(height: 12),
            row(l10n.timeBlockOff, time(e.blockOffAt)),
            row(l10n.timeTakeoff, time(e.takeoffAt)),
            row(l10n.timeLanding, time(e.landingAt)),
            row(l10n.timeBlockOn, time(e.blockOnAt)),
            const Divider(height: 24),
            row(
              l10n.timeBlock,
              formatDuration(e.blockOnAt.difference(e.blockOffAt)),
            ),
            row(l10n.timeFlight, air),
            row(l10n.logbookLandings, '${e.landings}'),
            if (e.distanceNm != null)
              row(l10n.logbookDistance, '${e.distanceNm!.round()} NM'),
            if (e.touchdownG != null)
              row(
                l10n.logbookTouchdownG,
                '${e.touchdownG!.toStringAsFixed(2)} G',
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _remarks,
              minLines: 2,
              maxLines: 5,
              decoration: InputDecoration(labelText: l10n.logbookRemarks),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.delete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
