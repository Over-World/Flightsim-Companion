import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/navlog.dart';
import '../../core/settings.dart';
import '../../core/units.dart';
import '../../l10n/app_localizations.dart';

enum NavlogColumn {
  waypoint,
  altitude,
  tc,
  wind,
  wca,
  mh,
  dist,
  gs,
  ete,
  fuel,

  /// Planned fuel remaining over the waypoint.
  remaining,
  eta,
  ato,
}

const planningColumns = [
  NavlogColumn.waypoint,
  NavlogColumn.altitude,
  NavlogColumn.tc,
  NavlogColumn.wind,
  NavlogColumn.wca,
  NavlogColumn.mh,
  NavlogColumn.dist,
  NavlogColumn.gs,
  NavlogColumn.ete,
  NavlogColumn.fuel,
];

const flyingColumns = [
  NavlogColumn.waypoint,
  NavlogColumn.altitude,
  NavlogColumn.mh,
  NavlogColumn.dist,
  NavlogColumn.ete,
  NavlogColumn.eta,
  NavlogColumn.remaining,
  NavlogColumn.ato,
];

/// Paper-style navlog: one row per leg, named after the leg's end point.
class NavlogTable extends StatelessWidget {
  const NavlogTable({
    super.key,
    required this.navlog,
    required this.fuelUnit,
    this.columns = planningColumns,
    this.currentLeg,
    this.etas,
    this.fuelAtTakeoffL,
    this.onTapLeg,
  });

  final Navlog navlog;
  final FuelUnit fuelUnit;
  final List<NavlogColumn> columns;

  /// Highlighted leg index (kneeboard).
  final int? currentLeg;

  /// Estimated time over per leg end, same length as the legs.
  final List<DateTime?>? etas;

  /// Basis for [NavlogColumn.remaining].
  final double? fuelAtTakeoffL;
  final ValueChanged<int>? onTapLeg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final mono = theme.textTheme.bodyMedium!.copyWith(
      fontFamily: 'monospace',
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final header = theme.textTheme.labelSmall!.copyWith(
      color: scheme.onSurfaceVariant,
      fontWeight: FontWeight.bold,
    );
    final time = DateFormat.Hm();

    String label(NavlogColumn c) => switch (c) {
      NavlogColumn.waypoint => l10n.navlogWaypoint,
      NavlogColumn.altitude => 'ALT',
      NavlogColumn.tc => 'TC',
      NavlogColumn.wind => l10n.navlogWind,
      NavlogColumn.wca => 'WCA',
      NavlogColumn.mh => 'MH',
      NavlogColumn.dist => 'NM',
      NavlogColumn.gs => 'GS',
      NavlogColumn.ete => 'ETE',
      NavlogColumn.fuel => fuelUnit.symbol,
      NavlogColumn.remaining => 'REM',
      NavlogColumn.eta => 'ETA',
      NavlogColumn.ato => 'ATO',
    };

    String cell(NavlogColumn c, int i) {
      final leg = navlog.legs[i];
      return switch (c) {
        NavlogColumn.waypoint => leg.to.ident,
        NavlogColumn.altitude => leg.to.altitudeFt?.toString() ?? '–',
        NavlogColumn.tc => formatCourse(leg.trueCourse),
        NavlogColumn.wind =>
          leg.windSpeedKt == 0
              ? l10n.navlogCalm
              : '${formatCourse(leg.windDirection.toDouble())}/${leg.windSpeedKt}',
        NavlogColumn.wca =>
          leg.windCorrectionAngle == null
              ? '!'
              : _signed(leg.windCorrectionAngle!),
        NavlogColumn.mh =>
          leg.magneticHeading == null
              ? '!'
              : formatCourse(leg.magneticHeading!),
        NavlogColumn.dist => leg.distanceNm.toStringAsFixed(1),
        NavlogColumn.gs => leg.groundSpeed?.round().toString() ?? '!',
        NavlogColumn.ete => leg.ete == null ? '!' : formatDuration(leg.ete!),
        NavlogColumn.fuel =>
          leg.fuelL == null
              ? '!'
              : fuelUnit.fromLiters(leg.fuelL!).toStringAsFixed(1),
        NavlogColumn.remaining =>
          fuelAtTakeoffL == null || leg.cumulativeFuelL == null
              ? '–'
              : fuelUnit
                    .fromLiters(fuelAtTakeoffL! - leg.cumulativeFuelL!)
                    .toStringAsFixed(0),
        NavlogColumn.eta => switch (etas?[i]) {
          final t? => time.format(t),
          _ => '–',
        },
        NavlogColumn.ato => switch (leg.to.actualTimeOver) {
          final t? => time.format(t),
          _ => '',
        },
      };
    }

    final rows = <TableRow>[
      TableRow(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
        ),
        children: [for (final c in columns) _Cell(label(c), header, c)],
      ),
      for (var i = 0; i < navlog.legs.length; i++)
        TableRow(
          decoration: BoxDecoration(
            color: i == currentLeg
                ? scheme.primaryContainer
                : (navlog.legs[i].to.actualTimeOver != null
                      ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                      : null),
            border: Border(
              bottom: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          children: [
            for (final c in columns)
              TableRowInkWell(
                onTap: onTapLeg == null ? null : () => onTapLeg!(i),
                child: _Cell(
                  cell(c, i),
                  c == NavlogColumn.waypoint
                      ? mono.copyWith(fontWeight: FontWeight.bold)
                      : mono.copyWith(
                          color: cell(c, i) == '!' ? scheme.error : null,
                        ),
                  c,
                ),
              ),
          ],
        ),
      TableRow(
        children: [
          for (final c in columns)
            _Cell(
              switch (c) {
                NavlogColumn.waypoint => l10n.navlogTotal,
                NavlogColumn.dist => navlog.totalDistanceNm.toStringAsFixed(1),
                NavlogColumn.ete => switch (navlog.totalTime) {
                  final t? => formatDuration(t),
                  _ => '!',
                },
                NavlogColumn.fuel => switch (navlog.totalFuelL) {
                  final f? => fuelUnit.fromLiters(f).toStringAsFixed(1),
                  _ => '!',
                },
                _ => '',
              },
              mono.copyWith(fontWeight: FontWeight.bold),
              c,
            ),
        ],
      ),
    ];

    // Fills the card when there's room, scrolls sideways on phones.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Table(
            defaultColumnWidth: const IntrinsicColumnWidth(),
            columnWidths: const {0: IntrinsicColumnWidth(flex: 1)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: rows,
          ),
        ),
      ),
    );
  }

  static String _signed(double v) {
    final r = v.round();
    return r == 0 ? '0' : (r > 0 ? '+$r' : '$r');
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, this.style, this.column);

  final String text;
  final TextStyle style;
  final NavlogColumn column;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: column == NavlogColumn.waypoint ? 64 : 36,
      ),
      child: Text(
        text,
        style: style,
        textAlign: column == NavlogColumn.waypoint
            ? TextAlign.start
            : TextAlign.end,
      ),
    ),
  );
}
