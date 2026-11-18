import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../kneeboard/kneeboard_controller.dart';
import 'e6b_cards.dart';

/// Classic flight computer: wind, speed/time/fuel, altitudes, airspeeds,
/// climb/descent, turns and unit conversions.
class E6bScreen extends StatefulWidget {
  const E6bScreen({super.key});

  @override
  State<E6bScreen> createState() => _E6bScreenState();
}

class _E6bScreenState extends State<E6bScreen> {
  Map<String, String> _prefill = const {};

  /// Bumped on prefill so every calculator re-creates its inputs.
  int _generation = 0;

  Map<String, String>? _fromFlight(KneeboardController kb) {
    final legs = kb.navlog?.legs;
    final aircraft = kb.data?.aircraft;
    if (legs == null || legs.isEmpty || aircraft == null) return null;
    final leg = kb.currentNavlogLeg ?? legs.first;
    return {
      'tc': leg.trueCourse.round().toString(),
      'tas': '${aircraft.cruiseTas}',
      'windDir': '${leg.windDirection}',
      'windSpeed': '${leg.windSpeedKt}',
      'variation': leg.variation.toStringAsFixed(1),
      if (leg.groundSpeed != null) 'gs': leg.groundSpeed!.round().toString(),
      if (leg.to.altitudeFt != null) 'alt': '${leg.to.altitudeFt}',
      if (leg.trueHeading != null) 'th': leg.trueHeading!.round().toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final flightValues = _fromFlight(context.watch<KneeboardController>());
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navE6b),
        actions: [
          if (flightValues != null)
            TextButton.icon(
              onPressed: () => setState(() {
                _prefill = flightValues;
                _generation++;
              }),
              icon: const Icon(Icons.download_for_offline_outlined),
              label: Text(l10n.e6bFromFlight),
            ),
          if (_prefill.isNotEmpty)
            IconButton(
              tooltip: l10n.e6bClearAll,
              onPressed: () => setState(() {
                _prefill = const {};
                _generation++;
              }),
              icon: const Icon(Icons.clear_all),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final phone = constraints.maxWidth < 600;
          List<Widget> cards({required bool collapsible}) {
            var i = 0;
            Key key() => ValueKey('$_generation-${i++}');
            final p = _prefill;
            return [
              WindTriangleCard(
                key: key(),
                prefill: p,
                collapsible: collapsible,
                initiallyExpanded: true,
              ),
              WindComponentsCard(
                key: key(),
                prefill: p,
                collapsible: collapsible,
              ),
              SpeedTimeDistanceCard(
                key: key(),
                prefill: p,
                collapsible: collapsible,
              ),
              FuelCard(key: key(), prefill: p, collapsible: collapsible),
              AltitudeCard(key: key(), prefill: p, collapsible: collapsible),
              AirspeedCard(key: key(), prefill: p, collapsible: collapsible),
              DescentCard(key: key(), prefill: p, collapsible: collapsible),
              ClimbCard(key: key(), prefill: p, collapsible: collapsible),
              TurnCard(key: key(), prefill: p, collapsible: collapsible),
              ColdTemperatureCard(
                key: key(),
                prefill: p,
                collapsible: collapsible,
              ),
              ConverterCard(key: key(), prefill: p, collapsible: collapsible),
            ];
          }

          if (phone) {
            final list = cards(collapsible: true);
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => list[i],
            );
          }

          // Masonry: distribute cards round-robin over the columns.
          final columns = (constraints.maxWidth / 400).floor().clamp(1, 3);
          final list = cards(collapsible: false);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var c = 0; c < columns; c++) ...[
                  if (c > 0) const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        for (var i = c; i < list.length; i += columns) ...[
                          list[i],
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
