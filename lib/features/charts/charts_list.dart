import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/db/database.dart';
import '../../data/repositories/charts_repository.dart';
import '../../l10n/app_localizations.dart';
import 'chart_labels.dart';
import 'import_charts_dialog.dart';

/// An airport whose charts are listed, e.g. "Departure" · EDDF.
class ChartAirport {
  const ChartAirport(this.ident, [this.role]);

  final String ident;
  final String? role;
}

enum ChartsListStyle {
  /// List tiles with edit and delete, plus an import button per airport.
  tiles,

  /// Compact chips that open the chart (kneeboard).
  chips,
}

/// Charts of one or more airports, grouped by airport and sorted by
/// category. Opening a chart from a flight keeps its ink with that flight.
class ChartsList extends StatelessWidget {
  const ChartsList({
    super.key,
    required this.airports,
    this.flightId,
    this.style = ChartsListStyle.tiles,
  });

  final List<ChartAirport> airports;
  final int? flightId;
  final ChartsListStyle style;

  void _open(BuildContext context, Chart chart) => context.push(
    flightId == null
        ? '/charts/${chart.id}'
        : '/charts/${chart.id}?flight=$flightId',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final idents = [for (final a in airports) a.ident.toUpperCase()];
    return StreamBuilder(
      stream: context.read<ChartsRepository>().watchForAirports(idents),
      builder: (context, snapshot) {
        final charts = [...?snapshot.data]
          ..sort(
            (a, b) => a.category != b.category
                ? a.category.index.compareTo(b.category.index)
                : a.name.compareTo(b.name),
          );
        final seen = <String>{};
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final airport in airports)
              if (seen.add(airport.ident.toUpperCase()))
                _airport(context, l10n, theme, airport, [
                  for (final c in charts)
                    if (c.airportIdent == airport.ident.toUpperCase()) c,
                ], idents),
          ],
        );
      },
    );
  }

  Widget _airport(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    ChartAirport airport,
    List<Chart> charts,
    List<String> idents,
  ) {
    final title = [?airport.role, airport.ident].join(' · ');
    if (style == ChartsListStyle.chips) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.labelMedium),
            const SizedBox(height: 4),
            if (charts.isEmpty)
              Text(l10n.chartsNone, style: theme.textTheme.bodySmall)
            else
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final c in charts)
                    ActionChip(
                      avatar: Icon(chartCategoryIcon(c.category), size: 18),
                      label: Text(c.name),
                      onPressed: () => _open(context, c),
                    ),
                ],
              ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => importCharts(
                  context,
                  idents: idents,
                  initialIdent: airport.ident.toUpperCase(),
                ),
                icon: const Icon(Icons.upload_file),
                label: Text(l10n.chartsImport),
              ),
            ],
          ),
          if (charts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l10n.chartsNoneHint,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          for (final c in charts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(chartCategoryIcon(c.category)),
              title: Text(c.name),
              subtitle: Text(
                '${chartCategoryLabel(l10n, c.category)} · '
                '${c.fileType == ChartFileType.pdf ? 'PDF' : l10n.chartImage}',
              ),
              onTap: () => _open(context, c),
              trailing: PopupMenuButton<String>(
                onSelected: (v) => v == 'edit'
                    ? editChart(context, c)
                    : _confirmDelete(context, c),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text(l10n.chartEdit)),
                  PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Chart chart) async {
    final l10n = AppLocalizations.of(context);
    final repo = context.read<ChartsRepository>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chartDeleteTitle),
        content: Text(l10n.chartDeleteMessage(chart.name)),
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
    if (ok == true) await repo.delete(chart);
  }
}
