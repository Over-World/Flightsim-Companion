import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/navlog.dart';
import '../../core/theme.dart';
import '../../data/weather/weather_models.dart';
import '../../l10n/app_localizations.dart';
import 'weather_controller.dart';

/// METAR (decoded and raw) and TAF of an airport, or of the nearest
/// station when the airport has none.
class WeatherCard extends StatefulWidget {
  const WeatherCard({
    super.key,
    required this.airportIdent,
    this.title,
    this.onUseWind,
    this.margin = EdgeInsets.zero,
  });

  final String airportIdent;
  final String? title;

  /// Shown as "use wind" when the METAR has a usable wind (true direction).
  final void Function(int direction, int speed)? onUseWind;
  final EdgeInsetsGeometry margin;

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  bool _showTaf = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(WeatherCard old) {
    super.didUpdateWidget(old);
    if (old.airportIdent != widget.airportIdent) _load();
  }

  void _load() {
    final c = context.read<WeatherController>();
    // Offline cache first, then the network (served from cache if fresh).
    c.loadCached(widget.airportIdent).then((_) {
      if (mounted) c.refresh(widget.airportIdent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final c = context.watch<WeatherController>();
    final ident = widget.airportIdent;
    final report = c.report(ident);
    final loading = c.isLoading(ident);
    final error = c.error(ident);
    final metar = report?.metar;

    return Card(
      margin: widget.margin,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title ?? l10n.weatherTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                if (metar != null) CategoryBadge(metar.category),
                IconButton(
                  tooltip: l10n.weatherRefresh,
                  onPressed: loading
                      ? null
                      : () => c.refresh(ident, force: true),
                  icon: loading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _body(context, l10n, report, error, loading),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    AppLocalizations l10n,
    WeatherReport? report,
    Object? error,
    bool loading,
  ) {
    final theme = Theme.of(context);
    if (report == null) {
      if (error != null) {
        return Text(
          l10n.weatherError('$error'),
          style: TextStyle(color: theme.colorScheme.error),
        );
      }
      return Text(loading ? l10n.weatherLoading : '');
    }
    if (report.isEmpty) return Text(l10n.weatherNone);

    final metar = report.metar;
    final taf = report.taf;
    final raw = monoStyle(context, base: theme.textTheme.bodySmall);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (metar != null) ...[
          Text(
            [
              if (!report.isLocal)
                l10n.weatherNearby(metar.station, report.distanceNm.round()),
              l10n.weatherObserved(
                _utc(metar.observed),
                _age(l10n, DateTime.now().difference(metar.observed)),
              ),
            ].join(' · '),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _isOld(metar.observed) ? theme.colorScheme.error : null,
            ),
          ),
          const SizedBox(height: 12),
          _Decoded(metar),
          const SizedBox(height: 12),
          SelectableText(metar.raw, style: raw),
          if (widget.onUseWind != null && metar.hasUsableWind)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton.icon(
                onPressed: () =>
                    widget.onUseWind!(metar.windDirection!, metar.windSpeedKt!),
                icon: const Icon(Icons.air),
                label: Text(
                  l10n.weatherUseWind(
                    formatCourse(metar.windDirection!.toDouble()),
                    metar.windSpeedKt!,
                  ),
                ),
              ),
            ),
        ],
        if (taf != null) ...[
          const SizedBox(height: 4),
          TextButton.icon(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () => setState(() => _showTaf = !_showTaf),
            icon: Icon(_showTaf ? Icons.expand_less : Icons.expand_more),
            label: Text(_showTaf ? l10n.weatherHideTaf : l10n.weatherShowTaf),
          ),
          if (_showTaf || metar == null) SelectableText(taf.raw, style: raw),
        ],
      ],
    );
  }

  static bool _isOld(DateTime observed) =>
      DateTime.now().difference(observed) > const Duration(minutes: 90);

  static String _utc(DateTime t) {
    final u = t.toUtc();
    return '${u.hour.toString().padLeft(2, '0')}'
        '${u.minute.toString().padLeft(2, '0')}Z';
  }

  static String _age(AppLocalizations l10n, Duration d) {
    return d.inMinutes < 60
        ? l10n.weatherAgeMinutes(d.inMinutes.clamp(0, 59))
        : l10n.weatherAgeHours(d.inHours);
  }
}

class _Decoded extends StatelessWidget {
  const _Decoded(this.metar);

  final Metar metar;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final String wind;
    if (metar.windSpeedKt == null) {
      wind = '–';
    } else if (metar.windSpeedKt == 0) {
      wind = l10n.navlogCalm;
    } else {
      final dir = metar.windVariable
          ? 'VRB'
          : '${formatCourse(metar.windDirection?.toDouble() ?? 0)}°';
      final gust = metar.gustKt == null ? '' : 'G${metar.gustKt}';
      wind = '$dir ${metar.windSpeedKt}$gust kt';
    }

    final String visibility;
    if (metar.visibilityTenKmOrMore) {
      visibility = '≥ 10 km';
    } else if (metar.visibilityMeters case final m?) {
      visibility = m >= 5000 ? '${(m / 1000).toStringAsFixed(1)} km' : '$m m';
    } else {
      visibility = '–';
    }

    final clouds = metar.clouds.isEmpty
        ? '–'
        : metar.clouds
              .map((c) => c.baseFt == null ? c.cover : '${c.cover} ${c.baseFt}')
              .join(' · ');

    String temp(double? t) => t == null ? '–' : t.round().toString();

    Widget value(String label, String text, {bool large = false}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        Text(
          text,
          style: monoStyle(
            context,
            base: large
                ? theme.textTheme.headlineSmall
                : theme.textTheme.titleMedium,
          ),
        ),
      ],
    );

    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: [
        value(
          'QNH',
          metar.qnhHpa == null ? '–' : metar.qnhHpa!.round().toString(),
          large: true,
        ),
        value(l10n.e6bWind, wind, large: true),
        value(l10n.weatherVisibility, visibility),
        value(l10n.weatherClouds, clouds),
        value(
          l10n.weatherTemperature,
          '${temp(metar.temperatureC)} / ${temp(metar.dewpointC)} °C',
        ),
        if (metar.weather != null) value(l10n.weatherPhenomena, metar.weather!),
      ],
    );
  }
}

/// VFR / MVFR / IFR / LIFR in the usual colours.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge(this.category, {super.key});

  final FlightCategory category;

  @override
  Widget build(BuildContext context) {
    if (category == FlightCategory.unknown) return const SizedBox.shrink();
    final (label, color) = switch (category) {
      FlightCategory.vfr => ('VFR', const Color(0xFF2E7D32)),
      FlightCategory.mvfr => ('MVFR', const Color(0xFF1565C0)),
      FlightCategory.ifr => ('IFR', const Color(0xFFC62828)),
      _ => ('LIFR', const Color(0xFF8E24AA)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
