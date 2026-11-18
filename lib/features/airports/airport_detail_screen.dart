import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/morse.dart';
import '../../core/nav_math.dart';
import '../../core/theme.dart';
import '../../core/wmm/wmm.dart';
import '../../core/units.dart';
import '../../data/db/database.dart';
import '../../data/repositories/navdata_repository.dart';
import '../../l10n/app_localizations.dart';
import '../charts/charts_list.dart';
import '../weather/weather_card.dart';
import 'airport_type.dart';

class AirportDetailScreen extends StatefulWidget {
  const AirportDetailScreen({super.key, required this.airportId});

  final int airportId;

  @override
  State<AirportDetailScreen> createState() => _AirportDetailScreenState();
}

class _AirportDetailScreenState extends State<AirportDetailScreen> {
  late final Future<AirportDetails?> _details = context
      .read<NavdataRepository>()
      .airportDetails(widget.airportId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _details,
      builder: (context, snapshot) {
        final details = snapshot.data;
        return Scaffold(
          appBar: AppBar(title: Text(details?.airport.ident ?? '')),
          body: switch (snapshot.connectionState) {
            ConnectionState.done when details != null => _DetailsBody(details),
            ConnectionState.done => const SizedBox.shrink(),
            _ => const Center(child: CircularProgressIndicator()),
          },
        );
      },
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody(this.details);

  final AirportDetails details;

  @override
  Widget build(BuildContext context) {
    final header = _Header(details.airport);
    final weather = WeatherCard(
      airportIdent: details.airport.ident,
      margin: const EdgeInsets.only(bottom: 8),
    );
    final runways = _RunwaysCard(details.runways);
    final frequencies = _FrequenciesCard(details.frequencies);
    final navaids = _NavaidsCard(details);
    final charts = _SectionCard(
      title: AppLocalizations.of(context).chartsTitle,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ChartsList(airports: [ChartAirport(details.airport.ident)]),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [header, weather, charts, frequencies, runways, navaids],
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              header,
              weather,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Column(children: [frequencies, runways])),
                  const SizedBox(width: 8),
                  Expanded(child: Column(children: [charts, navaids])),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.airport);

  final Airport airport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final place = [
      airport.municipality,
      airport.isoCountry,
    ].nonNulls.join(', ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(airport.name, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(place, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: Icon(airportTypeIcon(airport.type), size: 18),
                label: Text(airportTypeLabel(l10n, airport.type)),
              ),
              if (airport.elevationFt != null)
                Chip(
                  avatar: const Icon(Icons.terrain, size: 18),
                  label: Text(l10n.elevationFt(airport.elevationFt!)),
                ),
              if (airport.iataCode != null)
                Chip(label: Text('IATA ${airport.iataCode}')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _FrequenciesCard extends StatelessWidget {
  const _FrequenciesCard(this.frequencies);

  final List<AirportFrequency> frequencies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SectionCard(
      title: l10n.frequencies,
      children: [
        if (frequencies.isEmpty) ListTile(title: Text(l10n.noFrequencies)),
        for (final f in frequencies)
          ListTile(
            dense: true,
            leading: SizedBox(
              width: 56,
              child: Text(
                f.type,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            title: Text(f.description ?? f.type),
            trailing: Text(
              formatMhz(f.frequencyMhz),
              style: monoStyle(
                context,
                base: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
      ],
    );
  }
}

class _RunwaysCard extends StatelessWidget {
  const _RunwaysCard(this.runways);

  final List<Runway> runways;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _SectionCard(
      title: l10n.runways,
      children: [
        if (runways.isEmpty) ListTile(title: Text(l10n.noRunways)),
        for (final r in runways)
          ListTile(
            leading: const Icon(Icons.horizontal_rule),
            title: Text(
              [r.leIdent, r.heIdent].nonNulls.join(' / '),
              style: monoStyle(context),
            ),
            subtitle: Text(
              [
                if (r.lengthFt != null)
                  l10n.runwayDimensions(
                    r.lengthFt!,
                    (r.lengthFt! / feetPerMeter).round(),
                    r.widthFt ?? 0,
                  ),
                if (r.surface != null) r.surface!,
                if (r.lighted) l10n.runwayLighted,
              ].join(' · '),
            ),
          ),
      ],
    );
  }
}

class _NavaidsCard extends StatelessWidget {
  const _NavaidsCard(this.details);

  final AirportDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final airport = details.airport;
    return _SectionCard(
      title: l10n.navaidsNearby,
      children: [
        if (details.navaids.isEmpty) ListTile(title: Text(l10n.noNavaids)),
        for (final (:navaid, :distanceNm) in details.navaids)
          ListTile(
            isThreeLine: true,
            leading: SizedBox(
              width: 56,
              child: Text(navaid.ident, style: monoStyle(context)),
            ),
            title: Text('${navaid.name} · ${navaid.type}'),
            subtitle: Text(
              '${toMorse(navaid.ident)}\n'
              '${l10n.radialDistance(_radial(navaid, airport), distanceNm.toStringAsFixed(1))}',
            ),
            trailing: navaid.frequencyKhz == null
                ? null
                : Text(
                    formatNavaidFrequency(navaid.frequencyKhz!),
                    style: monoStyle(
                      context,
                      base: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
          ),
      ],
    );
  }

  /// Magnetic radial from the navaid on which the airport lies (WMM).
  String _radial(Navaid n, Airport a) {
    final course = initialCourse(
      n.latitude,
      n.longitude,
      a.latitude,
      a.longitude,
    );
    final variation = magneticVariation(n.latitude, n.longitude);
    final rounded = trueToMagnetic(course, variation).round() % 360;
    return (rounded == 0 ? 360 : rounded).toString().padLeft(3, '0');
  }
}
