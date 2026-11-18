import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/charts/chart_document.dart';
import '../../data/charts/chart_naming.dart';
import '../../data/db/database.dart';
import '../../data/repositories/charts_repository.dart';
import '../../l10n/app_localizations.dart';
import 'chart_labels.dart';

/// Picks chart files, lets the user check name, category and airport, and
/// imports them. [idents] are the airports to choose from.
Future<void> importCharts(
  BuildContext context, {
  required List<String> idents,
  required String initialIdent,
}) async {
  final l10n = AppLocalizations.of(context);
  final repo = context.read<ChartsRepository>();
  final messenger = ScaffoldMessenger.of(context);
  final files = await context.read<ChartFileAccess>().pick();
  if (files.isEmpty || !context.mounted) return;
  final entries = await showDialog<List<_Import>>(
    context: context,
    builder: (context) => _ImportDialog(files, idents, initialIdent),
  );
  if (entries == null) return;
  var imported = 0;
  for (final e in entries) {
    try {
      await repo.import(
        e.file.name,
        e.file.read(),
        airportIdent: e.ident,
        name: e.name,
        category: e.category,
      );
      imported++;
    } catch (_) {
      // Counted as not imported; the snackbar shows how many made it.
    }
  }
  messenger.showSnackBar(
    SnackBar(content: Text(l10n.chartsImported(imported, entries.length))),
  );
}

/// Renames a chart, or moves it to another category or airport.
Future<void> editChart(BuildContext context, Chart chart) async {
  final repo = context.read<ChartsRepository>();
  final entry = _Entry(
    PickedChartFile(chart.name, () => const Stream.empty()),
    chart.airportIdent,
    chart.category,
    name: chart.name,
  );
  final ident = TextEditingController(text: chart.airportIdent);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = AppLocalizations.of(context);
      return AlertDialog(
        title: Text(l10n.chartEdit),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: entry.name,
                  decoration: InputDecoration(labelText: l10n.chartName),
                ),
                const SizedBox(height: 12),
                _CategoryField(
                  value: entry.category,
                  onChanged: (c) => setState(() => entry.category = c),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ident,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                    LengthLimitingTextInputFormatter(7),
                  ],
                  decoration: InputDecoration(labelText: l10n.chartAirport),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.save),
          ),
        ],
      );
    },
  );
  if (ok == true &&
      entry.name.text.trim().isNotEmpty &&
      ident.text.trim().isNotEmpty) {
    await repo.update(
      chart.id,
      airportIdent: ident.text.trim(),
      name: entry.name.text,
      category: entry.category,
    );
  }
  entry.name.dispose();
  ident.dispose();
}

typedef _Import = ({
  PickedChartFile file,
  String ident,
  String name,
  ChartCategory category,
});

class _Entry {
  _Entry(this.file, this.ident, this.category, {String? name})
    : name = TextEditingController(text: name ?? chartNameFromFile(file.name));

  final PickedChartFile file;
  final TextEditingController name;
  String ident;
  ChartCategory category;

  _Import get value =>
      (file: file, ident: ident, name: name.text, category: category);
}

class _ImportDialog extends StatefulWidget {
  const _ImportDialog(this.files, this.idents, this.initialIdent);

  final List<PickedChartFile> files;
  final List<String> idents;
  final String initialIdent;

  @override
  State<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<_ImportDialog> {
  late final _entries = [
    for (final f in widget.files)
      _Entry(
        f,
        guessAirportIdent(f.name, widget.idents) ?? widget.initialIdent,
        guessChartCategory(f.name),
      ),
  ];

  @override
  void dispose() {
    for (final e in _entries) {
      e.name.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final idents = {...widget.idents}.toList();
    return AlertDialog(
      title: Text(l10n.chartsImportTitle(_entries.length)),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (i, e) in _entries.indexed) ...[
                if (i > 0) const Divider(height: 32),
                TextField(
                  controller: e.name,
                  decoration: InputDecoration(
                    labelText: l10n.chartName,
                    helperText: e.file.name,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _CategoryField(
                        value: e.category,
                        onChanged: (c) => setState(() => e.category = c),
                      ),
                    ),
                    if (idents.length > 1) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: DropdownButtonFormField<String>(
                          initialValue: e.ident,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: l10n.chartAirport,
                          ),
                          items: [
                            for (final ident in idents)
                              DropdownMenuItem(
                                value: ident,
                                child: Text(ident),
                              ),
                          ],
                          onChanged: (v) => setState(() => e.ident = v!),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, [for (final e in _entries) e.value]),
          child: Text(l10n.chartsImport),
        ),
      ],
    );
  }
}

class _CategoryField extends StatelessWidget {
  const _CategoryField({required this.value, required this.onChanged});

  final ChartCategory value;
  final ValueChanged<ChartCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DropdownButtonFormField<ChartCategory>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: l10n.chartCategory),
      items: [
        for (final c in ChartCategory.values)
          DropdownMenuItem(
            value: c,
            child: Row(
              children: [
                Icon(chartCategoryIcon(c), size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    chartCategoryLabel(l10n, c),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
      onChanged: (c) => onChanged(c!),
    );
  }
}
