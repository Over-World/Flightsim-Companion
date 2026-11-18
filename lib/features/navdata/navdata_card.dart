import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../data/navdata/navdata_importer.dart';
import '../../l10n/app_localizations.dart';
import 'navdata_controller.dart';

/// Navdata status, counts and the download/update action.
class NavdataCard extends StatelessWidget {
  const NavdataCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final navdata = context.watch<NavdataController>();
    final importedAt = context.watch<SettingsController>().navdataImportedAt;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final counts = navdata.counts;
    final progress = navdata.progress;
    final number = NumberFormat.decimalPattern(locale);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              importedAt == null
                  ? l10n.navdataNeverImported
                  : l10n.navdataImportedAt(
                      DateFormat.yMMMd(locale).add_Hm().format(importedAt),
                    ),
              style: theme.textTheme.bodyLarge,
            ),
            if (counts != null && navdata.hasData) ...[
              const SizedBox(height: 8),
              Text(
                l10n.navdataCounts(
                  number.format(counts.airports),
                  number.format(counts.runways),
                  number.format(counts.frequencies),
                  number.format(counts.navaids),
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (navdata.isImporting && progress != null) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: progress.fraction),
              const SizedBox(height: 8),
              Text(_stageLabel(l10n, progress)),
            ],
            if (navdata.error != null) ...[
              const SizedBox(height: 16),
              Text(
                l10n.navdataImportFailed('${navdata.error}'),
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                Text(
                  l10n.navdataSource,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                FilledButton.icon(
                  onPressed: navdata.isImporting ? null : navdata.startImport,
                  icon: const Icon(Icons.download),
                  label: Text(
                    navdata.hasData ? l10n.navdataUpdate : l10n.navdataDownload,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _stageLabel(AppLocalizations l10n, ImportProgress p) =>
      switch (p.stage) {
        ImportStage.downloading => l10n.navdataStageDownloading(p.file ?? ''),
        ImportStage.parsing => l10n.navdataStageParsing,
        ImportStage.writing => l10n.navdataStageWriting,
        ImportStage.done => '',
      };
}
