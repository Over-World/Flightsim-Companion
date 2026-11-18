import 'settings.dart';

const double litersPerUsGallon = 3.785411784;
const double poundsPerKilogram = 2.20462262;
const double feetPerMeter = 3.28084;

extension FuelUnitX on FuelUnit {
  double fromLiters(double liters) =>
      this == FuelUnit.liters ? liters : liters / litersPerUsGallon;
  double toLiters(double value) =>
      this == FuelUnit.liters ? value : value * litersPerUsGallon;
  String get symbol => this == FuelUnit.liters ? 'L' : 'USG';
}

extension WeightUnitX on WeightUnit {
  double fromKg(double kg) =>
      this == WeightUnit.kilograms ? kg : kg * poundsPerKilogram;
  double toKg(double value) =>
      this == WeightUnit.kilograms ? value : value / poundsPerKilogram;
  String get symbol => this == WeightUnit.kilograms ? 'kg' : 'lb';
}

/// COM frequencies always with three decimals, e.g. `121.505`.
String formatMhz(double mhz) => mhz.toStringAsFixed(3);

/// VOR/DME frequencies are given in kHz in the source data; everything at
/// or above 108 MHz is shown in MHz, NDBs stay in kHz.
String formatNavaidFrequency(int khz) =>
    khz >= 108000 ? (khz / 1000).toStringAsFixed(2) : '$khz';

bool isMhzNavaid(int khz) => khz >= 108000;
