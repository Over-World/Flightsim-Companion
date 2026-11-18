import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:material_ui/material_ui.dart';

import 'settings.dart';

const _subThemes = FlexSubThemesData(
  inputDecoratorBorderType: FlexInputBorderType.outline,
  inputDecoratorRadius: 12,
  cardRadius: 16,
  navigationRailUseIndicator: true,
  navigationRailLabelType: NavigationRailLabelType.all,
);

ThemeData lightTheme(AccentColor accent) => FlexThemeData.light(
  scheme: accent.scheme,
  subThemesData: _subThemes,
  visualDensity: VisualDensity.standard,
);

ThemeData darkTheme(AccentColor accent) => FlexThemeData.dark(
  scheme: accent.scheme,
  subThemesData: _subThemes,
  visualDensity: VisualDensity.standard,
);

/// Monospace style for frequencies, idents and other values a pilot reads
/// off at a glance.
TextStyle monoStyle(BuildContext context, {TextStyle? base}) =>
    (base ?? Theme.of(context).textTheme.bodyLarge!).copyWith(
      fontFamily: 'monospace',
      fontFeatures: const [FontFeature.tabularFigures()],
    );
