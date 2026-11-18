import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../data/db/database.dart';
import '../data/repositories/navdata_repository.dart';
import '../features/airports/airport_type.dart';
import '../l10n/app_localizations.dart';

/// Opens a search dialog and returns the chosen airport.
Future<Airport?> showAirportPicker(BuildContext context, {String? title}) {
  final fullscreen = MediaQuery.sizeOf(context).width < 600;
  return showDialog<Airport>(
    context: context,
    builder: (context) => fullscreen
        ? Dialog.fullscreen(child: _AirportPicker(title: title))
        : Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
              child: _AirportPicker(title: title),
            ),
          ),
  );
}

class _AirportPicker extends StatefulWidget {
  const _AirportPicker({this.title});

  final String? title;

  @override
  State<_AirportPicker> createState() => _AirportPickerState();
}

class _AirportPickerState extends State<_AirportPicker> {
  Timer? _debounce;
  List<Airport> _results = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      final results = await context.read<NavdataRepository>().searchAirports(
        query,
        limit: 30,
      );
      if (mounted) setState(() => _results = results);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          leading: const CloseButton(),
          title: Text(widget.title ?? l10n.airportSearchTitle),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.airportSearchHint,
            ),
            onChanged: _search,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, i) {
              final a = _results[i];
              return ListTile(
                leading: Icon(airportTypeIcon(a.type)),
                title: Text(a.name),
                subtitle: Text(
                  [a.municipality, a.isoCountry].nonNulls.join(', '),
                ),
                trailing: Text(a.ident, style: monoStyle(context)),
                onTap: () => Navigator.pop(context, a),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Read-only field showing an airport ident; tap opens the picker.
class AirportField extends StatelessWidget {
  const AirportField({
    super.key,
    required this.label,
    required this.ident,
    required this.onChanged,
    this.name,
    this.optional = false,
    this.errorText,
  });

  final String label;
  final String? ident;
  final String? name;
  final ValueChanged<Airport?> onChanged;
  final bool optional;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasValue = ident != null && ident!.isNotEmpty;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final airport = await showAirportPicker(context, title: label);
        if (airport != null) onChanged(airport);
      },
      child: InputDecorator(
        isEmpty: !hasValue,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: hasValue && optional
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => onChanged(null),
                )
              : const Icon(Icons.search),
        ),
        child: hasValue
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: ident, style: monoStyle(context)),
                    if (name != null) TextSpan(text: '  $name'),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
      ),
    );
  }
}
