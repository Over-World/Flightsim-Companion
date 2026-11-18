import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/db/database.dart';
import '../../data/repositories/navdata_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state.dart';
import '../navdata/navdata_missing_card.dart';
import 'airport_type.dart';

class AirportSearchScreen extends StatefulWidget {
  const AirportSearchScreen({super.key});

  @override
  State<AirportSearchScreen> createState() => _AirportSearchScreenState();
}

class _AirportSearchScreenState extends State<AirportSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<Airport> _results = const [];
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final results = await context.read<NavdataRepository>().searchAirports(
        value,
      );
      if (!mounted) return;
      setState(() {
        _query = value.trim();
        _results = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.airportSearchTitle)),
      body: Column(
        children: [
          const NavdataMissingCard(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: l10n.airportSearchHint,
              ),
              onChanged: _onChanged,
            ),
          ),
          Expanded(child: _buildResults(l10n)),
        ],
      ),
    );
  }

  Widget _buildResults(AppLocalizations l10n) {
    if (_query.length < 2) return const SizedBox.shrink();
    if (_results.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: l10n.airportSearchNoResults(_query),
      );
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, i) {
        final a = _results[i];
        final place = [a.municipality, a.isoCountry].nonNulls.join(', ');
        return ListTile(
          leading: Icon(airportTypeIcon(a.type)),
          title: Text(a.name),
          subtitle: Text(place),
          trailing: Text(a.ident, style: monoStyle(context)),
          onTap: () => context.go('/plan/airports/${a.id}'),
        );
      },
    );
  }
}
