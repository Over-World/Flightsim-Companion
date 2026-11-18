import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/quantities.dart';
import '../../core/theme.dart';

double? parseNumber(String text) =>
    double.tryParse(text.trim().replaceAll(',', '.'));

/// A number input with an optional unit switch. Values are read in the
/// quantity's base unit via [baseValue].
class UnitInput {
  UnitInput({this.quantity, String? unit, String text = ''})
    : controller = TextEditingController(text: text),
      unit = unit ?? quantity?.base ?? '';

  final Quantity? quantity;
  final TextEditingController controller;
  String unit;

  double? get value => parseNumber(controller.text);

  double? get baseValue {
    final v = value;
    if (v == null || quantity == null) return v;
    return quantity!.unit(unit).toBase(v);
  }

  void dispose() => controller.dispose();
}

class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.input,
    required this.label,
    required this.onChanged,
    this.suffix,
    this.signed = false,
  });

  final UnitInput input;
  final String label;
  final VoidCallback onChanged;

  /// Fixed unit text when the input has no switchable quantity.
  final String? suffix;
  final bool signed;

  @override
  Widget build(BuildContext context) {
    final q = input.quantity;
    return TextField(
      controller: input.controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
        signed: signed,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(signed ? r'[-0-9.,]' : r'[0-9.,]'),
        ),
      ],
      style: monoStyle(context),
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        suffixText: q == null ? suffix : null,
        suffixIcon: q == null || q.units.length < 2
            ? null
            : PopupMenuButton<String>(
                tooltip: '',
                initialValue: input.unit,
                onSelected: (u) {
                  input.unit = u;
                  onChanged();
                },
                itemBuilder: (context) => [
                  for (final u in q.units)
                    PopupMenuItem(value: u.symbol, child: Text(u.symbol)),
                ],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(input.unit),
                      const Icon(Icons.arrow_drop_down, size: 18),
                    ],
                  ),
                ),
              ),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}

/// Lays out inputs two per row when there is room.
class FieldGrid extends StatelessWidget {
  const FieldGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 300 ? 2 : 1;
        final width = (constraints.maxWidth - 12 * (columns - 1)) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final c in children) SizedBox(width: width, child: c),
          ],
        );
      },
    );
  }
}

class Result {
  const Result(this.label, this.value, {this.highlight = false});

  final String label;

  /// `null` while inputs are missing.
  final String? value;
  final bool highlight;
}

class ResultList extends StatelessWidget {
  const ResultList(this.results, {super.key});

  final List<Result> results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 8,
        children: [
          for (final r in results)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(r.label, style: theme.textTheme.labelMedium),
                Text(
                  r.value ?? '–',
                  style:
                      monoStyle(
                        context,
                        base: r.highlight
                            ? theme.textTheme.headlineSmall
                            : theme.textTheme.titleLarge,
                      ).copyWith(
                        color: r.highlight ? theme.colorScheme.primary : null,
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// A calculator: card on wide screens, expandable tile on phones.
class CalcCard extends StatelessWidget {
  const CalcCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.collapsible = false,
    this.initiallyExpanded = false,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final bool collapsible;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final header = Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
      ],
    );
    if (collapsible) {
      return Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: ExpansionTile(
          title: header,
          initiallyExpanded: initiallyExpanded,
          shape: const Border(),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [child],
        ),
      );
    }
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [header, const SizedBox(height: 16), child],
        ),
      ),
    );
  }
}

/// Base for calculator states: owns its inputs and rebuilds on change.
abstract class CalcState<T extends StatefulWidget> extends State<T> {
  final Map<String, UnitInput> _inputs = {};

  /// Values to prefill, e.g. from the active flight; keys match [input].
  Map<String, String> get prefill;

  UnitInput input(String key, {Quantity? quantity, String? unit}) =>
      _inputs.putIfAbsent(
        key,
        () =>
            UnitInput(quantity: quantity, unit: unit, text: prefill[key] ?? ''),
      );

  double? v(String key) => _inputs[key]?.baseValue;

  void changed() => setState(() {});

  Widget field(
    String key,
    String label, {
    Quantity? quantity,
    String? unit,
    String? suffix,
    bool signed = false,
  }) => NumberField(
    input: input(key, quantity: quantity, unit: unit),
    label: label,
    suffix: suffix,
    signed: signed,
    onChanged: changed,
  );

  @override
  void dispose() {
    for (final i in _inputs.values) {
      i.dispose();
    }
    super.dispose();
  }
}
