import 'package:material_ui/material_ui.dart';

import '../../data/db/database.dart';
import '../../l10n/app_localizations.dart';

String chartCategoryLabel(AppLocalizations l10n, ChartCategory c) =>
    switch (c) {
      ChartCategory.airport => l10n.chartCategoryAirport,
      ChartCategory.ground => l10n.chartCategoryGround,
      ChartCategory.departure => l10n.chartCategoryDeparture,
      ChartCategory.arrival => l10n.chartCategoryArrival,
      ChartCategory.approach => l10n.chartCategoryApproach,
      ChartCategory.vfr => l10n.chartCategoryVfr,
      ChartCategory.other => l10n.chartCategoryOther,
    };

IconData chartCategoryIcon(ChartCategory c) => switch (c) {
  ChartCategory.airport => Icons.local_airport_outlined,
  ChartCategory.ground => Icons.local_parking_outlined,
  ChartCategory.departure => Icons.flight_takeoff,
  ChartCategory.arrival => Icons.flight_land,
  ChartCategory.approach => Icons.south_east,
  ChartCategory.vfr => Icons.visibility_outlined,
  ChartCategory.other => Icons.description_outlined,
};
