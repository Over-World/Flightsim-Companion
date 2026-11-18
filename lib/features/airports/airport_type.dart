import 'package:material_ui/material_ui.dart';

import '../../l10n/app_localizations.dart';

IconData airportTypeIcon(String type) => switch (type) {
  'heliport' => Icons.hub_outlined,
  'seaplane_base' => Icons.water,
  'large_airport' => Icons.local_airport,
  _ => Icons.flight_outlined,
};

String airportTypeLabel(AppLocalizations l10n, String type) => switch (type) {
  'large_airport' => l10n.airportTypeLarge,
  'medium_airport' => l10n.airportTypeMedium,
  'small_airport' => l10n.airportTypeSmall,
  'heliport' => l10n.airportTypeHeliport,
  'seaplane_base' => l10n.airportTypeSeaplane,
  _ => type,
};
