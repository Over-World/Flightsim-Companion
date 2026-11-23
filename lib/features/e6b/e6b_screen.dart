import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/settings.dart';
import '../../l10n/app_localizations.dart';
import '../kneeboard/kneeboard_controller.dart';
import 'e6b_cards.dart';
import '../notes/notes_button.dart';

enum E6bGroup { navigation, fuel, atmosphere, climbDescent, conversion }

/// One calculator in the E6B index.
class E6bEntry {
  const E6bEntry({
    required this.id,
    required this.group,
    required this.icon,
    required this.keywords,
    required this.build,
  });

  final String id;
  final E6bGroup group;
  final IconData icon;

  /// Language-independent search terms (abbreviations).
  final String keywords;
  final Widget Function(Key key, Map<String, String> prefill) build;
}

final e6bEntries = <E6bEntry>[
  E6bEntry(
    id: 'windTriangle',
    group: E6bGroup.navigation,
    icon: Icons.navigation_outlined,
    keywords: 'WCA TH MH GS TC TAS wind drift E6B',
    build: (k, p) => WindTriangleCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'windComponents',
    group: E6bGroup.navigation,
    icon: Icons.compare_arrows,
    keywords: 'XW HW TW crosswind runway RWY gust',
    build: (k, p) => WindComponentsCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'speedTimeDistance',
    group: E6bGroup.navigation,
    icon: Icons.timer_outlined,
    keywords: 'GS ETE ETA NM min time',
    build: (k, p) => SpeedTimeDistanceCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'turn',
    group: E6bGroup.navigation,
    icon: Icons.rotate_right,
    keywords: 'rate one standard bank radius 360',
    build: (k, p) => TurnCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'fuel',
    group: E6bGroup.fuel,
    icon: Icons.local_gas_station_outlined,
    keywords: 'fuel L USG kg lb AVGAS Jet-A1 endurance burn',
    build: (k, p) => FuelCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'altitude',
    group: E6bGroup.atmosphere,
    icon: Icons.terrain_outlined,
    keywords: 'PA DA QNH ISA OAT density pressure',
    build: (k, p) => AltitudeCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'airspeed',
    group: E6bGroup.atmosphere,
    icon: Icons.speed,
    keywords: 'IAS CAS TAS Mach',
    build: (k, p) => AirspeedCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'coldTemperature',
    group: E6bGroup.atmosphere,
    icon: Icons.ac_unit,
    keywords: 'cold temperature correction ICAO MDA DA',
    build: (k, p) => ColdTemperatureCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'descent',
    group: E6bGroup.climbDescent,
    icon: Icons.flight_land,
    keywords: 'TOD VS ROD 3° descent',
    build: (k, p) => DescentCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'climb',
    group: E6bGroup.climbDescent,
    icon: Icons.trending_up,
    keywords: 'ROC ft/NM % gradient climb SID',
    build: (k, p) => ClimbCard(key: k, prefill: p),
  ),
  E6bEntry(
    id: 'converter',
    group: E6bGroup.conversion,
    icon: Icons.swap_horiz,
    keywords: 'kt km/h mph ft m NM km °C °F hPa inHg L USG kg lb convert',
    build: (k, p) => ConverterCard(key: k, prefill: p),
  ),
];

/// Classic flight computer: an index with search, recent and groups, and
/// the selected calculator. All calculators stay alive, so values entered
/// are kept while switching.
class E6bScreen extends StatefulWidget {
  const E6bScreen({super.key});

  @override
  State<E6bScreen> createState() => _E6bScreenState();
}

class _E6bScreenState extends State<E6bScreen> {
  Map<String, String> _prefill = const {};

  /// Bumped on prefill so every calculator re-creates its inputs.
  int _generation = 0;
  String? _selected;
  String _query = '';
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

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

  void _select(String id) {
    setState(() => _selected = id);
    context.read<SettingsController>().markE6bUsed(id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final flightValues = _fromFlight(context.watch<KneeboardController>());
    final recent = context.watch<SettingsController>().e6bRecent;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 840;
        final selected =
            _selected ??
            (wide ? (recent.firstOrNull ?? e6bEntries.first.id) : null);
        final entry = e6bEntries.where((e) => e.id == selected).firstOrNull;

        final actions = [
          const NotesButton(),
          if (flightValues != null)
            TextButton.icon(
              onPressed: () => setState(() {
                _prefill = flightValues;
                _generation++;
              }),
              icon: const Icon(Icons.download_for_offline_outlined),
              label: Text(l10n.e6bFromFlight),
            ),
          IconButton(
            tooltip: l10n.e6bClearAll,
            onPressed: () => setState(() {
              _prefill = const {};
              _generation++;
            }),
            icon: const Icon(Icons.clear_all),
          ),
          const SizedBox(width: 8),
        ];

        final detail = _Detail(
          entries: e6bEntries,
          selected: selected,
          prefill: _prefill,
          generation: _generation,
        );
        final index = _Index(
          search: _search,
          query: _query,
          onQuery: (q) => setState(() => _query = q),
          selected: wide ? selected : null,
          recent: recent,
          onSelect: _select,
        );

        if (wide) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.navE6b), actions: actions),
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 320, child: index),
                const VerticalDivider(width: 1),
                Expanded(child: detail),
              ],
            ),
          );
        }

        // Phone: index first; a calculator replaces it, back returns.
        final showDetail = entry != null;
        return PopScope(
          canPop: !showDetail,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) setState(() => _selected = null);
          },
          child: Scaffold(
            appBar: AppBar(
              leading: showDetail
                  ? BackButton(
                      onPressed: () => setState(() => _selected = null),
                    )
                  : null,
              title: Text(showDetail ? e6bTitle(l10n, entry.id) : l10n.navE6b),
              actions: actions,
            ),
            // Both stay mounted so values survive going back to the index.
            body: IndexedStack(
              index: showDetail ? 1 : 0,
              children: [index, detail],
            ),
          ),
        );
      },
    );
  }
}

String e6bTitle(AppLocalizations l10n, String id) => switch (id) {
  'windTriangle' => l10n.e6bWindTriangle,
  'windComponents' => l10n.e6bWindComponents,
  'speedTimeDistance' => l10n.e6bSpeedTimeDistance,
  'turn' => l10n.e6bTurn,
  'fuel' => l10n.e6bFuel,
  'altitude' => l10n.e6bAltitude,
  'airspeed' => l10n.e6bAirspeed,
  'coldTemperature' => l10n.e6bColdTemperature,
  'descent' => l10n.e6bDescent,
  'climb' => l10n.e6bClimbGradient,
  _ => l10n.e6bConverter,
};

String e6bHint(AppLocalizations l10n, String id) => switch (id) {
  'windTriangle' => l10n.e6bWindTriangleHint,
  'windComponents' => l10n.e6bWindComponentsHint,
  'speedTimeDistance' => l10n.e6bSpeedTimeDistanceHint,
  'turn' => l10n.e6bTurnHint,
  'fuel' => l10n.e6bFuelHint,
  'altitude' => l10n.e6bAltitudeHint,
  'airspeed' => l10n.e6bAirspeedHint,
  'coldTemperature' => l10n.e6bColdTemperatureHint,
  'descent' => l10n.e6bDescentHint,
  'climb' => l10n.e6bClimbHint,
  _ => l10n.e6bConverterHint,
};

String _groupTitle(AppLocalizations l10n, E6bGroup g) => switch (g) {
  E6bGroup.navigation => l10n.e6bGroupNavigation,
  E6bGroup.fuel => l10n.e6bGroupFuel,
  E6bGroup.atmosphere => l10n.e6bGroupAtmosphere,
  E6bGroup.climbDescent => l10n.e6bGroupClimbDescent,
  E6bGroup.conversion => l10n.e6bGroupConversion,
};

class _Index extends StatelessWidget {
  const _Index({
    required this.search,
    required this.query,
    required this.onQuery,
    required this.selected,
    required this.recent,
    required this.onSelect,
  });

  final TextEditingController search;
  final String query;
  final ValueChanged<String> onQuery;
  final String? selected;
  final List<String> recent;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final q = query.trim().toLowerCase();

    // An entry can appear twice (recent and its group): key per section.
    Widget tile(E6bEntry e, String section) => ListTile(
      key: ValueKey('$section-${e.id}'),
      leading: Icon(e.icon),
      title: Text(e6bTitle(l10n, e.id)),
      subtitle: Text(
        e6bHint(l10n, e.id),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      selected: e.id == selected,
      selectedTileColor: theme.colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () => onSelect(e.id),
    );

    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );

    final List<Widget> children;
    if (q.isNotEmpty) {
      final matches = e6bEntries.where((e) {
        final haystack =
            '${e6bTitle(l10n, e.id)} ${e6bHint(l10n, e.id)} ${e.keywords}'
                .toLowerCase();
        return q.split(RegExp(r'\s+')).every(haystack.contains);
      }).toList();
      children = matches.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.e6bNoMatch),
              ),
            ]
          : [for (final e in matches) tile(e, 'search')];
    } else {
      final recentEntries = [
        for (final id in recent.take(3)) ...e6bEntries.where((e) => e.id == id),
      ];
      children = [
        if (recentEntries.isNotEmpty) ...[
          header(l10n.e6bRecent),
          for (final e in recentEntries) tile(e, 'recent'),
        ],
        for (final g in E6bGroup.values) ...[
          header(_groupTitle(l10n, g)),
          for (final e in e6bEntries.where((e) => e.group == g))
            tile(e, g.name),
        ],
      ];
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
          child: TextField(
            controller: search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.e6bSearchHint,
              isDense: true,
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        search.clear();
                        onQuery('');
                      },
                    ),
            ),
            onChanged: onQuery,
          ),
        ),
        ...children,
      ],
    );
  }
}

/// All calculators stay mounted; only the selected one is visible.
class _Detail extends StatelessWidget {
  const _Detail({
    required this.entries,
    required this.selected,
    required this.prefill,
    required this.generation,
  });

  final List<E6bEntry> entries;
  final String? selected;
  final Map<String, String> prefill;
  final int generation;

  @override
  Widget build(BuildContext context) {
    final index = entries.indexWhere((e) => e.id == selected);
    return IndexedStack(
      index: index < 0 ? 0 : index,
      children: [
        for (final e in entries)
          SingleChildScrollView(
            key: PageStorageKey('e6b-scroll-${e.id}'),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: e.build(ValueKey('$generation-${e.id}'), prefill),
              ),
            ),
          ),
      ],
    );
  }
}
